# frozen_string_literal: true

require "fiddle/import"
require_relative "sdl3/bindings"

module RbSDL3
  module SDL3
    extend Fiddle::Importer
    dlload
    include Bindings

    def self.dlload(*libs)
      super
      Bindings.included(self)
    end
  end
end
