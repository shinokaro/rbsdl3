# frozen_string_literal: true

require "fiddle/import"

module RbSDL3
  module SDL3
    extend Fiddle::Importer
    
    def dlload(*libs)
      super

      require_relative "sdl3/bindings"
      include Bindings
    end
  end
end
