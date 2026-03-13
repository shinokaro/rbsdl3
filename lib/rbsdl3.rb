# frozen_string_literal: true
require "fiddle/import"
require_relative "rbsdl3/version"

module SDL3
  module BindingsRefinement
    refine Fiddle::Importer do
      def extern(signature, *opts, unsupported: nil)
        return unless (h = handler rescue nil) && !h.handlers.empty?
        return if unsupported&.tap { |msg|
          name = signature[/(\w+)\(/, 1]
          define_method(name) { raise NotImplementedError, msg, caller(1) }
          module_function(name)
        }
        begin
          f = super
        rescue Fiddle::DLError => e
          # Re-trigger type-resolution DLErrors here, limiting the stubbing path
          # to symbol-resolution failures.
          name, = begin
                    parse_signature(signature, type_alias)
                  rescue Fiddle::DLError
                    raise e
                  end
          module_eval(<<-EOS, __FILE__, __LINE__+1)
            def #{name}(...)
              e = ::NotImplementedError.new("SDL symbol not found: #{name}()")
              e.set_backtrace(caller(1))
              ::Kernel.raise(e)
            end
          EOS
          module_function(name)
        else
          name = f.name
          module_eval("private def #{name}(...) = ::SDL3.#{name}(...)")
        end
        f
      end
    end

    refine Module do
      def const_set(name, value)
        const_defined?(name, false) ? value : super
      end
    end
  end

  extend Fiddle::Importer

  DLLOAD_TARGETS = %i[SDL SDL_image SDL_mixer SDL_ttf].freeze
  private_constant :DLLOAD_TARGETS

  def self.dlload(*libs)
    super

    # Map C 'enum' to an int-compatible type (mirrors common ABI layouts)
    typealias "enum", "int"

    DLLOAD_TARGETS.each do |m|
      const_get(m, false).call if const_defined?(m, false)
    end
  end

  dlload
end
require_relative "rbsdl3/sdl"
