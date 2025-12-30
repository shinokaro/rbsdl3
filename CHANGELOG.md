# Changelog

## [Unreleased]

## [0.1.0] - 2025-12-31

### Added
- Added SDL3 bindings built on `Fiddle::Importer`. Supports runtime linking via `dlload`, allowing the user to choose the target dynamic library at runtime.
- `require "rbsdl3"` makes the SDL3 core API available (functions, constants, structs, enums, etc.) by loading `rbsdl3/sdl` internally.
- Added optional extension entry points: `require "rbsdl3/image"` for SDL_image APIs and `require "rbsdl3/ttf"` for SDL_ttf APIs (both assume the SDL3 core is loaded).
- Added Ruby-side helpers that mirror a subset of SDL macros (C-style integer casts, FOURCC, version helpers, etc.).
- Added a stub/annotation mechanism for missing symbols and unsupported APIs: unresolved symbols raise `NotImplementedError`, and selected APIs can be explicitly marked as `unsupported:`.

### Notes
- Dependencies: Ruby >= 3.1, fiddle ~> 1.1.7.
- Due to Fiddle limitations, some APIs raise `NotImplementedError`.
  - SDL examples: `SDL_vsnprintf()` / `SDL_vasprintf()` / `SDL_SetErrorV()` / `SDL_LogMessageV()` / `SDL_IOvprintf()` / `SDL_GUIDToString()` / `SDL_StringToGUID()` / `SDL_SetGPUBlendConstants()`
  - SDL_ttf examples: `TTF_RenderText_*` / `TTF_RenderGlyph_*`
