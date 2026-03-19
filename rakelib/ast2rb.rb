# frozen_string_literal: true
require "json"

class AST2Rb
  class << self
    def load_file(path)
      JSON.load_file(path, freeze: true, symbolize_names: true)
    end
  end

  class StructTypeCollector
    def initialize(registry)
      @registry = registry
    end

    def collect(node)
      case node

      in { tag: "typedef", name:, type: {tag: ":struct" | ":union" | "struct" | "union" } }
        @registry << name

      else
        nil

      end
    end
  end

  class EntrySourcePolicy
    def initialize(source)
      @source = source
    end

    def match?(node)
      (node in { location: /<Spelling=(.+?):\d+:\d+>\z/ | /\A(.+):\d+:\d+\z/ })
      && $1.start_with?(@source)
    end
  end

  class EntryClassifier
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
        msg = "skipping #{tag}: #{name} - alias to #{tytag[1..]} #{orig} not emitted"
        :skip

      in {tag: "typedef" => tag, name:, type: {tag: ":struct" | ":union" => tytag, name: orig}}
        :typedef

      in {tag: "typedef" => tag, name:, type: {tag: "struct" | "union" => tytag, fields: []}}
        msg = "skipping #{tag}: #{name} - opaque #{tytag}"
        :skip

      in {tag: "typedef", name:, type: {tag: "struct" | "union"}}
        :typedef

      in {tag: "typedef"}
        :typedef

      else
        raise "unsupported c2ffi entry: #{node}"

      end => kind

      return kind, msg
    end
  end

  class EntryEmitter
    INDENT_SIZE = 2

    attr_reader :q
    private :q

    def initialize(out_pp, classifier, struct_types)
      @q = out_pp
      @classifier = classifier
      @struct_types = struct_types
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
      node => {tag: "enum", fields:}

      fields.each do |field|
        field => {tag: "field", name:, value:}

        q.breakable
        emit_const(name) { q.text "#{value}" }
      end
    end

    def emit_const(name)
      q.text "const_set :#{name}, "
      yield
    end

    def emit_function(node)
      node => {tag: "function", name:, variadic:, parameters:, "return-type": rty}
      rtype_repr, _ = type_parts(rty)

      q.breakable
      q.text "extern \"#{rtype_repr} #{name}("
      if parameters.empty?
        q.text "void"
      else
        e = parameters.to_enum
        loop do
          e.next => {tag: "parameter", name: _, type: pty}
          q.text type_parts(pty)[0]
          e.peek
          q.text ", "
        rescue StopIteration
          q.text ", ..." if variadic
          break
        end
      end
      q.text ")\""

      if @struct_types.include?(rtype_repr)
        || parameters.any? { @struct_types.include?(it[:type][:tag]) }
        || parameters.any? { it[:type][:tag] =~ /va_list\z/ }

        err_msg = "SDL function unsupported by Fiddle: #{name}()"
        q.text ", unsupported: \"#{err_msg}\""
      end
    end

    def emit_struct(node)
      case node
      in {tag: "struct" | "union", name: ""}

        emit_struct_layout(node)

      in {tag: "struct" | "union", name:}

        q.breakable
        emit_const(name) { emit_struct_layout(node) }
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
      in {tag: "field", name:, type: {tag: "struct" | "union"} => type}
        _, ary_suffix = type_parts(type)

        q.text "{"
        q.nest INDENT_SIZE do
          q.breakable
          q.text "#{name}#{ary_suffix}: "
          emit_struct(type)
        end
        q.breakable
        q.text "}"

      in {tag: "field", name:, type: {tag: ":function-pointer"}}

        q.text "\"function (*#{name})()\""

      in {tag: "field", name:, type:}
        type_repr, ary_suffix = type_parts(type)

        if @struct_types.include?(type_repr)
          q.text "{ \"#{name}#{ary_suffix}\": #{type_repr} }"
        elsif type_repr.end_with?("*")
          q.text "\"#{type_repr}#{name}#{ary_suffix}\""
        else
          q.text "\"#{type_repr} #{name}#{ary_suffix}\""
        end

      end
    end

    def emit_typedef(node)
      node => {tag: "typedef", name:, type: {tag: tytag} => t_node, location:}

      case tytag
      when "struct", "union"
        q.breakable
        emit_struct(t_node)
        q.text " => #{name}"
      when "enum"
        emit_enum(t_node)
        q.breakable
        emit_typealias(name, "enum")
      when ":enum"
        q.breakable
        emit_typealias(name, "enum")
      when ":function-pointer"
        q.breakable
        emit_typealias(name, "function (*pointer)()")
        q.breakable
        emit_const(name) { q.text canonical_function_signature(location).dump }
      else
        type_repr, ary_suffix = type_parts(t_node)
        q.breakable
        emit_typealias(name + ary_suffix, type_repr)
      end
    end

    def emit_typealias(new, orig)
      q.text "typealias #{new.dump}, #{orig.dump}"
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

    def type_parts(node, ptr=[], ary=[])
      case node
      in {tag: /\A<unknown-/ => tag}
        raise "c2ffi unknown type: #{tag} - node=#{node}"

      in {tag: ":array", type: t_node, size:}
        ary << "[#{size}]"
        return type_parts(t_node, ptr, ary)

      in {tag: ":pointer", type: t_node}
        ptr << "*"
        return type_parts(t_node, ptr, ary)

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
  end
end
