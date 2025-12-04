# frozen_string_literal: true
require_relative "extern_delegator"

module RbSDL3
  module BindingsRefinement
    include ExternDelegator

    refine Module do
      def const_set(name, value)
        const_defined?(name) ? value : super
      end
    end
  end
end
