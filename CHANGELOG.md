# Changelog

## [Unreleased]

### Added
- Added SDL_main support to the default bindings load path.

### Updated
- Refactored macro handling and binding generation internals with no intentional API changes.

## [0.4.0] - 2026-03-13

### Added
- Added optional extension entry point: `require "rbsdl3/mixer"` for SDL_mixer APIs.
- Target SDL_mixer version to 3.2.0. Generated `rbsdl3/mixer.rb`; SDL_mixer 3.2.0 APIs are now available via the bindings.

### Updated
- Target SDL version to 3.4.2 (from 3.4.0). Regenerated `rbsdl3/sdl.rb`; newly added constants in SDL 3.4.2 are now available via the bindings (see SDL 3.4.2 release notes for the full upstream change list).
- Extended macro extraction to include `SDLK_`, `IMG_`, `MIX_`, and `TTF_` prefixes, so the generated bindings now include previously omitted constants.
- Added SDL_mixer to the default dynamic library load targets.

## [0.3.0] - 2026-01-24

### Updated
- Target SDL_image version to 3.4.0 (from 3.2.6). Regenerated `rbsdl3/image.rb`; newly added APIs in SDL_image 3.4 are now available via the bindings (see the SDL_image 3.4.0 release notes for the full upstream change list).

## [0.2.0] - 2026-01-02

### Updated
- Target SDL version to 3.4.0 (from 3.2.28). Regenerated `rbsdl3/sdl.rb`; newly added APIs in SDL 3.4 are now available via the bindings (see SDL 3.4.0 release notes for the full upstream change list).
- Target SDL_image version to 3.2.6 (from 3.2.4). Regenerated `rbsdl3/image.rb` (micro update; no intentional functional change in rbsdl3 beyond upstream bugfixes).

### Notes
- Upstream renamed `SDL_PROP_WINDOW_OPENVR_OVERLAY_ID` to `SDL_PROP_WINDOW_OPENVR_OVERLAY_ID_NUMBER` (same value).

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
