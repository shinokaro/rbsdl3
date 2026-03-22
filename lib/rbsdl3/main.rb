# frozen_string_literal: true
require_relative "../rbsdl3"
require_relative "sdl"

module SDL3
  using BindingsRefinement
  SDL_main = proc {
    # Fiddle declarations for SDL_main functions, structs, and enums
    #
    extern "void SDL_SetMainReady(void)"
  }
  private_constant :SDL_main

  SDL_main.call
end
