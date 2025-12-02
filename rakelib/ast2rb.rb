# frozen_string_literal: true

require "json"

class AST2Rb
  class << self
    def load_file(path)
      JSON.load_file(path, freeze: true, symbolize_names: true)
    end
  end

  class EntryClassifier
    def initialize
      @st_types = []
    end

    def struct_type?(name) = @st_types.include?(name)

    def classify(node)
      case node

      # Enum entry
      #
      in {tag: "enum"}
        :enum

      # Function entry
      #
      in {tag: "function" => tag, name:, "storage-class": sc} if sc != "extern"
        warn "skipping #{tag}: #{name} - no external linkage (#{sc})"
        :skip

      in {tag: "function" => tag, name:, inline: true}
        warn "skipping #{tag}: #{name} - inline function"
        :skip

      in {tag: "function" => tag, name:, parameters: [*, {type: {tag: /va_list\z/}}, *]}
        warn "skipping #{tag}: #{name} - va_list parameter"
        :skip

      in {tag: "function" => tag, name:, "return-type": {tag: tytag}} if struct_type?(tytag)
        warn "skipping #{tag}: #{name} - by-value return (#{tytag})"
        :skip

      in {tag: "function" => tag, name:, parameters: ps} if !(m = ps.map{ _1[:type][:tag] }.select{struct_type?(_1) }).empty?
        warn "skipping #{tag}: #{name} - by-value parameters (#{m.join(", ")})"
        :skip

      in {tag: "function"}
        :function

      # Struct / Union entry
      #
      in {tag: "struct" | "union" => tag, name:, fields: []}
        warn "skipping #{tag}: #{name} - opaque #{tag}"
        :skip

      in {tag: "struct" | "union"}
        :struct

      # Typedef entry
      #
      in {tag: "typedef" => tag, name:, type: {tag: ":struct" | ":union" => tytag, name: orig}} if name == orig
        @st_types << name
        warn "skipping #{tag}: #{name} - alias to #{tytag[1..]} #{orig} not emitted"
        :skip

      in {tag: "typedef" => tag, name:, type: {tag: ":struct" | ":union" => tytag, name: orig}}
        @st_types << name
        :typedef

      in {tag: "typedef" => tag, name:, type: {tag: "struct" | "union" => tytag, fields: []}}
        @st_types << name
        warn "skipping #{tag}: #{name} - opaque #{tytag}"
        :skip

      in {tag: "typedef", name:, type: {tag: "struct" | "union"}}
        @st_types << name
        :typedef

      in {tag: "typedef"}
        :typedef

      else
        raise "unsupported c2ffi entry: #{node}"
      end
    end
  end

  class EntryEmitter
    INDENT_SIZE = 2

    attr_reader :q
    private :q

    def initialize(out_pp, classifier = EntryClassifier.new)
      @q = out_pp
      @classifier = classifier
    end

    def emit_entry(node)
      case (kind = @classifier.classify(node))
      when :skip
        # skip
      when :enum
        emit_enum(node)
      when :function
        emit_function(node)
      when :struct
        emit_struct(node)
      when :typedef
        emit_typedef(node)
      else
        raise
      end
    end

    private

    def emit_enum(node)
      case node
      in {tag: "enum", fields:}

        fields.each do |n|
          emit_enum_field(n)
        end

      end
    end

    def emit_enum_field(node)
      case node
      in {tag: "field", name:, value:}

        q.breakable
        q.text "const_set :#{name}, #{value}"

      end
    end

    def emit_function(node)
      case node
      in {tag: "function", name:, variadic:, parameters:, "return-type": _}
        rtype_repr, _ = field_signature(node)

        q.breakable
        q.text "extern \"#{rtype_repr} #{name}("

        e = parameters.to_enum
        loop do
          param = e.next
          emit_function_paramater(param)
          e.peek
          q.text ", "
        rescue StopIteration
          q.text ", ..." if variadic
          break
        end

        q.text ")\""

      end
    end

    def emit_function_paramater(node)
      case node
      in {tag: "parameter", name: _, type: _}
        type_repr, _ = field_signature(node)

        q.text type_repr

      end
    end

    def emit_struct(node)
      case node
      in {tag: "struct" | "union", name: ""}

        emit_struct_layout(node)

      in {tag: "struct" | "union", name:}

        q.breakable
        q.text "const_set :#{name}, " 
        emit_struct_layout(node)

      end
    end

    def emit_struct_layout(node)
      case node
      in {tag: "struct" | "union" => tag, fields:}

        q.text "#{tag}("
        q.nest INDENT_SIZE do
          q.breakable
          q.text "["
          q.nest INDENT_SIZE do
            e = fields.to_enum
            loop do
              field = e.next
              q.breakable
              emit_struct_field(field)
              q.text ","
              e.peek
            end
          end
          q.breakable
          q.text "]"
        end
        q.breakable
        q.text ")"

      end
    end

    def emit_struct_field(node)
      case node
      in {tag: "field", name: _, type: {tag: "struct" | "union"} => t_node}
        _, field_decl = field_signature(node)

        q.text "{"
        q.nest INDENT_SIZE do
          q.breakable
          q.text "#{field_decl}: "
          emit_struct(t_node)
        end
        q.breakable
        q.text "}"

      in {tag: "field", name:, type: {tag: ":function-pointer"}}

        q.text "\"function (*#{name})()\""

      in {tag: "field", name: _, type: _}
        type_repr, field_decl = field_signature(node)

        if @classifier.struct_type?(type_repr)
          q.text "{ \"#{field_decl}\": #{type_repr} }"
        else
          q.text "\"#{type_repr} #{field_decl}\""
        end

      end
    end

    def emit_typedef(node)
      case node
      in {tag: "typedef", name:, type: {tag: "struct" | "union"} => t_node}

        q.breakable
        emit_struct(t_node)
        q.text " => #{name}"

      in {tag: "typedef", name:, type: {tag: "enum"} => t_node}

        emit_enum(t_node)
        q.breakable
        q.text "typealias \"#{name}\", \"enum\""

      in {tag: "typedef", name:, type: {tag: ":enum"}}

        q.breakable
        q.text "typealias \"#{name}\", \"enum\""

      in {tag: "typedef", name:, type: {tag: ":function-pointer"}}

        q.breakable
        q.text "typealias \"#{name}\", \"function (*pointer)()\""

      in {tag: "typedef", name: _, type: _}
        type_repr, field_decl = field_signature(node)

        q.breakable
        q.text "typealias \"#{field_decl}\", \"#{type_repr}\""

      end
    end

    def t(node, ptr=[], ary=[])
      case node
      in {tag: /\A<unknown-/ => tag}
        raise "c2ffi unknown type: #{tag} - node=#{node}"

      in {tag: ":array", type: t_node, size:}
        ary << "[#{size}]"
        return t(t_node, ptr, ary)

      in {tag: ":pointer", type: t_node}
        ptr << "*"
        return t(t_node, ptr, ary)

      in {tag: ":_Bool"}
        "bool"
      in {tag: ":function-pointer"}
        "function (*pointer)()"
      in {tag: ":enum" | ":struct" | ":union", name:}
        name
      in {tag: /\A:(.*)/}
        $1.gsub("-", " ")

      in {tag: "enum" | "struct" | "union", name:}
        name
      in {tag:, **nil}
        tag
      else
        raise "unsupported c2ffi node: #{node}"
      end => base

      [ptr.empty? ? base : "#{base} #{ptr.join}", ary.join]
    end

    def field_signature(node)
      case node
      in {name:, type: t_node}
      in {name:, "return-type": t_node}
      end

      type_repr, ary_suffix = t(t_node)
      [type_repr, "#{name}#{ary_suffix}"]
    end
  end
end


