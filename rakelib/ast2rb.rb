# frozen_string_literal: true
require "json"

class AST2Rb
  class << self
    def load_file(path)
      JSON.load_file(path, freeze: true, symbolize_names: true)
    end
  end

  class EntryClassifier
    def initialize(source = "")
      @st_types = []
      @source = source
    end

    def struct_type?(name) = @st_types.include?(name)

    def classify(node)
      msg = nil

      case node

      # Enum entry
      #
      in {tag: "enum"}
        :enum

      # Function entry
      #
      in {tag: "function" => tag, name: /\A[^A-Z].+/ => name}
        msg = "skipping #{tag}: #{name} - not an SDL API"
        :skip

      in {tag: "function" => tag, name:, "storage-class": "static", inline: true}
        msg = "skipping #{tag}: #{name} - no external linkage (static; inline)"
        :skip

      in {tag: "function" => tag, name:, "storage-class": "static"}
        msg = "skipping #{tag}: #{name} - no external linkage (static)"
        :skip

      in {tag: "function" => tag, name:, parameters: [*, {type: {tag: /va_list\z/}}, *]}
        msg = "skipping #{tag}: #{name} - va_list parameter"
        :skip

      in {tag: "function" => tag, name:, "return-type": {tag: tytag}} if struct_type?(tytag)
        msg = "skipping #{tag}: #{name} - by-value return (#{tytag})"
        :skip

      in {tag: "function" => tag, name:, parameters: ps} if !(m = ps.map{ _1[:type][:tag] }.select{struct_type?(_1) }).empty?
        msg = "skipping #{tag}: #{name} - by-value parameters (#{m.join(", ")})"
        :skip

      in {tag: "function"}
        :function

      # Struct / Union entry
      #
      in {tag: "struct" | "union" => tag, name:, fields: []}
        msg = "skipping #{tag}: #{name} - opaque #{tag}"
        :skip

      in {tag: "struct" | "union"}
        :struct

      # Typedef entry
      #
      in {tag: "typedef" => tag, name:, type: {tag: ":struct" | ":union" => tytag, name: orig}} if name == orig
        @st_types << name
        msg = "skipping #{tag}: #{name} - alias to #{tytag[1..]} #{orig} not emitted"
        :skip

      in {tag: "typedef" => tag, name:, type: {tag: ":struct" | ":union" => tytag, name: orig}}
        @st_types << name
        :typedef

      in {tag: "typedef" => tag, name:, type: {tag: "struct" | "union" => tytag, fields: []}}
        @st_types << name
        msg = "skipping #{tag}: #{name} - opaque #{tytag}"
        :skip

      in {tag: "typedef", name:, type: {tag: "struct" | "union"}}
        @st_types << name
        :typedef

      in {tag: "typedef"}
        :typedef

      else
        raise "unsupported c2ffi entry: #{node}"

      end => kind

      if node in {location: /<Spelling=(.+?):\d+:\d+>\z/ | /\A(.+):\d+:\d+\z/}
        if $1.start_with?(@source)
          return kind, msg
        end
      end
      return :skip, nil
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
      kind, msg = @classifier.classify(node)
      puts msg if msg
      case kind
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
      in {tag: "function", name:, variadic:, parameters: [], "return-type": _}
        rtype_repr, _ = field_signature(node)

        q.breakable
        q.text "extern \"#{rtype_repr} #{name}("
        q.text "void"
        q.text ")\""

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

      in {tag: "typedef", name:, type: {tag: ":function-pointer"}, location:}

        q.breakable
        q.text "typealias \"#{name}\", \"function (*pointer)()\""
        value = canonical_function_signature(location)
        q.breakable
        q.text "const_set :#{name}, \"#{value}\""

      in {tag: "typedef", name: _, type: _}
        type_repr, field_decl = field_signature(node)

        q.breakable
        q.text "typealias \"#{field_decl}\", \"#{type_repr}\""

      end
    end

    def parse_source_location(location)
      location in /<Spelling=(.+?):(\d+):(\d+)>\z/ | /\A(.+?):(\d+):(\d+)\z/
      [$1, $2.to_i - 1, $3.to_i - 1]
    end

    def canonical_decl_type(type_decl)
      type_decl in
        /(\.\.\.)/ |
        /\A\s*(.+[\*\s])(\w+)(\s*(?:\[[^\]]*\])*)?\s*\z/ |
        # fallback for identifier-less type, mainly function return types
        /(.+)/
      raw_type, _ident, array_suffix = $1, $2, $3
      raw_type.split(/(\s+|\b)/).inject("".dup) { |norm, token|
        case token
        when "const", /\s+/, ""
          norm << ""
        when "..."
          return token
        when /\*+/
          norm << (norm =~ /\w\z/ ? " #{token}" : token)
        when /\w+/
          norm << (norm =~ /[\*\w]\z/ ? " #{token}" : token)
        else
          raise ArgumentError, "unexpected token '#{token}' in #{type_decl.inspect}"
        end
      } << (array_suffix.to_s.empty? ? '' : '*')
    end

    def canonical_function_signature(location)
      path, lineno, * = parse_source_location(location)
      lines = File.open(path, "rb") { |f| f.readlines(chomp: true) }
      decl_src = "".dup
      lineno += 1 while (decl_src << lines[lineno]) !~ /\)\s*;/
      if decl_src in /\A\s*(?:typedef\s+)?([^\(\)]+?)\s*\(\s*(?:\w*)\s*\*\s*(\w+)\s*\)\s*\((.*?)\)\s*;/
        return_type = canonical_decl_type($1)
        func_name = $2
        param_types = $3.split(",").map { |s| canonical_decl_type(s) }.join(", ")
        "#{return_type} #{func_name}(#{param_types})"
      else
        raise "invalid function pointer declaration: #{decl_src.inspect}"
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


