# frozen_string_literal: true
require "fiddle/import"
require_relative "sdl3/version"

module SDL3
  extend Fiddle::Importer

  DLLOAD_TARGETS = %i[SDL Image TTF].freeze
  private_constant :DLLOAD_TARGETS

  def self.dlload(*libs)
    super

    # Map C 'enum' to an int-compatible type (mirrors common ABI layouts)
    typealias "enum", "int"

    DLLOAD_TARGETS.each do |m|
      const_get(m, false).included(self) if const_defined?(m, false)
    end
  end

  dlload
end
