# frozen_string_literal: true

require "fiddle/import"
require_relative "weak_extern"

module RbSDL3
  module SDL3
    extend Fiddle::Importer
    extend WeakExtern

    def self.dlload(*libs)
      super

      require_relative "sdl3/bindings"
      include Bindings
    end
  end
end
