# frozen_string_literal: true
require "fiddle"

module SDL3
  class UnloadedError < Fiddle::DLError; end

  module BindingsRefinement
    UNRESOLVED_STUB_PROC = proc do |*|
      dlloaded = (h = handler rescue nil) && !h.handlers.empty?
      if dlloaded
        ::SDL3::UnloadedError.new("SDL symbol not found: #{__method__}()")
      else
        ::SDL3::UnloadedError.new("SDL library not loaded: #{__method__}()")
      end => e
      l = caller_locations(1, 1)&.first
      s = l && l.path == "(eval)" && l.label == __method__.to_s ? 2 : 1
      e.set_backtrace(caller(s))
      ::Kernel.raise(e)
    end

    refine Fiddle::Importer do
      def extern(signature, *opts)
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
          define_singleton_method(name, &UNRESOLVED_STUB_PROC)
        else
          name = f.name
        end
        module_eval("private def #{name}(...) = ::SDL3.#{name}(...)")
        f
      end
    end

    refine Module do
      def const_set(name, value)
        const_defined?(name, false) ? value : super
      end
    end
  end
end
