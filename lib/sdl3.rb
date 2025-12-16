# frozen_string_literal: true
require "fiddle/import"
require_relative "sdl3/version"

module SDL3
  extend Fiddle::Importer

  def self.dlload(*libs)
    super
    const_get(:SDL, false).included(self) if const_defined?(:SDL, false)
  end

  dlload
end
