# frozen_string_literal: true
require "fiddle"

module RbSDL3
  class UnloadedError < Fiddle::DLError; end

  module BindingsRefinement
    UNLOADED_STUB_PROC = proc { |*| Kernel.raise(UnloadedError, <<~MSG) }
      cannot call the function: #{__method__}()
    MSG

    refine Fiddle::Importer do
      def extern(signature, *opts)
        begin
          f = super
        rescue Fiddle::DLError
          name, * = parse_signature(signature, type_alias)
          define_method(name, &UNLOADED_STUB_PROC)
          module_function(name)
        else
          name = f.name
          this = self
          define_method(name) { |*a, &b| this.__send__(__method__, *a, &b) }
          private(name)
        end
        f
      end
    end

    refine Module do
      def const_set(name, value)
        const_defined?(name) ? value : super
      end
    end
  end
end
