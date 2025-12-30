# rbsdl3

rbsdl3 is a binding library for using SDL3 from Ruby. In addition to SDL3 itself, it also covers APIs from related libraries such as SDL_image and SDL_ttf. SDL dynamic libraries (DLL/so/dylib) are loaded explicitly by the user at runtime.

## Features

- Built on Ruby’s standard library, Fiddle.
- Provides Ruby-side constants and struct definitions before any dynamic libraries are loaded.
- Once the dynamic libraries are loaded, SDL APIs are bound and can be called as methods.
- If an API symbol is not available at bind time, execution still continues; the corresponding method is defined as a stub that raises `NotImplementedError` when called.
- Bindings for related libraries can be added as needed, for example with `require "sdl3/image"`.

## Scope

- Target: SDL3
- Related libraries: SDL_image / SDL_ttf (SDL_mixer will be supported after an official SDL_mixer release)

API coverage is not complete; some APIs may be unavailable.

Some SDL constants currently assume little-endian values. Inline functions are not included.

## Requirements

rbsdl3 does not bundle SDL libraries. You must provide the SDL3 dynamic library (and, if you use them, the SDL_image / SDL_ttf dynamic libraries) separately.

SDL dynamic libraries are loaded explicitly at runtime via `SDL3.dlload` (for each library you intend to use). The library names passed to `dlload` are examples and may differ by platform.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add rbsdl3
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install rbsdl3
```

## Usage

### SDL3 (core)

With `require "sdl3"`, Ruby-side definitions such as constants and structs are available. Calling functions requires `SDL3.dlload`.

```ruby
require "sdl3"
SDL3::SDL_MAJOR_VERSION

SDL3.SDL_GetVersion  #=> raises NoMethodError (not bound yet)

SDL3.dlload("libSDL3")  # e.g.
SDL3.SDL_GetVersion

include SDL3
SDL_GetVersion()
```

### Related libraries

Related library bindings are added by requiring them individually.

```ruby
require "sdl3/image"
SDL3::SDL_IMAGE_MAJOR_VERSION
SDL3::SDL_MAJOR_VERSION

SDL3.dlload("libSDL3_image")  # e.g.
SDL3.IMG_Version
SDL3.SDL_GetVersion

include SDL3
IMG_Version()
SDL_GetVersion()
```

### Callbacks / function pointers

```ruby
require "sdl3"
SDL3.bind(SDL3::SDL_HitTest) { |win, area, data| 0 }
SDL3["SDL_HitTest"]
```

## Development

c2ffi (https://github.com/rpav/c2ffi) is used as the source of the AST output from which most bindings are mechanically generated. Macros are extracted from header files using a custom extraction tool, and macro functions are also automatically converted. Anything that cannot be handled by these methods is bound manually.

## Contributing

Bug reports are welcome on GitHub at https://github.com/shinokaro/rbsdl3.

If you find missing functions or macros, please open an issue with the corresponding SDL header/API details so they can be added.

## License

rbsdl3 is licensed under the MIT License.

This project does not bundle SDL libraries. SDL3 and any related SDL_* libraries are separate projects and are distributed under their own licenses (zlib license).
