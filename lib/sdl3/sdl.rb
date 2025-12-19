# frozen_string_literal: true
require_relative "../sdl3"
require_relative "bindings_refinement"

module SDL3
  module SDL
    using BindingsRefinement

    def self.included(m)
      m.module_eval {
        # Library-specific bindings and helpers
        #
        # Cast helpers to emulate C-style integer casts used in SDL macros
        #
        private_class_method module_function def cast(x, t) = [::String === x ? x.ord : ::Kernel.Integer(x)].pack(t).unpack1(t)

        private_class_method module_function def Sint8(x)  = cast(x, "c")
        private_class_method module_function def Sint16(x) = cast(x, "s")
        private_class_method module_function def Sint32(x) = cast(x, "l")
        private_class_method module_function def Sint64(x) = cast(x, "q")
        private_class_method module_function def Uint8(x)  = cast(x, "C")
        private_class_method module_function def Uint16(x) = cast(x, "S")
        private_class_method module_function def Uint32(x) = cast(x, "L")
        private_class_method module_function def Uint64(x) = cast(x, "Q")
        private_class_method module_function def int(x)    = cast(x, "i")
        private_class_method module_function def size_t(x) = cast(x, "J")

        # Treat enum values as int for macro-cast emulation (common ABI)
        #
        alias enum int
        private_class_method module_function :enum

        # Aliases for macro-cast emulation (typedefs and enum carriers)
        #
        # enum carriers
        alias SDL_ChromaLocation enum
        private_class_method module_function :SDL_ChromaLocation

        alias SDL_ColorPrimaries enum
        private_class_method module_function :SDL_ColorPrimaries

        alias SDL_ColorRange enum
        private_class_method module_function :SDL_ColorRange

        alias SDL_ColorType enum
        private_class_method module_function :SDL_ColorType

        alias SDL_MatrixCoefficients enum
        private_class_method module_function :SDL_MatrixCoefficients

        alias SDL_TransferCharacteristics enum
        private_class_method module_function :SDL_TransferCharacteristics

        # Uint32 typedeffs
        alias SDL_AudioDeviceID Uint32
        private_class_method module_function :SDL_AudioDeviceID

        alias SDL_MouseID Uint32
        private_class_method module_function :SDL_MouseID

        # Uint64 typedefs
        alias SDL_TouchID Uint64
        private_class_method module_function :SDL_TouchID

        # SDL_atomic.h
        #
        module_function def SDL_MemoryBarrierRelease() = SDL_MemoryBarrierReleaseFunction()
        module_function def SDL_MemoryBarrierAcquire() = SDL_MemoryBarrierAcquireFunction()
        module_function def SDL_AtomicIncRef(a) = SDL_AddAtomicInt(a, 1)
        module_function def SDL_AtomicDecRef(a) = (SDL_AddAtomicInt(a, -1) == 1)

        # SDL_endian.h
        #
        const_set :SDL_LIL_ENDIAN, 1234
        const_set :SDL_BIG_ENDIAN, 4321

        # Endianness is determined at runtime to reflect the host ABI
        const_set :SDL_BYTEORDER, ([1].pack("L") == [1].pack("V")) ? SDL_LIL_ENDIAN : SDL_BIG_ENDIAN
        const_set :SDL_FLOATWORDORDER, SDL_BYTEORDER

        # SDL_main.h
        #
        extern "void SDL_SetMainReady()"

        # SDL_revision.h
        #
        const_set :SDL_REVISION, "Some arbitrary string decided at SDL build time"

        # SDL_stdinc.h
        #
        const_set :SDL_SIZE_MAX, (size_t(-1))
        module_function def SDL_FOURCC(a, b, c, d) = (((Uint32(Uint8(a))) << 0) | ((Uint32(Uint8(b))) << 8) | ((Uint32(Uint8(c))) << 16) | ((Uint32(Uint8(d))) << 24))
        module_function def SDL_SINT64_C(c) = c
        module_function def SDL_UINT64_C(c) = c
        const_set :SDL_MAX_SINT8, (Sint8(0x7F))
        const_set :SDL_MIN_SINT8, (Sint8(~0x7F))
        const_set :SDL_MAX_UINT8, (Uint8(0xFF))
        const_set :SDL_MIN_UINT8, (Uint8(0x00))
        const_set :SDL_MAX_SINT16, (Sint16(0x7FFF))
        const_set :SDL_MIN_SINT16, (Sint16(~0x7FFF))
        const_set :SDL_MAX_UINT16, (Uint16(0xFFFF))
        const_set :SDL_MIN_UINT16, (Uint16(0x0000))
        const_set :SDL_MAX_SINT32, (Sint32(0x7FFFFFFF))
        const_set :SDL_MIN_SINT32, (Sint32(~0x7FFFFFFF))
        const_set :SDL_MAX_UINT32, (Uint32(0xFFFFFFFF))
        const_set :SDL_MIN_UINT32, (Uint32(0x00000000))
        const_set :SDL_MAX_SINT64, SDL_SINT64_C(0x7FFFFFFFFFFFFFFF)
        const_set :SDL_MIN_SINT64, ~SDL_SINT64_C(0x7FFFFFFFFFFFFFFF)
        const_set :SDL_MAX_UINT64, SDL_UINT64_C(0xFFFFFFFFFFFFFFFF)
        const_set :SDL_MIN_UINT64, SDL_UINT64_C(0x0000000000000000)
        const_set :SDL_MAX_TIME, SDL_MAX_SINT64
        const_set :SDL_MIN_TIME, SDL_MIN_SINT64
        const_set :SDL_FLT_EPSILON, 1.1920928955078125e-07
        const_set :SDL_INVALID_UNICODE_CODEPOINT, 0xFFFD
        const_set :SDL_PI_D, 3.141592653589793238462643383279502884
        const_set :SDL_PI_F, 3.141592653589793238462643383279502884
        const_set :SDL_ICONV_ERROR, size_t(-1)
        const_set :SDL_ICONV_E2BIG, size_t(-2)
        const_set :SDL_ICONV_EILSEQ, size_t(-3)
        const_set :SDL_ICONV_EINVAL, size_t(-4)
        module_function def SDL_FunctionPointer(x) = x

        # SDL_thread.h
        #
        const_set :SDL_BeginThreadFunction, Fiddle::NULL
        const_set :SDL_EndThreadFunction, Fiddle::NULL
        module_function def SDL_CreateThread(fn, name, data) = SDL_CreateThreadRuntime((fn), (name), (data), SDL_FunctionPointer(SDL_BeginThreadFunction), SDL_FunctionPointer(SDL_EndThreadFunction))
        module_function def SDL_CreateThreadWithProperties(props) = SDL_CreateThreadWithPropertiesRuntime((props), SDL_FunctionPointer(SDL_BeginThreadFunction), SDL_FunctionPointer(SDL_EndThreadFunction))
        const_set :SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER, "SDL.thread.create.entry_function"
        const_set :SDL_PROP_THREAD_CREATE_NAME_STRING, "SDL.thread.create.name"
        const_set :SDL_PROP_THREAD_CREATE_USERDATA_POINTER, "SDL.thread.create.userdata"
        const_set :SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER, "SDL.thread.create.stacksize"

        # Ruby wrappers for SDL macros
        #
        const_set :SDL_AUDIO_MASK_BITSIZE, (0xFF)
        const_set :SDL_AUDIO_MASK_FLOAT, (1<<8)
        const_set :SDL_AUDIO_MASK_BIG_ENDIAN, (1<<12)
        const_set :SDL_AUDIO_MASK_SIGNED, (1<<15)
        module_function def SDL_DEFINE_AUDIO_FORMAT(signed, bigendian, flt, size) = ((Uint16(signed) << 15) | (Uint16(bigendian) << 12) | (Uint16(flt) << 8) | ((size) & SDL_AUDIO_MASK_BITSIZE))
        module_function def SDL_AUDIO_BITSIZE(x) = ((x) & SDL_AUDIO_MASK_BITSIZE)
        module_function def SDL_AUDIO_BYTESIZE(x) = (SDL_AUDIO_BITSIZE(x) / 8)
        module_function def SDL_AUDIO_ISFLOAT(x) = ((x) & SDL_AUDIO_MASK_FLOAT)
        module_function def SDL_AUDIO_ISBIGENDIAN(x) = ((x) & SDL_AUDIO_MASK_BIG_ENDIAN)
        module_function def SDL_AUDIO_ISLITTLEENDIAN(x) = (!SDL_AUDIO_ISBIGENDIAN(x))
        module_function def SDL_AUDIO_ISSIGNED(x) = ((x) & SDL_AUDIO_MASK_SIGNED)
        module_function def SDL_AUDIO_ISINT(x) = (!SDL_AUDIO_ISFLOAT(x))
        module_function def SDL_AUDIO_ISUNSIGNED(x) = (!SDL_AUDIO_ISSIGNED(x))
        const_set :SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, (SDL_AudioDeviceID(0xFFFFFFFF))
        const_set :SDL_AUDIO_DEVICE_DEFAULT_RECORDING, (SDL_AudioDeviceID(0xFFFFFFFE))
        module_function def SDL_AUDIO_FRAMESIZE(x) = (SDL_AUDIO_BYTESIZE((x).format) * (x).channels)
        const_set :SDL_BLENDMODE_NONE, 0x00000000
        const_set :SDL_BLENDMODE_BLEND, 0x00000001
        const_set :SDL_BLENDMODE_BLEND_PREMULTIPLIED, 0x00000010
        const_set :SDL_BLENDMODE_ADD, 0x00000002
        const_set :SDL_BLENDMODE_ADD_PREMULTIPLIED, 0x00000020
        const_set :SDL_BLENDMODE_MOD, 0x00000004
        const_set :SDL_BLENDMODE_MUL, 0x00000008
        const_set :SDL_BLENDMODE_INVALID, 0x7FFFFFFF
        const_set :SDL_CACHELINE_SIZE, 128
        const_set :SDL_PROP_FILE_DIALOG_FILTERS_POINTER, "SDL.filedialog.filters"
        const_set :SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER, "SDL.filedialog.nfilters"
        const_set :SDL_PROP_FILE_DIALOG_WINDOW_POINTER, "SDL.filedialog.window"
        const_set :SDL_PROP_FILE_DIALOG_LOCATION_STRING, "SDL.filedialog.location"
        const_set :SDL_PROP_FILE_DIALOG_MANY_BOOLEAN, "SDL.filedialog.many"
        const_set :SDL_PROP_FILE_DIALOG_TITLE_STRING, "SDL.filedialog.title"
        const_set :SDL_PROP_FILE_DIALOG_ACCEPT_STRING, "SDL.filedialog.accept"
        const_set :SDL_PROP_FILE_DIALOG_CANCEL_STRING, "SDL.filedialog.cancel"
        module_function def SDL_Unsupported() = SDL_SetError("That operation is not supported")
        module_function def SDL_InvalidParamError(param) = SDL_SetError("Parameter '%s' is invalid", (param))
        const_set :SDL_GLOB_CASEINSENSITIVE, (1 << 0)
        const_set :SDL_GPU_TEXTUREUSAGE_SAMPLER, (1 << 0)
        const_set :SDL_GPU_TEXTUREUSAGE_COLOR_TARGET, (1 << 1)
        const_set :SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET, (1 << 2)
        const_set :SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ, (1 << 3)
        const_set :SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ, (1 << 4)
        const_set :SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE, (1 << 5)
        const_set :SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE, (1 << 6)
        const_set :SDL_GPU_BUFFERUSAGE_VERTEX, (1 << 0)
        const_set :SDL_GPU_BUFFERUSAGE_INDEX, (1 << 1)
        const_set :SDL_GPU_BUFFERUSAGE_INDIRECT, (1 << 2)
        const_set :SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ, (1 << 3)
        const_set :SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ, (1 << 4)
        const_set :SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE, (1 << 5)
        const_set :SDL_GPU_SHADERFORMAT_INVALID, 0
        const_set :SDL_GPU_SHADERFORMAT_PRIVATE, (1 << 0)
        const_set :SDL_GPU_SHADERFORMAT_SPIRV, (1 << 1)
        const_set :SDL_GPU_SHADERFORMAT_DXBC, (1 << 2)
        const_set :SDL_GPU_SHADERFORMAT_DXIL, (1 << 3)
        const_set :SDL_GPU_SHADERFORMAT_MSL, (1 << 4)
        const_set :SDL_GPU_SHADERFORMAT_METALLIB, (1 << 5)
        const_set :SDL_GPU_COLORCOMPONENT_R, (1 << 0)
        const_set :SDL_GPU_COLORCOMPONENT_G, (1 << 1)
        const_set :SDL_GPU_COLORCOMPONENT_B, (1 << 2)
        const_set :SDL_GPU_COLORCOMPONENT_A, (1 << 3)
        const_set :SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN, "SDL.gpu.device.create.debugmode"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN, "SDL.gpu.device.create.preferlowpower"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING, "SDL.gpu.device.create.name"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN, "SDL.gpu.device.create.shaders.private"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN, "SDL.gpu.device.create.shaders.spirv"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN, "SDL.gpu.device.create.shaders.dxbc"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN, "SDL.gpu.device.create.shaders.dxil"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN, "SDL.gpu.device.create.shaders.msl"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN, "SDL.gpu.device.create.shaders.metallib"
        const_set :SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING, "SDL.gpu.device.create.d3d12.semantic"
        const_set :SDL_PROP_GPU_COMPUTEPIPELINE_CREATE_NAME_STRING, "SDL.gpu.computepipeline.create.name"
        const_set :SDL_PROP_GPU_GRAPHICSPIPELINE_CREATE_NAME_STRING, "SDL.gpu.graphicspipeline.create.name"
        const_set :SDL_PROP_GPU_SAMPLER_CREATE_NAME_STRING, "SDL.gpu.sampler.create.name"
        const_set :SDL_PROP_GPU_SHADER_CREATE_NAME_STRING, "SDL.gpu.shader.create.name"
        const_set :SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_R_FLOAT, "SDL.gpu.texture.create.d3d12.clear.r"
        const_set :SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_G_FLOAT, "SDL.gpu.texture.create.d3d12.clear.g"
        const_set :SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_B_FLOAT, "SDL.gpu.texture.create.d3d12.clear.b"
        const_set :SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_A_FLOAT, "SDL.gpu.texture.create.d3d12.clear.a"
        const_set :SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_DEPTH_FLOAT, "SDL.gpu.texture.create.d3d12.clear.depth"
        const_set :SDL_PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_STENCIL_NUMBER, "SDL.gpu.texture.create.d3d12.clear.stencil"
        const_set :SDL_PROP_GPU_TEXTURE_CREATE_NAME_STRING, "SDL.gpu.texture.create.name"
        const_set :SDL_PROP_GPU_BUFFER_CREATE_NAME_STRING, "SDL.gpu.buffer.create.name"
        const_set :SDL_PROP_GPU_TRANSFERBUFFER_CREATE_NAME_STRING, "SDL.gpu.transferbuffer.create.name"
        const_set :SDL_HAPTIC_CONSTANT, (1<<0)
        const_set :SDL_HAPTIC_SINE, (1<<1)
        const_set :SDL_HAPTIC_SQUARE, (1<<2)
        const_set :SDL_HAPTIC_TRIANGLE, (1<<3)
        const_set :SDL_HAPTIC_SAWTOOTHUP, (1<<4)
        const_set :SDL_HAPTIC_SAWTOOTHDOWN, (1<<5)
        const_set :SDL_HAPTIC_RAMP, (1<<6)
        const_set :SDL_HAPTIC_SPRING, (1<<7)
        const_set :SDL_HAPTIC_DAMPER, (1<<8)
        const_set :SDL_HAPTIC_INERTIA, (1<<9)
        const_set :SDL_HAPTIC_FRICTION, (1<<10)
        const_set :SDL_HAPTIC_LEFTRIGHT, (1<<11)
        const_set :SDL_HAPTIC_RESERVED1, (1<<12)
        const_set :SDL_HAPTIC_RESERVED2, (1<<13)
        const_set :SDL_HAPTIC_RESERVED3, (1<<14)
        const_set :SDL_HAPTIC_CUSTOM, (1<<15)
        const_set :SDL_HAPTIC_GAIN, (1<<16)
        const_set :SDL_HAPTIC_AUTOCENTER, (1<<17)
        const_set :SDL_HAPTIC_STATUS, (1<<18)
        const_set :SDL_HAPTIC_PAUSE, (1<<19)
        const_set :SDL_HAPTIC_POLAR, 0
        const_set :SDL_HAPTIC_CARTESIAN, 1
        const_set :SDL_HAPTIC_SPHERICAL, 2
        const_set :SDL_HAPTIC_STEERING_AXIS, 3
        const_set :SDL_HAPTIC_INFINITY, 4294967295
        const_set :SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED, "SDL_ALLOW_ALT_TAB_WHILE_GRABBED"
        const_set :SDL_HINT_ANDROID_ALLOW_RECREATE_ACTIVITY, "SDL_ANDROID_ALLOW_RECREATE_ACTIVITY"
        const_set :SDL_HINT_ANDROID_BLOCK_ON_PAUSE, "SDL_ANDROID_BLOCK_ON_PAUSE"
        const_set :SDL_HINT_ANDROID_LOW_LATENCY_AUDIO, "SDL_ANDROID_LOW_LATENCY_AUDIO"
        const_set :SDL_HINT_ANDROID_TRAP_BACK_BUTTON, "SDL_ANDROID_TRAP_BACK_BUTTON"
        const_set :SDL_HINT_APP_ID, "SDL_APP_ID"
        const_set :SDL_HINT_APP_NAME, "SDL_APP_NAME"
        const_set :SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS, "SDL_APPLE_TV_CONTROLLER_UI_EVENTS"
        const_set :SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION, "SDL_APPLE_TV_REMOTE_ALLOW_ROTATION"
        const_set :SDL_HINT_AUDIO_ALSA_DEFAULT_DEVICE, "SDL_AUDIO_ALSA_DEFAULT_DEVICE"
        const_set :SDL_HINT_AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE, "SDL_AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE"
        const_set :SDL_HINT_AUDIO_ALSA_DEFAULT_RECORDING_DEVICE, "SDL_AUDIO_ALSA_DEFAULT_RECORDING_DEVICE"
        const_set :SDL_HINT_AUDIO_CATEGORY, "SDL_AUDIO_CATEGORY"
        const_set :SDL_HINT_AUDIO_CHANNELS, "SDL_AUDIO_CHANNELS"
        const_set :SDL_HINT_AUDIO_DEVICE_APP_ICON_NAME, "SDL_AUDIO_DEVICE_APP_ICON_NAME"
        const_set :SDL_HINT_AUDIO_DEVICE_SAMPLE_FRAMES, "SDL_AUDIO_DEVICE_SAMPLE_FRAMES"
        const_set :SDL_HINT_AUDIO_DEVICE_STREAM_NAME, "SDL_AUDIO_DEVICE_STREAM_NAME"
        const_set :SDL_HINT_AUDIO_DEVICE_STREAM_ROLE, "SDL_AUDIO_DEVICE_STREAM_ROLE"
        const_set :SDL_HINT_AUDIO_DISK_INPUT_FILE, "SDL_AUDIO_DISK_INPUT_FILE"
        const_set :SDL_HINT_AUDIO_DISK_OUTPUT_FILE, "SDL_AUDIO_DISK_OUTPUT_FILE"
        const_set :SDL_HINT_AUDIO_DISK_TIMESCALE, "SDL_AUDIO_DISK_TIMESCALE"
        const_set :SDL_HINT_AUDIO_DRIVER, "SDL_AUDIO_DRIVER"
        const_set :SDL_HINT_AUDIO_DUMMY_TIMESCALE, "SDL_AUDIO_DUMMY_TIMESCALE"
        const_set :SDL_HINT_AUDIO_FORMAT, "SDL_AUDIO_FORMAT"
        const_set :SDL_HINT_AUDIO_FREQUENCY, "SDL_AUDIO_FREQUENCY"
        const_set :SDL_HINT_AUDIO_INCLUDE_MONITORS, "SDL_AUDIO_INCLUDE_MONITORS"
        const_set :SDL_HINT_AUTO_UPDATE_JOYSTICKS, "SDL_AUTO_UPDATE_JOYSTICKS"
        const_set :SDL_HINT_AUTO_UPDATE_SENSORS, "SDL_AUTO_UPDATE_SENSORS"
        const_set :SDL_HINT_BMP_SAVE_LEGACY_FORMAT, "SDL_BMP_SAVE_LEGACY_FORMAT"
        const_set :SDL_HINT_CAMERA_DRIVER, "SDL_CAMERA_DRIVER"
        const_set :SDL_HINT_CPU_FEATURE_MASK, "SDL_CPU_FEATURE_MASK"
        const_set :SDL_HINT_JOYSTICK_DIRECTINPUT, "SDL_JOYSTICK_DIRECTINPUT"
        const_set :SDL_HINT_FILE_DIALOG_DRIVER, "SDL_FILE_DIALOG_DRIVER"
        const_set :SDL_HINT_DISPLAY_USABLE_BOUNDS, "SDL_DISPLAY_USABLE_BOUNDS"
        const_set :SDL_HINT_EMSCRIPTEN_ASYNCIFY, "SDL_EMSCRIPTEN_ASYNCIFY"
        const_set :SDL_HINT_EMSCRIPTEN_CANVAS_SELECTOR, "SDL_EMSCRIPTEN_CANVAS_SELECTOR"
        const_set :SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT, "SDL_EMSCRIPTEN_KEYBOARD_ELEMENT"
        const_set :SDL_HINT_ENABLE_SCREEN_KEYBOARD, "SDL_ENABLE_SCREEN_KEYBOARD"
        const_set :SDL_HINT_EVDEV_DEVICES, "SDL_EVDEV_DEVICES"
        const_set :SDL_HINT_EVENT_LOGGING, "SDL_EVENT_LOGGING"
        const_set :SDL_HINT_FORCE_RAISEWINDOW, "SDL_FORCE_RAISEWINDOW"
        const_set :SDL_HINT_FRAMEBUFFER_ACCELERATION, "SDL_FRAMEBUFFER_ACCELERATION"
        const_set :SDL_HINT_GAMECONTROLLERCONFIG, "SDL_GAMECONTROLLERCONFIG"
        const_set :SDL_HINT_GAMECONTROLLERCONFIG_FILE, "SDL_GAMECONTROLLERCONFIG_FILE"
        const_set :SDL_HINT_GAMECONTROLLERTYPE, "SDL_GAMECONTROLLERTYPE"
        const_set :SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES, "SDL_GAMECONTROLLER_IGNORE_DEVICES"
        const_set :SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT, "SDL_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT"
        const_set :SDL_HINT_GAMECONTROLLER_SENSOR_FUSION, "SDL_GAMECONTROLLER_SENSOR_FUSION"
        const_set :SDL_HINT_GDK_TEXTINPUT_DEFAULT_TEXT, "SDL_GDK_TEXTINPUT_DEFAULT_TEXT"
        const_set :SDL_HINT_GDK_TEXTINPUT_DESCRIPTION, "SDL_GDK_TEXTINPUT_DESCRIPTION"
        const_set :SDL_HINT_GDK_TEXTINPUT_MAX_LENGTH, "SDL_GDK_TEXTINPUT_MAX_LENGTH"
        const_set :SDL_HINT_GDK_TEXTINPUT_SCOPE, "SDL_GDK_TEXTINPUT_SCOPE"
        const_set :SDL_HINT_GDK_TEXTINPUT_TITLE, "SDL_GDK_TEXTINPUT_TITLE"
        const_set :SDL_HINT_HIDAPI_LIBUSB, "SDL_HIDAPI_LIBUSB"
        const_set :SDL_HINT_HIDAPI_LIBUSB_WHITELIST, "SDL_HIDAPI_LIBUSB_WHITELIST"
        const_set :SDL_HINT_HIDAPI_UDEV, "SDL_HIDAPI_UDEV"
        const_set :SDL_HINT_GPU_DRIVER, "SDL_GPU_DRIVER"
        const_set :SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS, "SDL_HIDAPI_ENUMERATE_ONLY_CONTROLLERS"
        const_set :SDL_HINT_HIDAPI_IGNORE_DEVICES, "SDL_HIDAPI_IGNORE_DEVICES"
        const_set :SDL_HINT_IME_IMPLEMENTED_UI, "SDL_IME_IMPLEMENTED_UI"
        const_set :SDL_HINT_IOS_HIDE_HOME_INDICATOR, "SDL_IOS_HIDE_HOME_INDICATOR"
        const_set :SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS"
        const_set :SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES, "SDL_JOYSTICK_ARCADESTICK_DEVICES"
        const_set :SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED, "SDL_JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED"
        const_set :SDL_HINT_JOYSTICK_BLACKLIST_DEVICES, "SDL_JOYSTICK_BLACKLIST_DEVICES"
        const_set :SDL_HINT_JOYSTICK_BLACKLIST_DEVICES_EXCLUDED, "SDL_JOYSTICK_BLACKLIST_DEVICES_EXCLUDED"
        const_set :SDL_HINT_JOYSTICK_DEVICE, "SDL_JOYSTICK_DEVICE"
        const_set :SDL_HINT_JOYSTICK_ENHANCED_REPORTS, "SDL_JOYSTICK_ENHANCED_REPORTS"
        const_set :SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES, "SDL_JOYSTICK_FLIGHTSTICK_DEVICES"
        const_set :SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED, "SDL_JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED"
        const_set :SDL_HINT_JOYSTICK_GAMEINPUT, "SDL_JOYSTICK_GAMEINPUT"
        const_set :SDL_HINT_JOYSTICK_GAMECUBE_DEVICES, "SDL_JOYSTICK_GAMECUBE_DEVICES"
        const_set :SDL_HINT_JOYSTICK_GAMECUBE_DEVICES_EXCLUDED, "SDL_JOYSTICK_GAMECUBE_DEVICES_EXCLUDED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI, "SDL_JOYSTICK_HIDAPI"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_COMBINE_JOY_CONS, "SDL_JOYSTICK_HIDAPI_COMBINE_JOY_CONS"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE, "SDL_JOYSTICK_HIDAPI_GAMECUBE"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE, "SDL_JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS, "SDL_JOYSTICK_HIDAPI_JOY_CONS"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_JOYCON_HOME_LED, "SDL_JOYSTICK_HIDAPI_JOYCON_HOME_LED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_LUNA, "SDL_JOYSTICK_HIDAPI_LUNA"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_NINTENDO_CLASSIC, "SDL_JOYSTICK_HIDAPI_NINTENDO_CLASSIC"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_PS3, "SDL_JOYSTICK_HIDAPI_PS3"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER, "SDL_JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_PS4, "SDL_JOYSTICK_HIDAPI_PS4"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL, "SDL_JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_PS5, "SDL_JOYSTICK_HIDAPI_PS5"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED, "SDL_JOYSTICK_HIDAPI_PS5_PLAYER_LED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_SHIELD, "SDL_JOYSTICK_HIDAPI_SHIELD"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_STADIA, "SDL_JOYSTICK_HIDAPI_STADIA"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_STEAM, "SDL_JOYSTICK_HIDAPI_STEAM"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_STEAM_HOME_LED, "SDL_JOYSTICK_HIDAPI_STEAM_HOME_LED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_STEAMDECK, "SDL_JOYSTICK_HIDAPI_STEAMDECK"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_STEAM_HORI, "SDL_JOYSTICK_HIDAPI_STEAM_HORI"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_SWITCH, "SDL_JOYSTICK_HIDAPI_SWITCH"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED, "SDL_JOYSTICK_HIDAPI_SWITCH_HOME_LED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED, "SDL_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS, "SDL_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_WII, "SDL_JOYSTICK_HIDAPI_WII"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_WII_PLAYER_LED, "SDL_JOYSTICK_HIDAPI_WII_PLAYER_LED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_XBOX, "SDL_JOYSTICK_HIDAPI_XBOX"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_XBOX_360, "SDL_JOYSTICK_HIDAPI_XBOX_360"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED, "SDL_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_WIRELESS, "SDL_JOYSTICK_HIDAPI_XBOX_360_WIRELESS"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE, "SDL_JOYSTICK_HIDAPI_XBOX_ONE"
        const_set :SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED, "SDL_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED"
        const_set :SDL_HINT_JOYSTICK_IOKIT, "SDL_JOYSTICK_IOKIT"
        const_set :SDL_HINT_JOYSTICK_LINUX_CLASSIC, "SDL_JOYSTICK_LINUX_CLASSIC"
        const_set :SDL_HINT_JOYSTICK_LINUX_DEADZONES, "SDL_JOYSTICK_LINUX_DEADZONES"
        const_set :SDL_HINT_JOYSTICK_LINUX_DIGITAL_HATS, "SDL_JOYSTICK_LINUX_DIGITAL_HATS"
        const_set :SDL_HINT_JOYSTICK_LINUX_HAT_DEADZONES, "SDL_JOYSTICK_LINUX_HAT_DEADZONES"
        const_set :SDL_HINT_JOYSTICK_MFI, "SDL_JOYSTICK_MFI"
        const_set :SDL_HINT_JOYSTICK_RAWINPUT, "SDL_JOYSTICK_RAWINPUT"
        const_set :SDL_HINT_JOYSTICK_RAWINPUT_CORRELATE_XINPUT, "SDL_JOYSTICK_RAWINPUT_CORRELATE_XINPUT"
        const_set :SDL_HINT_JOYSTICK_ROG_CHAKRAM, "SDL_JOYSTICK_ROG_CHAKRAM"
        const_set :SDL_HINT_JOYSTICK_THREAD, "SDL_JOYSTICK_THREAD"
        const_set :SDL_HINT_JOYSTICK_THROTTLE_DEVICES, "SDL_JOYSTICK_THROTTLE_DEVICES"
        const_set :SDL_HINT_JOYSTICK_THROTTLE_DEVICES_EXCLUDED, "SDL_JOYSTICK_THROTTLE_DEVICES_EXCLUDED"
        const_set :SDL_HINT_JOYSTICK_WGI, "SDL_JOYSTICK_WGI"
        const_set :SDL_HINT_JOYSTICK_WHEEL_DEVICES, "SDL_JOYSTICK_WHEEL_DEVICES"
        const_set :SDL_HINT_JOYSTICK_WHEEL_DEVICES_EXCLUDED, "SDL_JOYSTICK_WHEEL_DEVICES_EXCLUDED"
        const_set :SDL_HINT_JOYSTICK_ZERO_CENTERED_DEVICES, "SDL_JOYSTICK_ZERO_CENTERED_DEVICES"
        const_set :SDL_HINT_JOYSTICK_HAPTIC_AXES, "SDL_JOYSTICK_HAPTIC_AXES"
        const_set :SDL_HINT_KEYCODE_OPTIONS, "SDL_KEYCODE_OPTIONS"
        const_set :SDL_HINT_KMSDRM_DEVICE_INDEX, "SDL_KMSDRM_DEVICE_INDEX"
        const_set :SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER, "SDL_KMSDRM_REQUIRE_DRM_MASTER"
        const_set :SDL_HINT_LOGGING, "SDL_LOGGING"
        const_set :SDL_HINT_MAC_BACKGROUND_APP, "SDL_MAC_BACKGROUND_APP"
        const_set :SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK, "SDL_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK"
        const_set :SDL_HINT_MAC_OPENGL_ASYNC_DISPATCH, "SDL_MAC_OPENGL_ASYNC_DISPATCH"
        const_set :SDL_HINT_MAC_OPTION_AS_ALT, "SDL_MAC_OPTION_AS_ALT"
        const_set :SDL_HINT_MAC_SCROLL_MOMENTUM, "SDL_MAC_SCROLL_MOMENTUM"
        const_set :SDL_HINT_MAIN_CALLBACK_RATE, "SDL_MAIN_CALLBACK_RATE"
        const_set :SDL_HINT_MOUSE_AUTO_CAPTURE, "SDL_MOUSE_AUTO_CAPTURE"
        const_set :SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS, "SDL_MOUSE_DOUBLE_CLICK_RADIUS"
        const_set :SDL_HINT_MOUSE_DOUBLE_CLICK_TIME, "SDL_MOUSE_DOUBLE_CLICK_TIME"
        const_set :SDL_HINT_MOUSE_DEFAULT_SYSTEM_CURSOR, "SDL_MOUSE_DEFAULT_SYSTEM_CURSOR"
        const_set :SDL_HINT_MOUSE_EMULATE_WARP_WITH_RELATIVE, "SDL_MOUSE_EMULATE_WARP_WITH_RELATIVE"
        const_set :SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "SDL_MOUSE_FOCUS_CLICKTHROUGH"
        const_set :SDL_HINT_MOUSE_NORMAL_SPEED_SCALE, "SDL_MOUSE_NORMAL_SPEED_SCALE"
        const_set :SDL_HINT_MOUSE_RELATIVE_MODE_CENTER, "SDL_MOUSE_RELATIVE_MODE_CENTER"
        const_set :SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE, "SDL_MOUSE_RELATIVE_SPEED_SCALE"
        const_set :SDL_HINT_MOUSE_RELATIVE_SYSTEM_SCALE, "SDL_MOUSE_RELATIVE_SYSTEM_SCALE"
        const_set :SDL_HINT_MOUSE_RELATIVE_WARP_MOTION, "SDL_MOUSE_RELATIVE_WARP_MOTION"
        const_set :SDL_HINT_MOUSE_RELATIVE_CURSOR_VISIBLE, "SDL_MOUSE_RELATIVE_CURSOR_VISIBLE"
        const_set :SDL_HINT_MOUSE_TOUCH_EVENTS, "SDL_MOUSE_TOUCH_EVENTS"
        const_set :SDL_HINT_MUTE_CONSOLE_KEYBOARD, "SDL_MUTE_CONSOLE_KEYBOARD"
        const_set :SDL_HINT_NO_SIGNAL_HANDLERS, "SDL_NO_SIGNAL_HANDLERS"
        const_set :SDL_HINT_OPENGL_LIBRARY, "SDL_OPENGL_LIBRARY"
        const_set :SDL_HINT_EGL_LIBRARY, "SDL_EGL_LIBRARY"
        const_set :SDL_HINT_OPENGL_ES_DRIVER, "SDL_OPENGL_ES_DRIVER"
        const_set :SDL_HINT_OPENVR_LIBRARY, "SDL_OPENVR_LIBRARY"
        const_set :SDL_HINT_ORIENTATIONS, "SDL_ORIENTATIONS"
        const_set :SDL_HINT_POLL_SENTINEL, "SDL_POLL_SENTINEL"
        const_set :SDL_HINT_PREFERRED_LOCALES, "SDL_PREFERRED_LOCALES"
        const_set :SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE, "SDL_QUIT_ON_LAST_WINDOW_CLOSE"
        const_set :SDL_HINT_RENDER_DIRECT3D_THREADSAFE, "SDL_RENDER_DIRECT3D_THREADSAFE"
        const_set :SDL_HINT_RENDER_DIRECT3D11_DEBUG, "SDL_RENDER_DIRECT3D11_DEBUG"
        const_set :SDL_HINT_RENDER_VULKAN_DEBUG, "SDL_RENDER_VULKAN_DEBUG"
        const_set :SDL_HINT_RENDER_GPU_DEBUG, "SDL_RENDER_GPU_DEBUG"
        const_set :SDL_HINT_RENDER_GPU_LOW_POWER, "SDL_RENDER_GPU_LOW_POWER"
        const_set :SDL_HINT_RENDER_DRIVER, "SDL_RENDER_DRIVER"
        const_set :SDL_HINT_RENDER_LINE_METHOD, "SDL_RENDER_LINE_METHOD"
        const_set :SDL_HINT_RENDER_METAL_PREFER_LOW_POWER_DEVICE, "SDL_RENDER_METAL_PREFER_LOW_POWER_DEVICE"
        const_set :SDL_HINT_RENDER_VSYNC, "SDL_RENDER_VSYNC"
        const_set :SDL_HINT_RETURN_KEY_HIDES_IME, "SDL_RETURN_KEY_HIDES_IME"
        const_set :SDL_HINT_ROG_GAMEPAD_MICE, "SDL_ROG_GAMEPAD_MICE"
        const_set :SDL_HINT_ROG_GAMEPAD_MICE_EXCLUDED, "SDL_ROG_GAMEPAD_MICE_EXCLUDED"
        const_set :SDL_HINT_RPI_VIDEO_LAYER, "SDL_RPI_VIDEO_LAYER"
        const_set :SDL_HINT_SCREENSAVER_INHIBIT_ACTIVITY_NAME, "SDL_SCREENSAVER_INHIBIT_ACTIVITY_NAME"
        const_set :SDL_HINT_SHUTDOWN_DBUS_ON_QUIT, "SDL_SHUTDOWN_DBUS_ON_QUIT"
        const_set :SDL_HINT_STORAGE_TITLE_DRIVER, "SDL_STORAGE_TITLE_DRIVER"
        const_set :SDL_HINT_STORAGE_USER_DRIVER, "SDL_STORAGE_USER_DRIVER"
        const_set :SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL, "SDL_THREAD_FORCE_REALTIME_TIME_CRITICAL"
        const_set :SDL_HINT_THREAD_PRIORITY_POLICY, "SDL_THREAD_PRIORITY_POLICY"
        const_set :SDL_HINT_TIMER_RESOLUTION, "SDL_TIMER_RESOLUTION"
        const_set :SDL_HINT_TOUCH_MOUSE_EVENTS, "SDL_TOUCH_MOUSE_EVENTS"
        const_set :SDL_HINT_TRACKPAD_IS_TOUCH_ONLY, "SDL_TRACKPAD_IS_TOUCH_ONLY"
        const_set :SDL_HINT_TV_REMOTE_AS_JOYSTICK, "SDL_TV_REMOTE_AS_JOYSTICK"
        const_set :SDL_HINT_VIDEO_ALLOW_SCREENSAVER, "SDL_VIDEO_ALLOW_SCREENSAVER"
        const_set :SDL_HINT_VIDEO_DISPLAY_PRIORITY, "SDL_VIDEO_DISPLAY_PRIORITY"
        const_set :SDL_HINT_VIDEO_DOUBLE_BUFFER, "SDL_VIDEO_DOUBLE_BUFFER"
        const_set :SDL_HINT_VIDEO_DRIVER, "SDL_VIDEO_DRIVER"
        const_set :SDL_HINT_VIDEO_DUMMY_SAVE_FRAMES, "SDL_VIDEO_DUMMY_SAVE_FRAMES"
        const_set :SDL_HINT_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK, "SDL_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK"
        const_set :SDL_HINT_VIDEO_FORCE_EGL, "SDL_VIDEO_FORCE_EGL"
        const_set :SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES, "SDL_VIDEO_MAC_FULLSCREEN_SPACES"
        const_set :SDL_HINT_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY, "SDL_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY"
        const_set :SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS, "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS"
        const_set :SDL_HINT_VIDEO_OFFSCREEN_SAVE_FRAMES, "SDL_VIDEO_OFFSCREEN_SAVE_FRAMES"
        const_set :SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS, "SDL_VIDEO_SYNC_WINDOW_OPERATIONS"
        const_set :SDL_HINT_VIDEO_WAYLAND_ALLOW_LIBDECOR, "SDL_VIDEO_WAYLAND_ALLOW_LIBDECOR"
        const_set :SDL_HINT_VIDEO_WAYLAND_MODE_EMULATION, "SDL_VIDEO_WAYLAND_MODE_EMULATION"
        const_set :SDL_HINT_VIDEO_WAYLAND_MODE_SCALING, "SDL_VIDEO_WAYLAND_MODE_SCALING"
        const_set :SDL_HINT_VIDEO_WAYLAND_PREFER_LIBDECOR, "SDL_VIDEO_WAYLAND_PREFER_LIBDECOR"
        const_set :SDL_HINT_VIDEO_WAYLAND_SCALE_TO_DISPLAY, "SDL_VIDEO_WAYLAND_SCALE_TO_DISPLAY"
        const_set :SDL_HINT_VIDEO_WIN_D3DCOMPILER, "SDL_VIDEO_WIN_D3DCOMPILER"
        const_set :SDL_HINT_VIDEO_X11_EXTERNAL_WINDOW_INPUT, "SDL_VIDEO_X11_EXTERNAL_WINDOW_INPUT"
        const_set :SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR, "SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR"
        const_set :SDL_HINT_VIDEO_X11_NET_WM_PING, "SDL_VIDEO_X11_NET_WM_PING"
        const_set :SDL_HINT_VIDEO_X11_NODIRECTCOLOR, "SDL_VIDEO_X11_NODIRECTCOLOR"
        const_set :SDL_HINT_VIDEO_X11_SCALING_FACTOR, "SDL_VIDEO_X11_SCALING_FACTOR"
        const_set :SDL_HINT_VIDEO_X11_VISUALID, "SDL_VIDEO_X11_VISUALID"
        const_set :SDL_HINT_VIDEO_X11_WINDOW_VISUALID, "SDL_VIDEO_X11_WINDOW_VISUALID"
        const_set :SDL_HINT_VIDEO_X11_XRANDR, "SDL_VIDEO_X11_XRANDR"
        const_set :SDL_HINT_VITA_ENABLE_BACK_TOUCH, "SDL_VITA_ENABLE_BACK_TOUCH"
        const_set :SDL_HINT_VITA_ENABLE_FRONT_TOUCH, "SDL_VITA_ENABLE_FRONT_TOUCH"
        const_set :SDL_HINT_VITA_MODULE_PATH, "SDL_VITA_MODULE_PATH"
        const_set :SDL_HINT_VITA_PVR_INIT, "SDL_VITA_PVR_INIT"
        const_set :SDL_HINT_VITA_RESOLUTION, "SDL_VITA_RESOLUTION"
        const_set :SDL_HINT_VITA_PVR_OPENGL, "SDL_VITA_PVR_OPENGL"
        const_set :SDL_HINT_VITA_TOUCH_MOUSE_DEVICE, "SDL_VITA_TOUCH_MOUSE_DEVICE"
        const_set :SDL_HINT_VULKAN_DISPLAY, "SDL_VULKAN_DISPLAY"
        const_set :SDL_HINT_VULKAN_LIBRARY, "SDL_VULKAN_LIBRARY"
        const_set :SDL_HINT_WAVE_FACT_CHUNK, "SDL_WAVE_FACT_CHUNK"
        const_set :SDL_HINT_WAVE_CHUNK_LIMIT, "SDL_WAVE_CHUNK_LIMIT"
        const_set :SDL_HINT_WAVE_RIFF_CHUNK_SIZE, "SDL_WAVE_RIFF_CHUNK_SIZE"
        const_set :SDL_HINT_WAVE_TRUNCATION, "SDL_WAVE_TRUNCATION"
        const_set :SDL_HINT_WINDOW_ACTIVATE_WHEN_RAISED, "SDL_WINDOW_ACTIVATE_WHEN_RAISED"
        const_set :SDL_HINT_WINDOW_ACTIVATE_WHEN_SHOWN, "SDL_WINDOW_ACTIVATE_WHEN_SHOWN"
        const_set :SDL_HINT_WINDOW_ALLOW_TOPMOST, "SDL_WINDOW_ALLOW_TOPMOST"
        const_set :SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN, "SDL_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN"
        const_set :SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4, "SDL_WINDOWS_CLOSE_ON_ALT_F4"
        const_set :SDL_HINT_WINDOWS_ENABLE_MENU_MNEMONICS, "SDL_WINDOWS_ENABLE_MENU_MNEMONICS"
        const_set :SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP, "SDL_WINDOWS_ENABLE_MESSAGELOOP"
        const_set :SDL_HINT_WINDOWS_GAMEINPUT, "SDL_WINDOWS_GAMEINPUT"
        const_set :SDL_HINT_WINDOWS_RAW_KEYBOARD, "SDL_WINDOWS_RAW_KEYBOARD"
        const_set :SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL, "SDL_WINDOWS_FORCE_SEMAPHORE_KERNEL"
        const_set :SDL_HINT_WINDOWS_INTRESOURCE_ICON, "SDL_WINDOWS_INTRESOURCE_ICON"
        const_set :SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL, "SDL_WINDOWS_INTRESOURCE_ICON_SMALL"
        const_set :SDL_HINT_WINDOWS_USE_D3D9EX, "SDL_WINDOWS_USE_D3D9EX"
        const_set :SDL_HINT_WINDOWS_ERASE_BACKGROUND_MODE, "SDL_WINDOWS_ERASE_BACKGROUND_MODE"
        const_set :SDL_HINT_X11_FORCE_OVERRIDE_REDIRECT, "SDL_X11_FORCE_OVERRIDE_REDIRECT"
        const_set :SDL_HINT_X11_WINDOW_TYPE, "SDL_X11_WINDOW_TYPE"
        const_set :SDL_HINT_X11_XCB_LIBRARY, "SDL_X11_XCB_LIBRARY"
        const_set :SDL_HINT_XINPUT_ENABLED, "SDL_XINPUT_ENABLED"
        const_set :SDL_HINT_ASSERT, "SDL_ASSERT"
        const_set :SDL_HINT_PEN_MOUSE_EVENTS, "SDL_PEN_MOUSE_EVENTS"
        const_set :SDL_HINT_PEN_TOUCH_EVENTS, "SDL_PEN_TOUCH_EVENTS"
        const_set :SDL_INIT_AUDIO, 0x00000010
        const_set :SDL_INIT_VIDEO, 0x00000020
        const_set :SDL_INIT_JOYSTICK, 0x00000200
        const_set :SDL_INIT_HAPTIC, 0x00001000
        const_set :SDL_INIT_GAMEPAD, 0x00002000
        const_set :SDL_INIT_EVENTS, 0x00004000
        const_set :SDL_INIT_SENSOR, 0x00008000
        const_set :SDL_INIT_CAMERA, 0x00010000
        const_set :SDL_PROP_APP_METADATA_NAME_STRING, "SDL.app.metadata.name"
        const_set :SDL_PROP_APP_METADATA_VERSION_STRING, "SDL.app.metadata.version"
        const_set :SDL_PROP_APP_METADATA_IDENTIFIER_STRING, "SDL.app.metadata.identifier"
        const_set :SDL_PROP_APP_METADATA_CREATOR_STRING, "SDL.app.metadata.creator"
        const_set :SDL_PROP_APP_METADATA_COPYRIGHT_STRING, "SDL.app.metadata.copyright"
        const_set :SDL_PROP_APP_METADATA_URL_STRING, "SDL.app.metadata.url"
        const_set :SDL_PROP_APP_METADATA_TYPE_STRING, "SDL.app.metadata.type"
        const_set :SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER, "SDL.iostream.windows.handle"
        const_set :SDL_PROP_IOSTREAM_STDIO_FILE_POINTER, "SDL.iostream.stdio.file"
        const_set :SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER, "SDL.iostream.file_descriptor"
        const_set :SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER, "SDL.iostream.android.aasset"
        const_set :SDL_PROP_IOSTREAM_MEMORY_POINTER, "SDL.iostream.memory.base"
        const_set :SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER, "SDL.iostream.memory.size"
        const_set :SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER, "SDL.iostream.dynamic.memory"
        const_set :SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER, "SDL.iostream.dynamic.chunksize"
        const_set :SDL_JOYSTICK_AXIS_MAX, 32767
        const_set :SDL_JOYSTICK_AXIS_MIN, -32768
        const_set :SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN, "SDL.joystick.cap.mono_led"
        const_set :SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN, "SDL.joystick.cap.rgb_led"
        const_set :SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN, "SDL.joystick.cap.player_led"
        const_set :SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN, "SDL.joystick.cap.rumble"
        const_set :SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN, "SDL.joystick.cap.trigger_rumble"
        const_set :SDL_HAT_CENTERED, 0x00
        const_set :SDL_HAT_UP, 0x01
        const_set :SDL_HAT_RIGHT, 0x02
        const_set :SDL_HAT_DOWN, 0x04
        const_set :SDL_HAT_LEFT, 0x08
        const_set :SDL_HAT_RIGHTUP, (SDL_HAT_RIGHT|SDL_HAT_UP)
        const_set :SDL_HAT_RIGHTDOWN, (SDL_HAT_RIGHT|SDL_HAT_DOWN)
        const_set :SDL_HAT_LEFTUP, (SDL_HAT_LEFT|SDL_HAT_UP)
        const_set :SDL_HAT_LEFTDOWN, (SDL_HAT_LEFT|SDL_HAT_DOWN)
        const_set :SDL_PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN, SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN
        const_set :SDL_PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN, SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN
        const_set :SDL_PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN, SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN
        const_set :SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN, SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN
        const_set :SDL_PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN, SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN
        const_set :SDL_PROP_TEXTINPUT_TYPE_NUMBER, "SDL.textinput.type"
        const_set :SDL_PROP_TEXTINPUT_CAPITALIZATION_NUMBER, "SDL.textinput.capitalization"
        const_set :SDL_PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN, "SDL.textinput.autocorrect"
        const_set :SDL_PROP_TEXTINPUT_MULTILINE_BOOLEAN, "SDL.textinput.multiline"
        const_set :SDL_PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER, "SDL.textinput.android.inputtype"
        module_function def SDL_SCANCODE_TO_KEYCODE(x) = (x | SDLK_SCANCODE_MASK)
        const_set :SDL_KMOD_NONE, 0x0000
        const_set :SDL_KMOD_LSHIFT, 0x0001
        const_set :SDL_KMOD_RSHIFT, 0x0002
        const_set :SDL_KMOD_LEVEL5, 0x0004
        const_set :SDL_KMOD_LCTRL, 0x0040
        const_set :SDL_KMOD_RCTRL, 0x0080
        const_set :SDL_KMOD_LALT, 0x0100
        const_set :SDL_KMOD_RALT, 0x0200
        const_set :SDL_KMOD_LGUI, 0x0400
        const_set :SDL_KMOD_RGUI, 0x0800
        const_set :SDL_KMOD_NUM, 0x1000
        const_set :SDL_KMOD_CAPS, 0x2000
        const_set :SDL_KMOD_MODE, 0x4000
        const_set :SDL_KMOD_SCROLL, 0x8000
        const_set :SDL_KMOD_CTRL, (SDL_KMOD_LCTRL | SDL_KMOD_RCTRL)
        const_set :SDL_KMOD_SHIFT, (SDL_KMOD_LSHIFT | SDL_KMOD_RSHIFT)
        const_set :SDL_KMOD_ALT, (SDL_KMOD_LALT | SDL_KMOD_RALT)
        const_set :SDL_KMOD_GUI, (SDL_KMOD_LGUI | SDL_KMOD_RGUI)
        const_set :SDL_MESSAGEBOX_ERROR, 0x00000010
        const_set :SDL_MESSAGEBOX_WARNING, 0x00000020
        const_set :SDL_MESSAGEBOX_INFORMATION, 0x00000040
        const_set :SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT, 0x00000080
        const_set :SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT, 0x00000100
        const_set :SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT, 0x00000001
        const_set :SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT, 0x00000002
        const_set :SDL_BUTTON_LEFT, 1
        const_set :SDL_BUTTON_MIDDLE, 2
        const_set :SDL_BUTTON_RIGHT, 3
        const_set :SDL_BUTTON_X1, 4
        const_set :SDL_BUTTON_X2, 5
        module_function def SDL_BUTTON_MASK(x) = (1 << ((x)-1))
        const_set :SDL_BUTTON_LMASK, SDL_BUTTON_MASK(SDL_BUTTON_LEFT)
        const_set :SDL_BUTTON_MMASK, SDL_BUTTON_MASK(SDL_BUTTON_MIDDLE)
        const_set :SDL_BUTTON_RMASK, SDL_BUTTON_MASK(SDL_BUTTON_RIGHT)
        const_set :SDL_BUTTON_X1MASK, SDL_BUTTON_MASK(SDL_BUTTON_X1)
        const_set :SDL_BUTTON_X2MASK, SDL_BUTTON_MASK(SDL_BUTTON_X2)
        const_set :SDL_PEN_MOUSEID, (SDL_MouseID(-2))
        const_set :SDL_PEN_TOUCHID, (SDL_TouchID(-2))
        const_set :SDL_PEN_INPUT_DOWN, (1 << 0)
        const_set :SDL_PEN_INPUT_BUTTON_1, (1 << 1)
        const_set :SDL_PEN_INPUT_BUTTON_2, (1 << 2)
        const_set :SDL_PEN_INPUT_BUTTON_3, (1 << 3)
        const_set :SDL_PEN_INPUT_BUTTON_4, (1 << 4)
        const_set :SDL_PEN_INPUT_BUTTON_5, (1 << 5)
        const_set :SDL_PEN_INPUT_ERASER_TIP, (1 << 30)
        const_set :SDL_ALPHA_OPAQUE, 255
        const_set :SDL_ALPHA_OPAQUE_FLOAT, 1.0
        const_set :SDL_ALPHA_TRANSPARENT, 0
        const_set :SDL_ALPHA_TRANSPARENT_FLOAT, 0.0
        module_function def SDL_DEFINE_PIXELFOURCC(a, b, c, d) = SDL_FOURCC(a, b, c, d)
        module_function def SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) = ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | ((bits) << 8) | ((bytes) << 0))
        module_function def SDL_PIXELFLAG(format) = (((format) >> 28) & 0x0F)
        module_function def SDL_PIXELTYPE(format) = (((format) >> 24) & 0x0F)
        module_function def SDL_PIXELORDER(format) = (((format) >> 20) & 0x0F)
        module_function def SDL_PIXELLAYOUT(format) = (((format) >> 16) & 0x0F)
        module_function def SDL_BITSPERPIXEL(format) = (SDL_ISPIXELFORMAT_FOURCC(format) ? 0 : (((format) >> 8) & 0xFF))
        module_function def SDL_BYTESPERPIXEL(format) = (SDL_ISPIXELFORMAT_FOURCC(format) ? ((((format) == SDL_PIXELFORMAT_YUY2) || ((format) == SDL_PIXELFORMAT_UYVY) || ((format) == SDL_PIXELFORMAT_YVYU) || ((format) == SDL_PIXELFORMAT_P010)) ? 2 : 1) : (((format) >> 0) & 0xFF))
        module_function def SDL_ISPIXELFORMAT_INDEXED(format) = (!SDL_ISPIXELFORMAT_FOURCC(format) && ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX1) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX2) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX4) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX8)))
        module_function def SDL_ISPIXELFORMAT_PACKED(format) = (!SDL_ISPIXELFORMAT_FOURCC(format) && ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED8) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED16) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED32)))
        module_function def SDL_ISPIXELFORMAT_ARRAY(format) = (!SDL_ISPIXELFORMAT_FOURCC(format) && ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU8) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU16) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU32) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF16) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF32)))
        module_function def SDL_ISPIXELFORMAT_10BIT(format) = (!SDL_ISPIXELFORMAT_FOURCC(format) && ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED32) && (SDL_PIXELLAYOUT(format) == SDL_PACKEDLAYOUT_2101010)))
        module_function def SDL_ISPIXELFORMAT_FLOAT(format) = (!SDL_ISPIXELFORMAT_FOURCC(format) && ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF16) || (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF32)))
        module_function def SDL_ISPIXELFORMAT_ALPHA(format) = ((SDL_ISPIXELFORMAT_PACKED(format) && ((SDL_PIXELORDER(format) == SDL_PACKEDORDER_ARGB) || (SDL_PIXELORDER(format) == SDL_PACKEDORDER_RGBA) || (SDL_PIXELORDER(format) == SDL_PACKEDORDER_ABGR) || (SDL_PIXELORDER(format) == SDL_PACKEDORDER_BGRA))) || (SDL_ISPIXELFORMAT_ARRAY(format) && ((SDL_PIXELORDER(format) == SDL_ARRAYORDER_ARGB) || (SDL_PIXELORDER(format) == SDL_ARRAYORDER_RGBA) || (SDL_PIXELORDER(format) == SDL_ARRAYORDER_ABGR) || (SDL_PIXELORDER(format) == SDL_ARRAYORDER_BGRA))))
        module_function def SDL_ISPIXELFORMAT_FOURCC(format) = ((format) && (SDL_PIXELFLAG(format) != 1))
        module_function def SDL_DEFINE_COLORSPACE(type, range, primaries, transfer, matrix, chroma) = ((Uint32(type) << 28) | (Uint32(range) << 24) | (Uint32(chroma) << 20) | (Uint32(primaries) << 10) | (Uint32(transfer) << 5) | (Uint32(matrix) << 0))
        module_function def SDL_COLORSPACETYPE(cspace) = SDL_ColorType(((cspace) >> 28) & 0x0F)
        module_function def SDL_COLORSPACERANGE(cspace) = SDL_ColorRange(((cspace) >> 24) & 0x0F)
        module_function def SDL_COLORSPACECHROMA(cspace) = SDL_ChromaLocation(((cspace) >> 20) & 0x0F)
        module_function def SDL_COLORSPACEPRIMARIES(cspace) = SDL_ColorPrimaries(((cspace) >> 10) & 0x1F)
        module_function def SDL_COLORSPACETRANSFER(cspace) = SDL_TransferCharacteristics(((cspace) >> 5) & 0x1F)
        module_function def SDL_COLORSPACEMATRIX(cspace) = SDL_MatrixCoefficients((cspace) & 0x1F)
        module_function def SDL_ISCOLORSPACE_MATRIX_BT601(cspace) = (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT601 || SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT470BG)
        module_function def SDL_ISCOLORSPACE_MATRIX_BT709(cspace) = (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT709)
        module_function def SDL_ISCOLORSPACE_MATRIX_BT2020_NCL(cspace) = (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT2020_NCL)
        module_function def SDL_ISCOLORSPACE_LIMITED_RANGE(cspace) = (SDL_COLORSPACERANGE(cspace) != SDL_COLOR_RANGE_FULL)
        module_function def SDL_ISCOLORSPACE_FULL_RANGE(cspace) = (SDL_COLORSPACERANGE(cspace) == SDL_COLOR_RANGE_FULL)
        const_set :SDL_PROP_PROCESS_CREATE_ARGS_POINTER, "SDL.process.create.args"
        const_set :SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER, "SDL.process.create.environment"
        const_set :SDL_PROP_PROCESS_CREATE_STDIN_NUMBER, "SDL.process.create.stdin_option"
        const_set :SDL_PROP_PROCESS_CREATE_STDIN_POINTER, "SDL.process.create.stdin_source"
        const_set :SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER, "SDL.process.create.stdout_option"
        const_set :SDL_PROP_PROCESS_CREATE_STDOUT_POINTER, "SDL.process.create.stdout_source"
        const_set :SDL_PROP_PROCESS_CREATE_STDERR_NUMBER, "SDL.process.create.stderr_option"
        const_set :SDL_PROP_PROCESS_CREATE_STDERR_POINTER, "SDL.process.create.stderr_source"
        const_set :SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN, "SDL.process.create.stderr_to_stdout"
        const_set :SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN, "SDL.process.create.background"
        const_set :SDL_PROP_PROCESS_PID_NUMBER, "SDL.process.pid"
        const_set :SDL_PROP_PROCESS_STDIN_POINTER, "SDL.process.stdin"
        const_set :SDL_PROP_PROCESS_STDOUT_POINTER, "SDL.process.stdout"
        const_set :SDL_PROP_PROCESS_STDERR_POINTER, "SDL.process.stderr"
        const_set :SDL_PROP_PROCESS_BACKGROUND_BOOLEAN, "SDL.process.background"
        const_set :SDL_SOFTWARE_RENDERER, "software"
        const_set :SDL_PROP_RENDERER_CREATE_NAME_STRING, "SDL.renderer.create.name"
        const_set :SDL_PROP_RENDERER_CREATE_WINDOW_POINTER, "SDL.renderer.create.window"
        const_set :SDL_PROP_RENDERER_CREATE_SURFACE_POINTER, "SDL.renderer.create.surface"
        const_set :SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER, "SDL.renderer.create.output_colorspace"
        const_set :SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER, "SDL.renderer.create.present_vsync"
        const_set :SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER, "SDL.renderer.create.vulkan.instance"
        const_set :SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER, "SDL.renderer.create.vulkan.surface"
        const_set :SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER, "SDL.renderer.create.vulkan.physical_device"
        const_set :SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER, "SDL.renderer.create.vulkan.device"
        const_set :SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER, "SDL.renderer.create.vulkan.graphics_queue_family_index"
        const_set :SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER, "SDL.renderer.create.vulkan.present_queue_family_index"
        const_set :SDL_PROP_RENDERER_NAME_STRING, "SDL.renderer.name"
        const_set :SDL_PROP_RENDERER_WINDOW_POINTER, "SDL.renderer.window"
        const_set :SDL_PROP_RENDERER_SURFACE_POINTER, "SDL.renderer.surface"
        const_set :SDL_PROP_RENDERER_VSYNC_NUMBER, "SDL.renderer.vsync"
        const_set :SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER, "SDL.renderer.max_texture_size"
        const_set :SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER, "SDL.renderer.texture_formats"
        const_set :SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER, "SDL.renderer.output_colorspace"
        const_set :SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN, "SDL.renderer.HDR_enabled"
        const_set :SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT, "SDL.renderer.SDR_white_point"
        const_set :SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT, "SDL.renderer.HDR_headroom"
        const_set :SDL_PROP_RENDERER_D3D9_DEVICE_POINTER, "SDL.renderer.d3d9.device"
        const_set :SDL_PROP_RENDERER_D3D11_DEVICE_POINTER, "SDL.renderer.d3d11.device"
        const_set :SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER, "SDL.renderer.d3d11.swap_chain"
        const_set :SDL_PROP_RENDERER_D3D12_DEVICE_POINTER, "SDL.renderer.d3d12.device"
        const_set :SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER, "SDL.renderer.d3d12.swap_chain"
        const_set :SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER, "SDL.renderer.d3d12.command_queue"
        const_set :SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER, "SDL.renderer.vulkan.instance"
        const_set :SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER, "SDL.renderer.vulkan.surface"
        const_set :SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER, "SDL.renderer.vulkan.physical_device"
        const_set :SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER, "SDL.renderer.vulkan.device"
        const_set :SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER, "SDL.renderer.vulkan.graphics_queue_family_index"
        const_set :SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER, "SDL.renderer.vulkan.present_queue_family_index"
        const_set :SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER, "SDL.renderer.vulkan.swapchain_image_count"
        const_set :SDL_PROP_RENDERER_GPU_DEVICE_POINTER, "SDL.renderer.gpu.device"
        const_set :SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER, "SDL.texture.create.colorspace"
        const_set :SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER, "SDL.texture.create.format"
        const_set :SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER, "SDL.texture.create.access"
        const_set :SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER, "SDL.texture.create.width"
        const_set :SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER, "SDL.texture.create.height"
        const_set :SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT, "SDL.texture.create.SDR_white_point"
        const_set :SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT, "SDL.texture.create.HDR_headroom"
        const_set :SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER, "SDL.texture.create.d3d11.texture"
        const_set :SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER, "SDL.texture.create.d3d11.texture_u"
        const_set :SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER, "SDL.texture.create.d3d11.texture_v"
        const_set :SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER, "SDL.texture.create.d3d12.texture"
        const_set :SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER, "SDL.texture.create.d3d12.texture_u"
        const_set :SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER, "SDL.texture.create.d3d12.texture_v"
        const_set :SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER, "SDL.texture.create.metal.pixelbuffer"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER, "SDL.texture.create.opengl.texture"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER, "SDL.texture.create.opengl.texture_uv"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER, "SDL.texture.create.opengl.texture_u"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER, "SDL.texture.create.opengl.texture_v"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER, "SDL.texture.create.opengles2.texture"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER, "SDL.texture.create.opengles2.texture_uv"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER, "SDL.texture.create.opengles2.texture_u"
        const_set :SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER, "SDL.texture.create.opengles2.texture_v"
        const_set :SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER, "SDL.texture.create.vulkan.texture"
        const_set :SDL_PROP_TEXTURE_COLORSPACE_NUMBER, "SDL.texture.colorspace"
        const_set :SDL_PROP_TEXTURE_FORMAT_NUMBER, "SDL.texture.format"
        const_set :SDL_PROP_TEXTURE_ACCESS_NUMBER, "SDL.texture.access"
        const_set :SDL_PROP_TEXTURE_WIDTH_NUMBER, "SDL.texture.width"
        const_set :SDL_PROP_TEXTURE_HEIGHT_NUMBER, "SDL.texture.height"
        const_set :SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT, "SDL.texture.SDR_white_point"
        const_set :SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT, "SDL.texture.HDR_headroom"
        const_set :SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER, "SDL.texture.d3d11.texture"
        const_set :SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER, "SDL.texture.d3d11.texture_u"
        const_set :SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER, "SDL.texture.d3d11.texture_v"
        const_set :SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER, "SDL.texture.d3d12.texture"
        const_set :SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER, "SDL.texture.d3d12.texture_u"
        const_set :SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER, "SDL.texture.d3d12.texture_v"
        const_set :SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER, "SDL.texture.opengl.texture"
        const_set :SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER, "SDL.texture.opengl.texture_uv"
        const_set :SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER, "SDL.texture.opengl.texture_u"
        const_set :SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER, "SDL.texture.opengl.texture_v"
        const_set :SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER, "SDL.texture.opengl.target"
        const_set :SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT, "SDL.texture.opengl.tex_w"
        const_set :SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT, "SDL.texture.opengl.tex_h"
        const_set :SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER, "SDL.texture.opengles2.texture"
        const_set :SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER, "SDL.texture.opengles2.texture_uv"
        const_set :SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER, "SDL.texture.opengles2.texture_u"
        const_set :SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER, "SDL.texture.opengles2.texture_v"
        const_set :SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER, "SDL.texture.opengles2.target"
        const_set :SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER, "SDL.texture.vulkan.texture"
        const_set :SDL_RENDERER_VSYNC_DISABLED, 0
        const_set :SDL_RENDERER_VSYNC_ADAPTIVE, (-1)
        const_set :SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE, 8
        const_set :SDL_STANDARD_GRAVITY, 9.80665
        const_set :SDL_SURFACE_PREALLOCATED, 0x00000001
        const_set :SDL_SURFACE_LOCK_NEEDED, 0x00000002
        const_set :SDL_SURFACE_LOCKED, 0x00000004
        const_set :SDL_SURFACE_SIMD_ALIGNED, 0x00000008
        module_function def SDL_MUSTLOCK(s) = (((s).flags & SDL_SURFACE_LOCK_NEEDED) == SDL_SURFACE_LOCK_NEEDED)
        const_set :SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT, "SDL.surface.SDR_white_point"
        const_set :SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT, "SDL.surface.HDR_headroom"
        const_set :SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING, "SDL.surface.tonemap"
        const_set :SDL_PROP_SURFACE_HOTSPOT_X_NUMBER, "SDL.surface.hotspot.x"
        const_set :SDL_PROP_SURFACE_HOTSPOT_Y_NUMBER, "SDL.surface.hotspot.y"
        const_set :SDL_ANDROID_EXTERNAL_STORAGE_READ, 0x01
        const_set :SDL_ANDROID_EXTERNAL_STORAGE_WRITE, 0x02
        const_set :SDL_MS_PER_SECOND, 1000
        const_set :SDL_US_PER_SECOND, 1000000
        const_set :SDL_NS_PER_SECOND, 1000000000
        const_set :SDL_NS_PER_MS, 1000000
        const_set :SDL_NS_PER_US, 1000
        module_function def SDL_SECONDS_TO_NS(s) = ((Uint64(s)) * SDL_NS_PER_SECOND)
        module_function def SDL_NS_TO_SECONDS(ns) = ((ns) / SDL_NS_PER_SECOND)
        module_function def SDL_MS_TO_NS(ms) = ((Uint64(ms)) * SDL_NS_PER_MS)
        module_function def SDL_NS_TO_MS(ns) = ((ns) / SDL_NS_PER_MS)
        module_function def SDL_US_TO_NS(us) = ((Uint64(us)) * SDL_NS_PER_US)
        module_function def SDL_NS_TO_US(ns) = ((ns) / SDL_NS_PER_US)
        const_set :SDL_TOUCH_MOUSEID, (SDL_MouseID(-1))
        const_set :SDL_MOUSE_TOUCHID, (SDL_TouchID(-1))
        const_set :SDL_TRAYENTRY_BUTTON, 0x00000001
        const_set :SDL_TRAYENTRY_CHECKBOX, 0x00000002
        const_set :SDL_TRAYENTRY_SUBMENU, 0x00000004
        const_set :SDL_TRAYENTRY_DISABLED, 0x80000000
        const_set :SDL_TRAYENTRY_CHECKED, 0x40000000
        const_set :SDL_MAJOR_VERSION, 3
        const_set :SDL_MINOR_VERSION, 2
        const_set :SDL_MICRO_VERSION, 28
        module_function def SDL_VERSIONNUM(major, minor, patch) = ((major) * 1000000 + (minor) * 1000 + (patch))
        module_function def SDL_VERSIONNUM_MAJOR(version) = ((version) / 1000000)
        module_function def SDL_VERSIONNUM_MINOR(version) = (((version) / 1000) % 1000)
        module_function def SDL_VERSIONNUM_MICRO(version) = ((version) % 1000)
        const_set :SDL_VERSION, SDL_VERSIONNUM(SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION)
        module_function def SDL_VERSION_ATLEAST(x, y, z) = (SDL_VERSION >= SDL_VERSIONNUM(x, y, z))
        const_set :SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER, "SDL.video.wayland.wl_display"
        const_set :SDL_WINDOW_FULLSCREEN, SDL_UINT64_C(0x0000000000000001)
        const_set :SDL_WINDOW_OPENGL, SDL_UINT64_C(0x0000000000000002)
        const_set :SDL_WINDOW_OCCLUDED, SDL_UINT64_C(0x0000000000000004)
        const_set :SDL_WINDOW_HIDDEN, SDL_UINT64_C(0x0000000000000008)
        const_set :SDL_WINDOW_BORDERLESS, SDL_UINT64_C(0x0000000000000010)
        const_set :SDL_WINDOW_RESIZABLE, SDL_UINT64_C(0x0000000000000020)
        const_set :SDL_WINDOW_MINIMIZED, SDL_UINT64_C(0x0000000000000040)
        const_set :SDL_WINDOW_MAXIMIZED, SDL_UINT64_C(0x0000000000000080)
        const_set :SDL_WINDOW_MOUSE_GRABBED, SDL_UINT64_C(0x0000000000000100)
        const_set :SDL_WINDOW_INPUT_FOCUS, SDL_UINT64_C(0x0000000000000200)
        const_set :SDL_WINDOW_MOUSE_FOCUS, SDL_UINT64_C(0x0000000000000400)
        const_set :SDL_WINDOW_EXTERNAL, SDL_UINT64_C(0x0000000000000800)
        const_set :SDL_WINDOW_MODAL, SDL_UINT64_C(0x0000000000001000)
        const_set :SDL_WINDOW_HIGH_PIXEL_DENSITY, SDL_UINT64_C(0x0000000000002000)
        const_set :SDL_WINDOW_MOUSE_CAPTURE, SDL_UINT64_C(0x0000000000004000)
        const_set :SDL_WINDOW_MOUSE_RELATIVE_MODE, SDL_UINT64_C(0x0000000000008000)
        const_set :SDL_WINDOW_ALWAYS_ON_TOP, SDL_UINT64_C(0x0000000000010000)
        const_set :SDL_WINDOW_UTILITY, SDL_UINT64_C(0x0000000000020000)
        const_set :SDL_WINDOW_TOOLTIP, SDL_UINT64_C(0x0000000000040000)
        const_set :SDL_WINDOW_POPUP_MENU, SDL_UINT64_C(0x0000000000080000)
        const_set :SDL_WINDOW_KEYBOARD_GRABBED, SDL_UINT64_C(0x0000000000100000)
        const_set :SDL_WINDOW_VULKAN, SDL_UINT64_C(0x0000000010000000)
        const_set :SDL_WINDOW_METAL, SDL_UINT64_C(0x0000000020000000)
        const_set :SDL_WINDOW_TRANSPARENT, SDL_UINT64_C(0x0000000040000000)
        const_set :SDL_WINDOW_NOT_FOCUSABLE, SDL_UINT64_C(0x0000000080000000)
        const_set :SDL_WINDOWPOS_UNDEFINED_MASK, 0x1FFF0000
        module_function def SDL_WINDOWPOS_UNDEFINED_DISPLAY(x) = (SDL_WINDOWPOS_UNDEFINED_MASK|(x))
        const_set :SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED_DISPLAY(0)
        module_function def SDL_WINDOWPOS_ISUNDEFINED(x) = (((x)&0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK)
        const_set :SDL_WINDOWPOS_CENTERED_MASK, 0x2FFF0000
        module_function def SDL_WINDOWPOS_CENTERED_DISPLAY(x) = (SDL_WINDOWPOS_CENTERED_MASK|(x))
        const_set :SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED_DISPLAY(0)
        module_function def SDL_WINDOWPOS_ISCENTERED(x) = (((x)&0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK)
        const_set :SDL_GL_CONTEXT_PROFILE_CORE, 0x0001
        const_set :SDL_GL_CONTEXT_PROFILE_COMPATIBILITY, 0x0002
        const_set :SDL_GL_CONTEXT_PROFILE_ES, 0x0004
        const_set :SDL_GL_CONTEXT_DEBUG_FLAG, 0x0001
        const_set :SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG, 0x0002
        const_set :SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG, 0x0004
        const_set :SDL_GL_CONTEXT_RESET_ISOLATION_FLAG, 0x0008
        const_set :SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE, 0x0000
        const_set :SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH, 0x0001
        const_set :SDL_GL_CONTEXT_RESET_NO_NOTIFICATION, 0x0000
        const_set :SDL_GL_CONTEXT_RESET_LOSE_CONTEXT, 0x0001
        const_set :SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN, "SDL.display.HDR_enabled"
        const_set :SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER, "SDL.display.KMSDRM.panel_orientation"
        const_set :SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN, "SDL.window.create.always_on_top"
        const_set :SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN, "SDL.window.create.borderless"
        const_set :SDL_PROP_WINDOW_CREATE_CONSTRAIN_POPUP_BOOLEAN, "SDL.window.create.constrain_popup"
        const_set :SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN, "SDL.window.create.focusable"
        const_set :SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN, "SDL.window.create.external_graphics_context"
        const_set :SDL_PROP_WINDOW_CREATE_FLAGS_NUMBER, "SDL.window.create.flags"
        const_set :SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN, "SDL.window.create.fullscreen"
        const_set :SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER, "SDL.window.create.height"
        const_set :SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN, "SDL.window.create.hidden"
        const_set :SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN, "SDL.window.create.high_pixel_density"
        const_set :SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN, "SDL.window.create.maximized"
        const_set :SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN, "SDL.window.create.menu"
        const_set :SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN, "SDL.window.create.metal"
        const_set :SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN, "SDL.window.create.minimized"
        const_set :SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN, "SDL.window.create.modal"
        const_set :SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN, "SDL.window.create.mouse_grabbed"
        const_set :SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN, "SDL.window.create.opengl"
        const_set :SDL_PROP_WINDOW_CREATE_PARENT_POINTER, "SDL.window.create.parent"
        const_set :SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN, "SDL.window.create.resizable"
        const_set :SDL_PROP_WINDOW_CREATE_TITLE_STRING, "SDL.window.create.title"
        const_set :SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN, "SDL.window.create.transparent"
        const_set :SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN, "SDL.window.create.tooltip"
        const_set :SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN, "SDL.window.create.utility"
        const_set :SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN, "SDL.window.create.vulkan"
        const_set :SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER, "SDL.window.create.width"
        const_set :SDL_PROP_WINDOW_CREATE_X_NUMBER, "SDL.window.create.x"
        const_set :SDL_PROP_WINDOW_CREATE_Y_NUMBER, "SDL.window.create.y"
        const_set :SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER, "SDL.window.create.cocoa.window"
        const_set :SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER, "SDL.window.create.cocoa.view"
        const_set :SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN, "SDL.window.create.wayland.surface_role_custom"
        const_set :SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN, "SDL.window.create.wayland.create_egl_window"
        const_set :SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER, "SDL.window.create.wayland.wl_surface"
        const_set :SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER, "SDL.window.create.win32.hwnd"
        const_set :SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER, "SDL.window.create.win32.pixel_format_hwnd"
        const_set :SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER, "SDL.window.create.x11.window"
        const_set :SDL_PROP_WINDOW_SHAPE_POINTER, "SDL.window.shape"
        const_set :SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN, "SDL.window.HDR_enabled"
        const_set :SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT, "SDL.window.SDR_white_level"
        const_set :SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT, "SDL.window.HDR_headroom"
        const_set :SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER, "SDL.window.android.window"
        const_set :SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER, "SDL.window.android.surface"
        const_set :SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER, "SDL.window.uikit.window"
        const_set :SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER, "SDL.window.uikit.metal_view_tag"
        const_set :SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER, "SDL.window.uikit.opengl.framebuffer"
        const_set :SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER, "SDL.window.uikit.opengl.renderbuffer"
        const_set :SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER, "SDL.window.uikit.opengl.resolve_framebuffer"
        const_set :SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER, "SDL.window.kmsdrm.dev_index"
        const_set :SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER, "SDL.window.kmsdrm.drm_fd"
        const_set :SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER, "SDL.window.kmsdrm.gbm_dev"
        const_set :SDL_PROP_WINDOW_COCOA_WINDOW_POINTER, "SDL.window.cocoa.window"
        const_set :SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER, "SDL.window.cocoa.metal_view_tag"
        const_set :SDL_PROP_WINDOW_OPENVR_OVERLAY_ID, "SDL.window.openvr.overlay_id"
        const_set :SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER, "SDL.window.vivante.display"
        const_set :SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER, "SDL.window.vivante.window"
        const_set :SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER, "SDL.window.vivante.surface"
        const_set :SDL_PROP_WINDOW_WIN32_HWND_POINTER, "SDL.window.win32.hwnd"
        const_set :SDL_PROP_WINDOW_WIN32_HDC_POINTER, "SDL.window.win32.hdc"
        const_set :SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER, "SDL.window.win32.instance"
        const_set :SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER, "SDL.window.wayland.display"
        const_set :SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER, "SDL.window.wayland.surface"
        const_set :SDL_PROP_WINDOW_WAYLAND_VIEWPORT_POINTER, "SDL.window.wayland.viewport"
        const_set :SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER, "SDL.window.wayland.egl_window"
        const_set :SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER, "SDL.window.wayland.xdg_surface"
        const_set :SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER, "SDL.window.wayland.xdg_toplevel"
        const_set :SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING, "SDL.window.wayland.xdg_toplevel_export_handle"
        const_set :SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER, "SDL.window.wayland.xdg_popup"
        const_set :SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER, "SDL.window.wayland.xdg_positioner"
        const_set :SDL_PROP_WINDOW_X11_DISPLAY_POINTER, "SDL.window.x11.display"
        const_set :SDL_PROP_WINDOW_X11_SCREEN_NUMBER, "SDL.window.x11.screen"
        const_set :SDL_PROP_WINDOW_X11_WINDOW_NUMBER, "SDL.window.x11.window"
        const_set :SDL_WINDOW_SURFACE_VSYNC_DISABLED, 0
        const_set :SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE, (-1)

        # Fiddle declarations for SDL functions, structs, and enums
        #
        typealias "Sint8", "int8_t"
        typealias "Uint8", "uint8_t"
        typealias "Sint16", "int16_t"
        typealias "Uint16", "uint16_t"
        typealias "Sint32", "int32_t"
        typealias "Uint32", "uint32_t"
        typealias "Sint64", "int64_t"
        typealias "Uint64", "uint64_t"
        typealias "SDL_Time", "Sint64"
        const_set :SDL_alignment_test, struct(
          [
            "Uint8 a",
            "void * b",
          ]
        )
        const_set :DUMMY_ENUM_VALUE, 0
        typealias "SDL_DUMMY_ENUM", "enum"
        extern "void * SDL_malloc(size_t)"
        extern "void * SDL_calloc(size_t, size_t)"
        extern "void * SDL_realloc(void *, size_t)"
        extern "void SDL_free(void *)"
        typealias "SDL_malloc_func", "function (*pointer)()"
        const_set :SDL_malloc_func, "void * SDL_malloc_func(size_t)"
        typealias "SDL_calloc_func", "function (*pointer)()"
        const_set :SDL_calloc_func, "void * SDL_calloc_func(size_t, size_t)"
        typealias "SDL_realloc_func", "function (*pointer)()"
        const_set :SDL_realloc_func, "void * SDL_realloc_func(void *, size_t)"
        typealias "SDL_free_func", "function (*pointer)()"
        const_set :SDL_free_func, "void SDL_free_func(void *)"
        extern "void SDL_GetOriginalMemoryFunctions(SDL_malloc_func *, SDL_calloc_func *, SDL_realloc_func *, SDL_free_func *)"
        extern "void SDL_GetMemoryFunctions(SDL_malloc_func *, SDL_calloc_func *, SDL_realloc_func *, SDL_free_func *)"
        extern "bool SDL_SetMemoryFunctions(SDL_malloc_func, SDL_calloc_func, SDL_realloc_func, SDL_free_func)"
        extern "void * SDL_aligned_alloc(size_t, size_t)"
        extern "void SDL_aligned_free(void *)"
        extern "int SDL_GetNumAllocations(void)"
        extern "SDL_Environment * SDL_GetEnvironment(void)"
        extern "SDL_Environment * SDL_CreateEnvironment(bool)"
        extern "char * SDL_GetEnvironmentVariable(SDL_Environment *, char *)"
        extern "char ** SDL_GetEnvironmentVariables(SDL_Environment *)"
        extern "bool SDL_SetEnvironmentVariable(SDL_Environment *, char *, char *, bool)"
        extern "bool SDL_UnsetEnvironmentVariable(SDL_Environment *, char *)"
        extern "void SDL_DestroyEnvironment(SDL_Environment *)"
        extern "char * SDL_getenv(char *)"
        extern "char * SDL_getenv_unsafe(char *)"
        extern "int SDL_setenv_unsafe(char *, char *, int)"
        extern "int SDL_unsetenv_unsafe(char *)"
        typealias "SDL_CompareCallback", "function (*pointer)()"
        const_set :SDL_CompareCallback, "int SDL_CompareCallback(void *, void *)"
        extern "void SDL_qsort(void *, size_t, size_t, SDL_CompareCallback)"
        extern "void * SDL_bsearch(void *, void *, size_t, size_t, SDL_CompareCallback)"
        typealias "SDL_CompareCallback_r", "function (*pointer)()"
        const_set :SDL_CompareCallback_r, "int SDL_CompareCallback_r(void *, void *, void *)"
        extern "void SDL_qsort_r(void *, size_t, size_t, SDL_CompareCallback_r, void *)"
        extern "void * SDL_bsearch_r(void *, void *, size_t, size_t, SDL_CompareCallback_r, void *)"
        extern "int SDL_abs(int)"
        extern "int SDL_isalpha(int)"
        extern "int SDL_isalnum(int)"
        extern "int SDL_isblank(int)"
        extern "int SDL_iscntrl(int)"
        extern "int SDL_isdigit(int)"
        extern "int SDL_isxdigit(int)"
        extern "int SDL_ispunct(int)"
        extern "int SDL_isspace(int)"
        extern "int SDL_isupper(int)"
        extern "int SDL_islower(int)"
        extern "int SDL_isprint(int)"
        extern "int SDL_isgraph(int)"
        extern "int SDL_toupper(int)"
        extern "int SDL_tolower(int)"
        extern "Uint16 SDL_crc16(Uint16, void *, size_t)"
        extern "Uint32 SDL_crc32(Uint32, void *, size_t)"
        extern "Uint32 SDL_murmur3_32(void *, size_t, Uint32)"
        extern "void * SDL_memcpy(void *, void *, size_t)"
        extern "void * SDL_memmove(void *, void *, size_t)"
        extern "void * SDL_memset(void *, int, size_t)"
        extern "void * SDL_memset4(void *, Uint32, size_t)"
        extern "int SDL_memcmp(void *, void *, size_t)"
        extern "size_t SDL_wcslen(wchar_t *)"
        extern "size_t SDL_wcsnlen(wchar_t *, size_t)"
        extern "size_t SDL_wcslcpy(wchar_t *, wchar_t *, size_t)"
        extern "size_t SDL_wcslcat(wchar_t *, wchar_t *, size_t)"
        extern "wchar_t * SDL_wcsdup(wchar_t *)"
        extern "wchar_t * SDL_wcsstr(wchar_t *, wchar_t *)"
        extern "wchar_t * SDL_wcsnstr(wchar_t *, wchar_t *, size_t)"
        extern "int SDL_wcscmp(wchar_t *, wchar_t *)"
        extern "int SDL_wcsncmp(wchar_t *, wchar_t *, size_t)"
        extern "int SDL_wcscasecmp(wchar_t *, wchar_t *)"
        extern "int SDL_wcsncasecmp(wchar_t *, wchar_t *, size_t)"
        extern "long SDL_wcstol(wchar_t *, wchar_t **, int)"
        extern "size_t SDL_strlen(char *)"
        extern "size_t SDL_strnlen(char *, size_t)"
        extern "size_t SDL_strlcpy(char *, char *, size_t)"
        extern "size_t SDL_utf8strlcpy(char *, char *, size_t)"
        extern "size_t SDL_strlcat(char *, char *, size_t)"
        extern "char * SDL_strdup(char *)"
        extern "char * SDL_strndup(char *, size_t)"
        extern "char * SDL_strrev(char *)"
        extern "char * SDL_strupr(char *)"
        extern "char * SDL_strlwr(char *)"
        extern "char * SDL_strchr(char *, int)"
        extern "char * SDL_strrchr(char *, int)"
        extern "char * SDL_strstr(char *, char *)"
        extern "char * SDL_strnstr(char *, char *, size_t)"
        extern "char * SDL_strcasestr(char *, char *)"
        extern "char * SDL_strtok_r(char *, char *, char **)"
        extern "size_t SDL_utf8strlen(char *)"
        extern "size_t SDL_utf8strnlen(char *, size_t)"
        extern "char * SDL_itoa(int, char *, int)"
        extern "char * SDL_uitoa(unsigned int, char *, int)"
        extern "char * SDL_ltoa(long, char *, int)"
        extern "char * SDL_ultoa(unsigned long, char *, int)"
        extern "char * SDL_lltoa(long long, char *, int)"
        extern "char * SDL_ulltoa(unsigned long long, char *, int)"
        extern "int SDL_atoi(char *)"
        extern "double SDL_atof(char *)"
        extern "long SDL_strtol(char *, char **, int)"
        extern "unsigned long SDL_strtoul(char *, char **, int)"
        extern "long long SDL_strtoll(char *, char **, int)"
        extern "unsigned long long SDL_strtoull(char *, char **, int)"
        extern "double SDL_strtod(char *, char **)"
        extern "int SDL_strcmp(char *, char *)"
        extern "int SDL_strncmp(char *, char *, size_t)"
        extern "int SDL_strcasecmp(char *, char *)"
        extern "int SDL_strncasecmp(char *, char *, size_t)"
        extern "char * SDL_strpbrk(char *, char *)"
        extern "Uint32 SDL_StepUTF8(char **, size_t *)"
        extern "Uint32 SDL_StepBackUTF8(char *, char **)"
        extern "char * SDL_UCS4ToUTF8(Uint32, char *)"
        extern "int SDL_sscanf(char *, char *, ...)"
        extern "int SDL_snprintf(char *, size_t, char *, ...)"
        extern "int SDL_swprintf(wchar_t *, size_t, wchar_t *, ...)"
        extern "int SDL_asprintf(char **, char *, ...)"
        extern "void SDL_srand(Uint64)"
        extern "Sint32 SDL_rand(Sint32)"
        extern "float SDL_randf(void)"
        extern "Uint32 SDL_rand_bits(void)"
        extern "Sint32 SDL_rand_r(Uint64 *, Sint32)"
        extern "float SDL_randf_r(Uint64 *)"
        extern "Uint32 SDL_rand_bits_r(Uint64 *)"
        extern "double SDL_acos(double)"
        extern "float SDL_acosf(float)"
        extern "double SDL_asin(double)"
        extern "float SDL_asinf(float)"
        extern "double SDL_atan(double)"
        extern "float SDL_atanf(float)"
        extern "double SDL_atan2(double, double)"
        extern "float SDL_atan2f(float, float)"
        extern "double SDL_ceil(double)"
        extern "float SDL_ceilf(float)"
        extern "double SDL_copysign(double, double)"
        extern "float SDL_copysignf(float, float)"
        extern "double SDL_cos(double)"
        extern "float SDL_cosf(float)"
        extern "double SDL_exp(double)"
        extern "float SDL_expf(float)"
        extern "double SDL_fabs(double)"
        extern "float SDL_fabsf(float)"
        extern "double SDL_floor(double)"
        extern "float SDL_floorf(float)"
        extern "double SDL_trunc(double)"
        extern "float SDL_truncf(float)"
        extern "double SDL_fmod(double, double)"
        extern "float SDL_fmodf(float, float)"
        extern "int SDL_isinf(double)"
        extern "int SDL_isinff(float)"
        extern "int SDL_isnan(double)"
        extern "int SDL_isnanf(float)"
        extern "double SDL_log(double)"
        extern "float SDL_logf(float)"
        extern "double SDL_log10(double)"
        extern "float SDL_log10f(float)"
        extern "double SDL_modf(double, double *)"
        extern "float SDL_modff(float, float *)"
        extern "double SDL_pow(double, double)"
        extern "float SDL_powf(float, float)"
        extern "double SDL_round(double)"
        extern "float SDL_roundf(float)"
        extern "long SDL_lround(double)"
        extern "long SDL_lroundf(float)"
        extern "double SDL_scalbn(double, int)"
        extern "float SDL_scalbnf(float, int)"
        extern "double SDL_sin(double)"
        extern "float SDL_sinf(float)"
        extern "double SDL_sqrt(double)"
        extern "float SDL_sqrtf(float)"
        extern "double SDL_tan(double)"
        extern "float SDL_tanf(float)"
        typealias "SDL_iconv_t", "SDL_iconv_data_t *"
        extern "SDL_iconv_t SDL_iconv_open(char *, char *)"
        extern "int SDL_iconv_close(SDL_iconv_t)"
        extern "size_t SDL_iconv(SDL_iconv_t, char **, size_t *, char **, size_t *)"
        extern "char * SDL_iconv_string(char *, char *, char *, size_t)"
        typealias "SDL_FunctionPointer", "function (*pointer)()"
        const_set :SDL_FunctionPointer, "void SDL_FunctionPointer(void)"
        const_set :SDL_ASSERTION_RETRY, 0
        const_set :SDL_ASSERTION_BREAK, 1
        const_set :SDL_ASSERTION_ABORT, 2
        const_set :SDL_ASSERTION_IGNORE, 3
        const_set :SDL_ASSERTION_ALWAYS_IGNORE, 4
        typealias "SDL_AssertState", "enum"
        const_set :SDL_AssertData, struct(
          [
            "bool always_ignore",
            "unsigned int trigger_count",
            "char * condition",
            "char * filename",
            "int linenum",
            "char * function",
            "SDL_AssertData * next",
          ]
        )
        extern "SDL_AssertState SDL_ReportAssertion(SDL_AssertData *, char *, char *, int)"
        typealias "SDL_AssertionHandler", "function (*pointer)()"
        const_set :SDL_AssertionHandler, "SDL_AssertState SDL_AssertionHandler(SDL_AssertData *, void *)"
        extern "void SDL_SetAssertionHandler(SDL_AssertionHandler, void *)"
        extern "SDL_AssertionHandler SDL_GetDefaultAssertionHandler(void)"
        extern "SDL_AssertionHandler SDL_GetAssertionHandler(void **)"
        extern "SDL_AssertData * SDL_GetAssertionReport(void)"
        extern "void SDL_ResetAssertionReport(void)"
        const_set :SDL_ASYNCIO_TASK_READ, 0
        const_set :SDL_ASYNCIO_TASK_WRITE, 1
        const_set :SDL_ASYNCIO_TASK_CLOSE, 2
        typealias "SDL_AsyncIOTaskType", "enum"
        const_set :SDL_ASYNCIO_COMPLETE, 0
        const_set :SDL_ASYNCIO_FAILURE, 1
        const_set :SDL_ASYNCIO_CANCELED, 2
        typealias "SDL_AsyncIOResult", "enum"
        const_set :SDL_AsyncIOOutcome, struct(
          [
            "SDL_AsyncIO * asyncio",
            "SDL_AsyncIOTaskType type",
            "SDL_AsyncIOResult result",
            "void * buffer",
            "Uint64 offset",
            "Uint64 bytes_requested",
            "Uint64 bytes_transferred",
            "void * userdata",
          ]
        )
        extern "SDL_AsyncIO * SDL_AsyncIOFromFile(char *, char *)"
        extern "Sint64 SDL_GetAsyncIOSize(SDL_AsyncIO *)"
        extern "bool SDL_ReadAsyncIO(SDL_AsyncIO *, void *, Uint64, Uint64, SDL_AsyncIOQueue *, void *)"
        extern "bool SDL_WriteAsyncIO(SDL_AsyncIO *, void *, Uint64, Uint64, SDL_AsyncIOQueue *, void *)"
        extern "bool SDL_CloseAsyncIO(SDL_AsyncIO *, bool, SDL_AsyncIOQueue *, void *)"
        extern "SDL_AsyncIOQueue * SDL_CreateAsyncIOQueue(void)"
        extern "void SDL_DestroyAsyncIOQueue(SDL_AsyncIOQueue *)"
        extern "bool SDL_GetAsyncIOResult(SDL_AsyncIOQueue *, SDL_AsyncIOOutcome *)"
        extern "bool SDL_WaitAsyncIOResult(SDL_AsyncIOQueue *, SDL_AsyncIOOutcome *, Sint32)"
        extern "void SDL_SignalAsyncIOQueue(SDL_AsyncIOQueue *)"
        extern "bool SDL_LoadFileAsync(char *, SDL_AsyncIOQueue *, void *)"
        typealias "SDL_SpinLock", "int"
        extern "bool SDL_TryLockSpinlock(SDL_SpinLock *)"
        extern "void SDL_LockSpinlock(SDL_SpinLock *)"
        extern "void SDL_UnlockSpinlock(SDL_SpinLock *)"
        extern "void SDL_MemoryBarrierReleaseFunction(void)"
        extern "void SDL_MemoryBarrierAcquireFunction(void)"
        const_set :SDL_AtomicInt, struct(
          [
            "int value",
          ]
        )
        extern "bool SDL_CompareAndSwapAtomicInt(SDL_AtomicInt *, int, int)"
        extern "int SDL_SetAtomicInt(SDL_AtomicInt *, int)"
        extern "int SDL_GetAtomicInt(SDL_AtomicInt *)"
        extern "int SDL_AddAtomicInt(SDL_AtomicInt *, int)"
        const_set :SDL_AtomicU32, struct(
          [
            "Uint32 value",
          ]
        )
        extern "bool SDL_CompareAndSwapAtomicU32(SDL_AtomicU32 *, Uint32, Uint32)"
        extern "Uint32 SDL_SetAtomicU32(SDL_AtomicU32 *, Uint32)"
        extern "Uint32 SDL_GetAtomicU32(SDL_AtomicU32 *)"
        extern "bool SDL_CompareAndSwapAtomicPointer(void **, void *, void *)"
        extern "void * SDL_SetAtomicPointer(void **, void *)"
        extern "void * SDL_GetAtomicPointer(void **)"
        extern "bool SDL_SetError(char *, ...)"
        extern "bool SDL_OutOfMemory(void)"
        extern "char * SDL_GetError(void)"
        extern "bool SDL_ClearError(void)"
        typealias "SDL_PropertiesID", "Uint32"
        const_set :SDL_PROPERTY_TYPE_INVALID, 0
        const_set :SDL_PROPERTY_TYPE_POINTER, 1
        const_set :SDL_PROPERTY_TYPE_STRING, 2
        const_set :SDL_PROPERTY_TYPE_NUMBER, 3
        const_set :SDL_PROPERTY_TYPE_FLOAT, 4
        const_set :SDL_PROPERTY_TYPE_BOOLEAN, 5
        typealias "SDL_PropertyType", "enum"
        extern "SDL_PropertiesID SDL_GetGlobalProperties(void)"
        extern "SDL_PropertiesID SDL_CreateProperties(void)"
        extern "bool SDL_CopyProperties(SDL_PropertiesID, SDL_PropertiesID)"
        extern "bool SDL_LockProperties(SDL_PropertiesID)"
        extern "void SDL_UnlockProperties(SDL_PropertiesID)"
        typealias "SDL_CleanupPropertyCallback", "function (*pointer)()"
        const_set :SDL_CleanupPropertyCallback, "void SDL_CleanupPropertyCallback(void *, void *)"
        extern "bool SDL_SetPointerPropertyWithCleanup(SDL_PropertiesID, char *, void *, SDL_CleanupPropertyCallback, void *)"
        extern "bool SDL_SetPointerProperty(SDL_PropertiesID, char *, void *)"
        extern "bool SDL_SetStringProperty(SDL_PropertiesID, char *, char *)"
        extern "bool SDL_SetNumberProperty(SDL_PropertiesID, char *, Sint64)"
        extern "bool SDL_SetFloatProperty(SDL_PropertiesID, char *, float)"
        extern "bool SDL_SetBooleanProperty(SDL_PropertiesID, char *, bool)"
        extern "bool SDL_HasProperty(SDL_PropertiesID, char *)"
        extern "SDL_PropertyType SDL_GetPropertyType(SDL_PropertiesID, char *)"
        extern "void * SDL_GetPointerProperty(SDL_PropertiesID, char *, void *)"
        extern "char * SDL_GetStringProperty(SDL_PropertiesID, char *, char *)"
        extern "Sint64 SDL_GetNumberProperty(SDL_PropertiesID, char *, Sint64)"
        extern "float SDL_GetFloatProperty(SDL_PropertiesID, char *, float)"
        extern "bool SDL_GetBooleanProperty(SDL_PropertiesID, char *, bool)"
        extern "bool SDL_ClearProperty(SDL_PropertiesID, char *)"
        typealias "SDL_EnumeratePropertiesCallback", "function (*pointer)()"
        const_set :SDL_EnumeratePropertiesCallback, "void SDL_EnumeratePropertiesCallback(void *, SDL_PropertiesID, char *)"
        extern "bool SDL_EnumerateProperties(SDL_PropertiesID, SDL_EnumeratePropertiesCallback, void *)"
        extern "void SDL_DestroyProperties(SDL_PropertiesID)"
        typealias "SDL_ThreadID", "Uint64"
        typealias "SDL_TLSID", "SDL_AtomicInt"
        const_set :SDL_THREAD_PRIORITY_LOW, 0
        const_set :SDL_THREAD_PRIORITY_NORMAL, 1
        const_set :SDL_THREAD_PRIORITY_HIGH, 2
        const_set :SDL_THREAD_PRIORITY_TIME_CRITICAL, 3
        typealias "SDL_ThreadPriority", "enum"
        const_set :SDL_THREAD_UNKNOWN, 0
        const_set :SDL_THREAD_ALIVE, 1
        const_set :SDL_THREAD_DETACHED, 2
        const_set :SDL_THREAD_COMPLETE, 3
        typealias "SDL_ThreadState", "enum"
        typealias "SDL_ThreadFunction", "function (*pointer)()"
        const_set :SDL_ThreadFunction, "int SDL_ThreadFunction(void *)"
        extern "SDL_Thread * SDL_CreateThreadRuntime(SDL_ThreadFunction, char *, void *, SDL_FunctionPointer, SDL_FunctionPointer)"
        extern "SDL_Thread * SDL_CreateThreadWithPropertiesRuntime(SDL_PropertiesID, SDL_FunctionPointer, SDL_FunctionPointer)"
        extern "char * SDL_GetThreadName(SDL_Thread *)"
        extern "SDL_ThreadID SDL_GetCurrentThreadID(void)"
        extern "SDL_ThreadID SDL_GetThreadID(SDL_Thread *)"
        extern "bool SDL_SetCurrentThreadPriority(SDL_ThreadPriority)"
        extern "void SDL_WaitThread(SDL_Thread *, int *)"
        extern "SDL_ThreadState SDL_GetThreadState(SDL_Thread *)"
        extern "void SDL_DetachThread(SDL_Thread *)"
        extern "void * SDL_GetTLS(SDL_TLSID *)"
        typealias "SDL_TLSDestructorCallback", "function (*pointer)()"
        const_set :SDL_TLSDestructorCallback, "void SDL_TLSDestructorCallback(void *)"
        extern "bool SDL_SetTLS(SDL_TLSID *, void *, SDL_TLSDestructorCallback)"
        extern "void SDL_CleanupTLS(void)"
        extern "SDL_Mutex * SDL_CreateMutex(void)"
        extern "void SDL_LockMutex(SDL_Mutex *)"
        extern "bool SDL_TryLockMutex(SDL_Mutex *)"
        extern "void SDL_UnlockMutex(SDL_Mutex *)"
        extern "void SDL_DestroyMutex(SDL_Mutex *)"
        extern "SDL_RWLock * SDL_CreateRWLock(void)"
        extern "void SDL_LockRWLockForReading(SDL_RWLock *)"
        extern "void SDL_LockRWLockForWriting(SDL_RWLock *)"
        extern "bool SDL_TryLockRWLockForReading(SDL_RWLock *)"
        extern "bool SDL_TryLockRWLockForWriting(SDL_RWLock *)"
        extern "void SDL_UnlockRWLock(SDL_RWLock *)"
        extern "void SDL_DestroyRWLock(SDL_RWLock *)"
        extern "SDL_Semaphore * SDL_CreateSemaphore(Uint32)"
        extern "void SDL_DestroySemaphore(SDL_Semaphore *)"
        extern "void SDL_WaitSemaphore(SDL_Semaphore *)"
        extern "bool SDL_TryWaitSemaphore(SDL_Semaphore *)"
        extern "bool SDL_WaitSemaphoreTimeout(SDL_Semaphore *, Sint32)"
        extern "void SDL_SignalSemaphore(SDL_Semaphore *)"
        extern "Uint32 SDL_GetSemaphoreValue(SDL_Semaphore *)"
        extern "SDL_Condition * SDL_CreateCondition(void)"
        extern "void SDL_DestroyCondition(SDL_Condition *)"
        extern "void SDL_SignalCondition(SDL_Condition *)"
        extern "void SDL_BroadcastCondition(SDL_Condition *)"
        extern "void SDL_WaitCondition(SDL_Condition *, SDL_Mutex *)"
        extern "bool SDL_WaitConditionTimeout(SDL_Condition *, SDL_Mutex *, Sint32)"
        const_set :SDL_INIT_STATUS_UNINITIALIZED, 0
        const_set :SDL_INIT_STATUS_INITIALIZING, 1
        const_set :SDL_INIT_STATUS_INITIALIZED, 2
        const_set :SDL_INIT_STATUS_UNINITIALIZING, 3
        typealias "SDL_InitStatus", "enum"
        const_set :SDL_InitState, struct(
          [
            { "status": SDL_AtomicInt },
            "SDL_ThreadID thread",
            "void * reserved",
          ]
        )
        extern "bool SDL_ShouldInit(SDL_InitState *)"
        extern "bool SDL_ShouldQuit(SDL_InitState *)"
        extern "void SDL_SetInitialized(SDL_InitState *, bool)"
        const_set :SDL_IO_STATUS_READY, 0
        const_set :SDL_IO_STATUS_ERROR, 1
        const_set :SDL_IO_STATUS_EOF, 2
        const_set :SDL_IO_STATUS_NOT_READY, 3
        const_set :SDL_IO_STATUS_READONLY, 4
        const_set :SDL_IO_STATUS_WRITEONLY, 5
        typealias "SDL_IOStatus", "enum"
        const_set :SDL_IO_SEEK_SET, 0
        const_set :SDL_IO_SEEK_CUR, 1
        const_set :SDL_IO_SEEK_END, 2
        typealias "SDL_IOWhence", "enum"
        const_set :SDL_IOStreamInterface, struct(
          [
            "Uint32 version",
            "function (*size)()",
            "function (*seek)()",
            "function (*read)()",
            "function (*write)()",
            "function (*flush)()",
            "function (*close)()",
          ]
        )
        extern "SDL_IOStream * SDL_IOFromFile(char *, char *)"
        extern "SDL_IOStream * SDL_IOFromMem(void *, size_t)"
        extern "SDL_IOStream * SDL_IOFromConstMem(void *, size_t)"
        extern "SDL_IOStream * SDL_IOFromDynamicMem(void)"
        extern "SDL_IOStream * SDL_OpenIO(SDL_IOStreamInterface *, void *)"
        extern "bool SDL_CloseIO(SDL_IOStream *)"
        extern "SDL_PropertiesID SDL_GetIOProperties(SDL_IOStream *)"
        extern "SDL_IOStatus SDL_GetIOStatus(SDL_IOStream *)"
        extern "Sint64 SDL_GetIOSize(SDL_IOStream *)"
        extern "Sint64 SDL_SeekIO(SDL_IOStream *, Sint64, SDL_IOWhence)"
        extern "Sint64 SDL_TellIO(SDL_IOStream *)"
        extern "size_t SDL_ReadIO(SDL_IOStream *, void *, size_t)"
        extern "size_t SDL_WriteIO(SDL_IOStream *, void *, size_t)"
        extern "size_t SDL_IOprintf(SDL_IOStream *, char *, ...)"
        extern "bool SDL_FlushIO(SDL_IOStream *)"
        extern "void * SDL_LoadFile_IO(SDL_IOStream *, size_t *, bool)"
        extern "void * SDL_LoadFile(char *, size_t *)"
        extern "bool SDL_SaveFile_IO(SDL_IOStream *, void *, size_t, bool)"
        extern "bool SDL_SaveFile(char *, void *, size_t)"
        extern "bool SDL_ReadU8(SDL_IOStream *, Uint8 *)"
        extern "bool SDL_ReadS8(SDL_IOStream *, Sint8 *)"
        extern "bool SDL_ReadU16LE(SDL_IOStream *, Uint16 *)"
        extern "bool SDL_ReadS16LE(SDL_IOStream *, Sint16 *)"
        extern "bool SDL_ReadU16BE(SDL_IOStream *, Uint16 *)"
        extern "bool SDL_ReadS16BE(SDL_IOStream *, Sint16 *)"
        extern "bool SDL_ReadU32LE(SDL_IOStream *, Uint32 *)"
        extern "bool SDL_ReadS32LE(SDL_IOStream *, Sint32 *)"
        extern "bool SDL_ReadU32BE(SDL_IOStream *, Uint32 *)"
        extern "bool SDL_ReadS32BE(SDL_IOStream *, Sint32 *)"
        extern "bool SDL_ReadU64LE(SDL_IOStream *, Uint64 *)"
        extern "bool SDL_ReadS64LE(SDL_IOStream *, Sint64 *)"
        extern "bool SDL_ReadU64BE(SDL_IOStream *, Uint64 *)"
        extern "bool SDL_ReadS64BE(SDL_IOStream *, Sint64 *)"
        extern "bool SDL_WriteU8(SDL_IOStream *, Uint8)"
        extern "bool SDL_WriteS8(SDL_IOStream *, Sint8)"
        extern "bool SDL_WriteU16LE(SDL_IOStream *, Uint16)"
        extern "bool SDL_WriteS16LE(SDL_IOStream *, Sint16)"
        extern "bool SDL_WriteU16BE(SDL_IOStream *, Uint16)"
        extern "bool SDL_WriteS16BE(SDL_IOStream *, Sint16)"
        extern "bool SDL_WriteU32LE(SDL_IOStream *, Uint32)"
        extern "bool SDL_WriteS32LE(SDL_IOStream *, Sint32)"
        extern "bool SDL_WriteU32BE(SDL_IOStream *, Uint32)"
        extern "bool SDL_WriteS32BE(SDL_IOStream *, Sint32)"
        extern "bool SDL_WriteU64LE(SDL_IOStream *, Uint64)"
        extern "bool SDL_WriteS64LE(SDL_IOStream *, Sint64)"
        extern "bool SDL_WriteU64BE(SDL_IOStream *, Uint64)"
        extern "bool SDL_WriteS64BE(SDL_IOStream *, Sint64)"
        const_set :SDL_AUDIO_UNKNOWN, 0
        const_set :SDL_AUDIO_U8, 8
        const_set :SDL_AUDIO_S8, 32776
        const_set :SDL_AUDIO_S16LE, 32784
        const_set :SDL_AUDIO_S16BE, 36880
        const_set :SDL_AUDIO_S32LE, 32800
        const_set :SDL_AUDIO_S32BE, 36896
        const_set :SDL_AUDIO_F32LE, 33056
        const_set :SDL_AUDIO_F32BE, 37152
        const_set :SDL_AUDIO_S16, 32784
        const_set :SDL_AUDIO_S32, 32800
        const_set :SDL_AUDIO_F32, 33056
        typealias "SDL_AudioFormat", "enum"
        typealias "SDL_AudioDeviceID", "Uint32"
        const_set :SDL_AudioSpec, struct(
          [
            "SDL_AudioFormat format",
            "int channels",
            "int freq",
          ]
        )
        extern "int SDL_GetNumAudioDrivers(void)"
        extern "char * SDL_GetAudioDriver(int)"
        extern "char * SDL_GetCurrentAudioDriver(void)"
        extern "SDL_AudioDeviceID * SDL_GetAudioPlaybackDevices(int *)"
        extern "SDL_AudioDeviceID * SDL_GetAudioRecordingDevices(int *)"
        extern "char * SDL_GetAudioDeviceName(SDL_AudioDeviceID)"
        extern "bool SDL_GetAudioDeviceFormat(SDL_AudioDeviceID, SDL_AudioSpec *, int *)"
        extern "int * SDL_GetAudioDeviceChannelMap(SDL_AudioDeviceID, int *)"
        extern "SDL_AudioDeviceID SDL_OpenAudioDevice(SDL_AudioDeviceID, SDL_AudioSpec *)"
        extern "bool SDL_IsAudioDevicePhysical(SDL_AudioDeviceID)"
        extern "bool SDL_IsAudioDevicePlayback(SDL_AudioDeviceID)"
        extern "bool SDL_PauseAudioDevice(SDL_AudioDeviceID)"
        extern "bool SDL_ResumeAudioDevice(SDL_AudioDeviceID)"
        extern "bool SDL_AudioDevicePaused(SDL_AudioDeviceID)"
        extern "float SDL_GetAudioDeviceGain(SDL_AudioDeviceID)"
        extern "bool SDL_SetAudioDeviceGain(SDL_AudioDeviceID, float)"
        extern "void SDL_CloseAudioDevice(SDL_AudioDeviceID)"
        extern "bool SDL_BindAudioStreams(SDL_AudioDeviceID, SDL_AudioStream **, int)"
        extern "bool SDL_BindAudioStream(SDL_AudioDeviceID, SDL_AudioStream *)"
        extern "void SDL_UnbindAudioStreams(SDL_AudioStream **, int)"
        extern "void SDL_UnbindAudioStream(SDL_AudioStream *)"
        extern "SDL_AudioDeviceID SDL_GetAudioStreamDevice(SDL_AudioStream *)"
        extern "SDL_AudioStream * SDL_CreateAudioStream(SDL_AudioSpec *, SDL_AudioSpec *)"
        extern "SDL_PropertiesID SDL_GetAudioStreamProperties(SDL_AudioStream *)"
        extern "bool SDL_GetAudioStreamFormat(SDL_AudioStream *, SDL_AudioSpec *, SDL_AudioSpec *)"
        extern "bool SDL_SetAudioStreamFormat(SDL_AudioStream *, SDL_AudioSpec *, SDL_AudioSpec *)"
        extern "float SDL_GetAudioStreamFrequencyRatio(SDL_AudioStream *)"
        extern "bool SDL_SetAudioStreamFrequencyRatio(SDL_AudioStream *, float)"
        extern "float SDL_GetAudioStreamGain(SDL_AudioStream *)"
        extern "bool SDL_SetAudioStreamGain(SDL_AudioStream *, float)"
        extern "int * SDL_GetAudioStreamInputChannelMap(SDL_AudioStream *, int *)"
        extern "int * SDL_GetAudioStreamOutputChannelMap(SDL_AudioStream *, int *)"
        extern "bool SDL_SetAudioStreamInputChannelMap(SDL_AudioStream *, int *, int)"
        extern "bool SDL_SetAudioStreamOutputChannelMap(SDL_AudioStream *, int *, int)"
        extern "bool SDL_PutAudioStreamData(SDL_AudioStream *, void *, int)"
        extern "int SDL_GetAudioStreamData(SDL_AudioStream *, void *, int)"
        extern "int SDL_GetAudioStreamAvailable(SDL_AudioStream *)"
        extern "int SDL_GetAudioStreamQueued(SDL_AudioStream *)"
        extern "bool SDL_FlushAudioStream(SDL_AudioStream *)"
        extern "bool SDL_ClearAudioStream(SDL_AudioStream *)"
        extern "bool SDL_PauseAudioStreamDevice(SDL_AudioStream *)"
        extern "bool SDL_ResumeAudioStreamDevice(SDL_AudioStream *)"
        extern "bool SDL_AudioStreamDevicePaused(SDL_AudioStream *)"
        extern "bool SDL_LockAudioStream(SDL_AudioStream *)"
        extern "bool SDL_UnlockAudioStream(SDL_AudioStream *)"
        typealias "SDL_AudioStreamCallback", "function (*pointer)()"
        const_set :SDL_AudioStreamCallback, "void SDL_AudioStreamCallback(void *, SDL_AudioStream *, int, int)"
        extern "bool SDL_SetAudioStreamGetCallback(SDL_AudioStream *, SDL_AudioStreamCallback, void *)"
        extern "bool SDL_SetAudioStreamPutCallback(SDL_AudioStream *, SDL_AudioStreamCallback, void *)"
        extern "void SDL_DestroyAudioStream(SDL_AudioStream *)"
        extern "SDL_AudioStream * SDL_OpenAudioDeviceStream(SDL_AudioDeviceID, SDL_AudioSpec *, SDL_AudioStreamCallback, void *)"
        typealias "SDL_AudioPostmixCallback", "function (*pointer)()"
        const_set :SDL_AudioPostmixCallback, "void SDL_AudioPostmixCallback(void *, SDL_AudioSpec *, float *, int)"
        extern "bool SDL_SetAudioPostmixCallback(SDL_AudioDeviceID, SDL_AudioPostmixCallback, void *)"
        extern "bool SDL_LoadWAV_IO(SDL_IOStream *, bool, SDL_AudioSpec *, Uint8 **, Uint32 *)"
        extern "bool SDL_LoadWAV(char *, SDL_AudioSpec *, Uint8 **, Uint32 *)"
        extern "bool SDL_MixAudio(Uint8 *, Uint8 *, SDL_AudioFormat, Uint32, float)"
        extern "bool SDL_ConvertAudioSamples(SDL_AudioSpec *, Uint8 *, int, SDL_AudioSpec *, Uint8 **, int *)"
        extern "char * SDL_GetAudioFormatName(SDL_AudioFormat)"
        extern "int SDL_GetSilenceValueForFormat(SDL_AudioFormat)"
        typealias "SDL_BlendMode", "Uint32"
        const_set :SDL_BLENDOPERATION_ADD, 1
        const_set :SDL_BLENDOPERATION_SUBTRACT, 2
        const_set :SDL_BLENDOPERATION_REV_SUBTRACT, 3
        const_set :SDL_BLENDOPERATION_MINIMUM, 4
        const_set :SDL_BLENDOPERATION_MAXIMUM, 5
        typealias "SDL_BlendOperation", "enum"
        const_set :SDL_BLENDFACTOR_ZERO, 1
        const_set :SDL_BLENDFACTOR_ONE, 2
        const_set :SDL_BLENDFACTOR_SRC_COLOR, 3
        const_set :SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR, 4
        const_set :SDL_BLENDFACTOR_SRC_ALPHA, 5
        const_set :SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA, 6
        const_set :SDL_BLENDFACTOR_DST_COLOR, 7
        const_set :SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR, 8
        const_set :SDL_BLENDFACTOR_DST_ALPHA, 9
        const_set :SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA, 10
        typealias "SDL_BlendFactor", "enum"
        extern "SDL_BlendMode SDL_ComposeCustomBlendMode(SDL_BlendFactor, SDL_BlendFactor, SDL_BlendOperation, SDL_BlendFactor, SDL_BlendFactor, SDL_BlendOperation)"
        const_set :SDL_PIXELTYPE_UNKNOWN, 0
        const_set :SDL_PIXELTYPE_INDEX1, 1
        const_set :SDL_PIXELTYPE_INDEX4, 2
        const_set :SDL_PIXELTYPE_INDEX8, 3
        const_set :SDL_PIXELTYPE_PACKED8, 4
        const_set :SDL_PIXELTYPE_PACKED16, 5
        const_set :SDL_PIXELTYPE_PACKED32, 6
        const_set :SDL_PIXELTYPE_ARRAYU8, 7
        const_set :SDL_PIXELTYPE_ARRAYU16, 8
        const_set :SDL_PIXELTYPE_ARRAYU32, 9
        const_set :SDL_PIXELTYPE_ARRAYF16, 10
        const_set :SDL_PIXELTYPE_ARRAYF32, 11
        const_set :SDL_PIXELTYPE_INDEX2, 12
        typealias "SDL_PixelType", "enum"
        const_set :SDL_BITMAPORDER_NONE, 0
        const_set :SDL_BITMAPORDER_4321, 1
        const_set :SDL_BITMAPORDER_1234, 2
        typealias "SDL_BitmapOrder", "enum"
        const_set :SDL_PACKEDORDER_NONE, 0
        const_set :SDL_PACKEDORDER_XRGB, 1
        const_set :SDL_PACKEDORDER_RGBX, 2
        const_set :SDL_PACKEDORDER_ARGB, 3
        const_set :SDL_PACKEDORDER_RGBA, 4
        const_set :SDL_PACKEDORDER_XBGR, 5
        const_set :SDL_PACKEDORDER_BGRX, 6
        const_set :SDL_PACKEDORDER_ABGR, 7
        const_set :SDL_PACKEDORDER_BGRA, 8
        typealias "SDL_PackedOrder", "enum"
        const_set :SDL_ARRAYORDER_NONE, 0
        const_set :SDL_ARRAYORDER_RGB, 1
        const_set :SDL_ARRAYORDER_RGBA, 2
        const_set :SDL_ARRAYORDER_ARGB, 3
        const_set :SDL_ARRAYORDER_BGR, 4
        const_set :SDL_ARRAYORDER_BGRA, 5
        const_set :SDL_ARRAYORDER_ABGR, 6
        typealias "SDL_ArrayOrder", "enum"
        const_set :SDL_PACKEDLAYOUT_NONE, 0
        const_set :SDL_PACKEDLAYOUT_332, 1
        const_set :SDL_PACKEDLAYOUT_4444, 2
        const_set :SDL_PACKEDLAYOUT_1555, 3
        const_set :SDL_PACKEDLAYOUT_5551, 4
        const_set :SDL_PACKEDLAYOUT_565, 5
        const_set :SDL_PACKEDLAYOUT_8888, 6
        const_set :SDL_PACKEDLAYOUT_2101010, 7
        const_set :SDL_PACKEDLAYOUT_1010102, 8
        typealias "SDL_PackedLayout", "enum"
        const_set :SDL_PIXELFORMAT_UNKNOWN, 0
        const_set :SDL_PIXELFORMAT_INDEX1LSB, 286261504
        const_set :SDL_PIXELFORMAT_INDEX1MSB, 287310080
        const_set :SDL_PIXELFORMAT_INDEX2LSB, 470811136
        const_set :SDL_PIXELFORMAT_INDEX2MSB, 471859712
        const_set :SDL_PIXELFORMAT_INDEX4LSB, 303039488
        const_set :SDL_PIXELFORMAT_INDEX4MSB, 304088064
        const_set :SDL_PIXELFORMAT_INDEX8, 318769153
        const_set :SDL_PIXELFORMAT_RGB332, 336660481
        const_set :SDL_PIXELFORMAT_XRGB4444, 353504258
        const_set :SDL_PIXELFORMAT_XBGR4444, 357698562
        const_set :SDL_PIXELFORMAT_XRGB1555, 353570562
        const_set :SDL_PIXELFORMAT_XBGR1555, 357764866
        const_set :SDL_PIXELFORMAT_ARGB4444, 355602434
        const_set :SDL_PIXELFORMAT_RGBA4444, 356651010
        const_set :SDL_PIXELFORMAT_ABGR4444, 359796738
        const_set :SDL_PIXELFORMAT_BGRA4444, 360845314
        const_set :SDL_PIXELFORMAT_ARGB1555, 355667970
        const_set :SDL_PIXELFORMAT_RGBA5551, 356782082
        const_set :SDL_PIXELFORMAT_ABGR1555, 359862274
        const_set :SDL_PIXELFORMAT_BGRA5551, 360976386
        const_set :SDL_PIXELFORMAT_RGB565, 353701890
        const_set :SDL_PIXELFORMAT_BGR565, 357896194
        const_set :SDL_PIXELFORMAT_RGB24, 386930691
        const_set :SDL_PIXELFORMAT_BGR24, 390076419
        const_set :SDL_PIXELFORMAT_XRGB8888, 370546692
        const_set :SDL_PIXELFORMAT_RGBX8888, 371595268
        const_set :SDL_PIXELFORMAT_XBGR8888, 374740996
        const_set :SDL_PIXELFORMAT_BGRX8888, 375789572
        const_set :SDL_PIXELFORMAT_ARGB8888, 372645892
        const_set :SDL_PIXELFORMAT_RGBA8888, 373694468
        const_set :SDL_PIXELFORMAT_ABGR8888, 376840196
        const_set :SDL_PIXELFORMAT_BGRA8888, 377888772
        const_set :SDL_PIXELFORMAT_XRGB2101010, 370614276
        const_set :SDL_PIXELFORMAT_XBGR2101010, 374808580
        const_set :SDL_PIXELFORMAT_ARGB2101010, 372711428
        const_set :SDL_PIXELFORMAT_ABGR2101010, 376905732
        const_set :SDL_PIXELFORMAT_RGB48, 403714054
        const_set :SDL_PIXELFORMAT_BGR48, 406859782
        const_set :SDL_PIXELFORMAT_RGBA64, 404766728
        const_set :SDL_PIXELFORMAT_ARGB64, 405815304
        const_set :SDL_PIXELFORMAT_BGRA64, 407912456
        const_set :SDL_PIXELFORMAT_ABGR64, 408961032
        const_set :SDL_PIXELFORMAT_RGB48_FLOAT, 437268486
        const_set :SDL_PIXELFORMAT_BGR48_FLOAT, 440414214
        const_set :SDL_PIXELFORMAT_RGBA64_FLOAT, 438321160
        const_set :SDL_PIXELFORMAT_ARGB64_FLOAT, 439369736
        const_set :SDL_PIXELFORMAT_BGRA64_FLOAT, 441466888
        const_set :SDL_PIXELFORMAT_ABGR64_FLOAT, 442515464
        const_set :SDL_PIXELFORMAT_RGB96_FLOAT, 454057996
        const_set :SDL_PIXELFORMAT_BGR96_FLOAT, 457203724
        const_set :SDL_PIXELFORMAT_RGBA128_FLOAT, 455114768
        const_set :SDL_PIXELFORMAT_ARGB128_FLOAT, 456163344
        const_set :SDL_PIXELFORMAT_BGRA128_FLOAT, 458260496
        const_set :SDL_PIXELFORMAT_ABGR128_FLOAT, 459309072
        const_set :SDL_PIXELFORMAT_YV12, 842094169
        const_set :SDL_PIXELFORMAT_IYUV, 1448433993
        const_set :SDL_PIXELFORMAT_YUY2, 844715353
        const_set :SDL_PIXELFORMAT_UYVY, 1498831189
        const_set :SDL_PIXELFORMAT_YVYU, 1431918169
        const_set :SDL_PIXELFORMAT_NV12, 842094158
        const_set :SDL_PIXELFORMAT_NV21, 825382478
        const_set :SDL_PIXELFORMAT_P010, 808530000
        const_set :SDL_PIXELFORMAT_EXTERNAL_OES, 542328143
        const_set :SDL_PIXELFORMAT_MJPG, 1196444237
        const_set :SDL_PIXELFORMAT_RGBA32, 376840196
        const_set :SDL_PIXELFORMAT_ARGB32, 377888772
        const_set :SDL_PIXELFORMAT_BGRA32, 372645892
        const_set :SDL_PIXELFORMAT_ABGR32, 373694468
        const_set :SDL_PIXELFORMAT_RGBX32, 374740996
        const_set :SDL_PIXELFORMAT_XRGB32, 375789572
        const_set :SDL_PIXELFORMAT_BGRX32, 370546692
        const_set :SDL_PIXELFORMAT_XBGR32, 371595268
        typealias "SDL_PixelFormat", "enum"
        const_set :SDL_COLOR_TYPE_UNKNOWN, 0
        const_set :SDL_COLOR_TYPE_RGB, 1
        const_set :SDL_COLOR_TYPE_YCBCR, 2
        typealias "SDL_ColorType", "enum"
        const_set :SDL_COLOR_RANGE_UNKNOWN, 0
        const_set :SDL_COLOR_RANGE_LIMITED, 1
        const_set :SDL_COLOR_RANGE_FULL, 2
        typealias "SDL_ColorRange", "enum"
        const_set :SDL_COLOR_PRIMARIES_UNKNOWN, 0
        const_set :SDL_COLOR_PRIMARIES_BT709, 1
        const_set :SDL_COLOR_PRIMARIES_UNSPECIFIED, 2
        const_set :SDL_COLOR_PRIMARIES_BT470M, 4
        const_set :SDL_COLOR_PRIMARIES_BT470BG, 5
        const_set :SDL_COLOR_PRIMARIES_BT601, 6
        const_set :SDL_COLOR_PRIMARIES_SMPTE240, 7
        const_set :SDL_COLOR_PRIMARIES_GENERIC_FILM, 8
        const_set :SDL_COLOR_PRIMARIES_BT2020, 9
        const_set :SDL_COLOR_PRIMARIES_XYZ, 10
        const_set :SDL_COLOR_PRIMARIES_SMPTE431, 11
        const_set :SDL_COLOR_PRIMARIES_SMPTE432, 12
        const_set :SDL_COLOR_PRIMARIES_EBU3213, 22
        const_set :SDL_COLOR_PRIMARIES_CUSTOM, 31
        typealias "SDL_ColorPrimaries", "enum"
        const_set :SDL_TRANSFER_CHARACTERISTICS_UNKNOWN, 0
        const_set :SDL_TRANSFER_CHARACTERISTICS_BT709, 1
        const_set :SDL_TRANSFER_CHARACTERISTICS_UNSPECIFIED, 2
        const_set :SDL_TRANSFER_CHARACTERISTICS_GAMMA22, 4
        const_set :SDL_TRANSFER_CHARACTERISTICS_GAMMA28, 5
        const_set :SDL_TRANSFER_CHARACTERISTICS_BT601, 6
        const_set :SDL_TRANSFER_CHARACTERISTICS_SMPTE240, 7
        const_set :SDL_TRANSFER_CHARACTERISTICS_LINEAR, 8
        const_set :SDL_TRANSFER_CHARACTERISTICS_LOG100, 9
        const_set :SDL_TRANSFER_CHARACTERISTICS_LOG100_SQRT10, 10
        const_set :SDL_TRANSFER_CHARACTERISTICS_IEC61966, 11
        const_set :SDL_TRANSFER_CHARACTERISTICS_BT1361, 12
        const_set :SDL_TRANSFER_CHARACTERISTICS_SRGB, 13
        const_set :SDL_TRANSFER_CHARACTERISTICS_BT2020_10BIT, 14
        const_set :SDL_TRANSFER_CHARACTERISTICS_BT2020_12BIT, 15
        const_set :SDL_TRANSFER_CHARACTERISTICS_PQ, 16
        const_set :SDL_TRANSFER_CHARACTERISTICS_SMPTE428, 17
        const_set :SDL_TRANSFER_CHARACTERISTICS_HLG, 18
        const_set :SDL_TRANSFER_CHARACTERISTICS_CUSTOM, 31
        typealias "SDL_TransferCharacteristics", "enum"
        const_set :SDL_MATRIX_COEFFICIENTS_IDENTITY, 0
        const_set :SDL_MATRIX_COEFFICIENTS_BT709, 1
        const_set :SDL_MATRIX_COEFFICIENTS_UNSPECIFIED, 2
        const_set :SDL_MATRIX_COEFFICIENTS_FCC, 4
        const_set :SDL_MATRIX_COEFFICIENTS_BT470BG, 5
        const_set :SDL_MATRIX_COEFFICIENTS_BT601, 6
        const_set :SDL_MATRIX_COEFFICIENTS_SMPTE240, 7
        const_set :SDL_MATRIX_COEFFICIENTS_YCGCO, 8
        const_set :SDL_MATRIX_COEFFICIENTS_BT2020_NCL, 9
        const_set :SDL_MATRIX_COEFFICIENTS_BT2020_CL, 10
        const_set :SDL_MATRIX_COEFFICIENTS_SMPTE2085, 11
        const_set :SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_NCL, 12
        const_set :SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_CL, 13
        const_set :SDL_MATRIX_COEFFICIENTS_ICTCP, 14
        const_set :SDL_MATRIX_COEFFICIENTS_CUSTOM, 31
        typealias "SDL_MatrixCoefficients", "enum"
        const_set :SDL_CHROMA_LOCATION_NONE, 0
        const_set :SDL_CHROMA_LOCATION_LEFT, 1
        const_set :SDL_CHROMA_LOCATION_CENTER, 2
        const_set :SDL_CHROMA_LOCATION_TOPLEFT, 3
        typealias "SDL_ChromaLocation", "enum"
        const_set :SDL_COLORSPACE_UNKNOWN, 0
        const_set :SDL_COLORSPACE_SRGB, 301991328
        const_set :SDL_COLORSPACE_SRGB_LINEAR, 301991168
        const_set :SDL_COLORSPACE_HDR10, 301999616
        const_set :SDL_COLORSPACE_JPEG, 570426566
        const_set :SDL_COLORSPACE_BT601_LIMITED, 554703046
        const_set :SDL_COLORSPACE_BT601_FULL, 571480262
        const_set :SDL_COLORSPACE_BT709_LIMITED, 554697761
        const_set :SDL_COLORSPACE_BT709_FULL, 571474977
        const_set :SDL_COLORSPACE_BT2020_LIMITED, 554706441
        const_set :SDL_COLORSPACE_BT2020_FULL, 571483657
        const_set :SDL_COLORSPACE_RGB_DEFAULT, 301991328
        const_set :SDL_COLORSPACE_YUV_DEFAULT, 570426566
        typealias "SDL_Colorspace", "enum"
        const_set :SDL_Color, struct(
          [
            "Uint8 r",
            "Uint8 g",
            "Uint8 b",
            "Uint8 a",
          ]
        )
        const_set :SDL_FColor, struct(
          [
            "float r",
            "float g",
            "float b",
            "float a",
          ]
        )
        const_set :SDL_Palette, struct(
          [
            "int ncolors",
            "SDL_Color * colors",
            "Uint32 version",
            "int refcount",
          ]
        )
        const_set :SDL_PixelFormatDetails, struct(
          [
            "SDL_PixelFormat format",
            "Uint8 bits_per_pixel",
            "Uint8 bytes_per_pixel",
            "Uint8 padding[2]",
            "Uint32 Rmask",
            "Uint32 Gmask",
            "Uint32 Bmask",
            "Uint32 Amask",
            "Uint8 Rbits",
            "Uint8 Gbits",
            "Uint8 Bbits",
            "Uint8 Abits",
            "Uint8 Rshift",
            "Uint8 Gshift",
            "Uint8 Bshift",
            "Uint8 Ashift",
          ]
        )
        extern "char * SDL_GetPixelFormatName(SDL_PixelFormat)"
        extern "bool SDL_GetMasksForPixelFormat(SDL_PixelFormat, int *, Uint32 *, Uint32 *, Uint32 *, Uint32 *)"
        extern "SDL_PixelFormat SDL_GetPixelFormatForMasks(int, Uint32, Uint32, Uint32, Uint32)"
        extern "SDL_PixelFormatDetails * SDL_GetPixelFormatDetails(SDL_PixelFormat)"
        extern "SDL_Palette * SDL_CreatePalette(int)"
        extern "bool SDL_SetPaletteColors(SDL_Palette *, SDL_Color *, int, int)"
        extern "void SDL_DestroyPalette(SDL_Palette *)"
        extern "Uint32 SDL_MapRGB(SDL_PixelFormatDetails *, SDL_Palette *, Uint8, Uint8, Uint8)"
        extern "Uint32 SDL_MapRGBA(SDL_PixelFormatDetails *, SDL_Palette *, Uint8, Uint8, Uint8, Uint8)"
        extern "void SDL_GetRGB(Uint32, SDL_PixelFormatDetails *, SDL_Palette *, Uint8 *, Uint8 *, Uint8 *)"
        extern "void SDL_GetRGBA(Uint32, SDL_PixelFormatDetails *, SDL_Palette *, Uint8 *, Uint8 *, Uint8 *, Uint8 *)"
        const_set :SDL_Point, struct(
          [
            "int x",
            "int y",
          ]
        )
        const_set :SDL_FPoint, struct(
          [
            "float x",
            "float y",
          ]
        )
        const_set :SDL_Rect, struct(
          [
            "int x",
            "int y",
            "int w",
            "int h",
          ]
        )
        const_set :SDL_FRect, struct(
          [
            "float x",
            "float y",
            "float w",
            "float h",
          ]
        )
        extern "bool SDL_HasRectIntersection(SDL_Rect *, SDL_Rect *)"
        extern "bool SDL_GetRectIntersection(SDL_Rect *, SDL_Rect *, SDL_Rect *)"
        extern "bool SDL_GetRectUnion(SDL_Rect *, SDL_Rect *, SDL_Rect *)"
        extern "bool SDL_GetRectEnclosingPoints(SDL_Point *, int, SDL_Rect *, SDL_Rect *)"
        extern "bool SDL_GetRectAndLineIntersection(SDL_Rect *, int *, int *, int *, int *)"
        extern "bool SDL_HasRectIntersectionFloat(SDL_FRect *, SDL_FRect *)"
        extern "bool SDL_GetRectIntersectionFloat(SDL_FRect *, SDL_FRect *, SDL_FRect *)"
        extern "bool SDL_GetRectUnionFloat(SDL_FRect *, SDL_FRect *, SDL_FRect *)"
        extern "bool SDL_GetRectEnclosingPointsFloat(SDL_FPoint *, int, SDL_FRect *, SDL_FRect *)"
        extern "bool SDL_GetRectAndLineIntersectionFloat(SDL_FRect *, float *, float *, float *, float *)"
        typealias "SDL_SurfaceFlags", "Uint32"
        const_set :SDL_SCALEMODE_INVALID, 4294967295
        const_set :SDL_SCALEMODE_NEAREST, 0
        const_set :SDL_SCALEMODE_LINEAR, 1
        typealias "SDL_ScaleMode", "enum"
        const_set :SDL_FLIP_NONE, 0
        const_set :SDL_FLIP_HORIZONTAL, 1
        const_set :SDL_FLIP_VERTICAL, 2
        typealias "SDL_FlipMode", "enum"
        const_set :SDL_Surface, struct(
          [
            "SDL_SurfaceFlags flags",
            "SDL_PixelFormat format",
            "int w",
            "int h",
            "int pitch",
            "void * pixels",
            "int refcount",
            "void * reserved",
          ]
        )
        extern "SDL_Surface * SDL_CreateSurface(int, int, SDL_PixelFormat)"
        extern "SDL_Surface * SDL_CreateSurfaceFrom(int, int, SDL_PixelFormat, void *, int)"
        extern "void SDL_DestroySurface(SDL_Surface *)"
        extern "SDL_PropertiesID SDL_GetSurfaceProperties(SDL_Surface *)"
        extern "bool SDL_SetSurfaceColorspace(SDL_Surface *, SDL_Colorspace)"
        extern "SDL_Colorspace SDL_GetSurfaceColorspace(SDL_Surface *)"
        extern "SDL_Palette * SDL_CreateSurfacePalette(SDL_Surface *)"
        extern "bool SDL_SetSurfacePalette(SDL_Surface *, SDL_Palette *)"
        extern "SDL_Palette * SDL_GetSurfacePalette(SDL_Surface *)"
        extern "bool SDL_AddSurfaceAlternateImage(SDL_Surface *, SDL_Surface *)"
        extern "bool SDL_SurfaceHasAlternateImages(SDL_Surface *)"
        extern "SDL_Surface ** SDL_GetSurfaceImages(SDL_Surface *, int *)"
        extern "void SDL_RemoveSurfaceAlternateImages(SDL_Surface *)"
        extern "bool SDL_LockSurface(SDL_Surface *)"
        extern "void SDL_UnlockSurface(SDL_Surface *)"
        extern "SDL_Surface * SDL_LoadBMP_IO(SDL_IOStream *, bool)"
        extern "SDL_Surface * SDL_LoadBMP(char *)"
        extern "bool SDL_SaveBMP_IO(SDL_Surface *, SDL_IOStream *, bool)"
        extern "bool SDL_SaveBMP(SDL_Surface *, char *)"
        extern "bool SDL_SetSurfaceRLE(SDL_Surface *, bool)"
        extern "bool SDL_SurfaceHasRLE(SDL_Surface *)"
        extern "bool SDL_SetSurfaceColorKey(SDL_Surface *, bool, Uint32)"
        extern "bool SDL_SurfaceHasColorKey(SDL_Surface *)"
        extern "bool SDL_GetSurfaceColorKey(SDL_Surface *, Uint32 *)"
        extern "bool SDL_SetSurfaceColorMod(SDL_Surface *, Uint8, Uint8, Uint8)"
        extern "bool SDL_GetSurfaceColorMod(SDL_Surface *, Uint8 *, Uint8 *, Uint8 *)"
        extern "bool SDL_SetSurfaceAlphaMod(SDL_Surface *, Uint8)"
        extern "bool SDL_GetSurfaceAlphaMod(SDL_Surface *, Uint8 *)"
        extern "bool SDL_SetSurfaceBlendMode(SDL_Surface *, SDL_BlendMode)"
        extern "bool SDL_GetSurfaceBlendMode(SDL_Surface *, SDL_BlendMode *)"
        extern "bool SDL_SetSurfaceClipRect(SDL_Surface *, SDL_Rect *)"
        extern "bool SDL_GetSurfaceClipRect(SDL_Surface *, SDL_Rect *)"
        extern "bool SDL_FlipSurface(SDL_Surface *, SDL_FlipMode)"
        extern "SDL_Surface * SDL_DuplicateSurface(SDL_Surface *)"
        extern "SDL_Surface * SDL_ScaleSurface(SDL_Surface *, int, int, SDL_ScaleMode)"
        extern "SDL_Surface * SDL_ConvertSurface(SDL_Surface *, SDL_PixelFormat)"
        extern "SDL_Surface * SDL_ConvertSurfaceAndColorspace(SDL_Surface *, SDL_PixelFormat, SDL_Palette *, SDL_Colorspace, SDL_PropertiesID)"
        extern "bool SDL_ConvertPixels(int, int, SDL_PixelFormat, void *, int, SDL_PixelFormat, void *, int)"
        extern "bool SDL_ConvertPixelsAndColorspace(int, int, SDL_PixelFormat, SDL_Colorspace, SDL_PropertiesID, void *, int, SDL_PixelFormat, SDL_Colorspace, SDL_PropertiesID, void *, int)"
        extern "bool SDL_PremultiplyAlpha(int, int, SDL_PixelFormat, void *, int, SDL_PixelFormat, void *, int, bool)"
        extern "bool SDL_PremultiplySurfaceAlpha(SDL_Surface *, bool)"
        extern "bool SDL_ClearSurface(SDL_Surface *, float, float, float, float)"
        extern "bool SDL_FillSurfaceRect(SDL_Surface *, SDL_Rect *, Uint32)"
        extern "bool SDL_FillSurfaceRects(SDL_Surface *, SDL_Rect *, int, Uint32)"
        extern "bool SDL_BlitSurface(SDL_Surface *, SDL_Rect *, SDL_Surface *, SDL_Rect *)"
        extern "bool SDL_BlitSurfaceUnchecked(SDL_Surface *, SDL_Rect *, SDL_Surface *, SDL_Rect *)"
        extern "bool SDL_BlitSurfaceScaled(SDL_Surface *, SDL_Rect *, SDL_Surface *, SDL_Rect *, SDL_ScaleMode)"
        extern "bool SDL_BlitSurfaceUncheckedScaled(SDL_Surface *, SDL_Rect *, SDL_Surface *, SDL_Rect *, SDL_ScaleMode)"
        extern "bool SDL_StretchSurface(SDL_Surface *, SDL_Rect *, SDL_Surface *, SDL_Rect *, SDL_ScaleMode)"
        extern "bool SDL_BlitSurfaceTiled(SDL_Surface *, SDL_Rect *, SDL_Surface *, SDL_Rect *)"
        extern "bool SDL_BlitSurfaceTiledWithScale(SDL_Surface *, SDL_Rect *, float, SDL_ScaleMode, SDL_Surface *, SDL_Rect *)"
        extern "bool SDL_BlitSurface9Grid(SDL_Surface *, SDL_Rect *, int, int, int, int, float, SDL_ScaleMode, SDL_Surface *, SDL_Rect *)"
        extern "Uint32 SDL_MapSurfaceRGB(SDL_Surface *, Uint8, Uint8, Uint8)"
        extern "Uint32 SDL_MapSurfaceRGBA(SDL_Surface *, Uint8, Uint8, Uint8, Uint8)"
        extern "bool SDL_ReadSurfacePixel(SDL_Surface *, int, int, Uint8 *, Uint8 *, Uint8 *, Uint8 *)"
        extern "bool SDL_ReadSurfacePixelFloat(SDL_Surface *, int, int, float *, float *, float *, float *)"
        extern "bool SDL_WriteSurfacePixel(SDL_Surface *, int, int, Uint8, Uint8, Uint8, Uint8)"
        extern "bool SDL_WriteSurfacePixelFloat(SDL_Surface *, int, int, float, float, float, float)"
        typealias "SDL_CameraID", "Uint32"
        const_set :SDL_CameraSpec, struct(
          [
            "SDL_PixelFormat format",
            "SDL_Colorspace colorspace",
            "int width",
            "int height",
            "int framerate_numerator",
            "int framerate_denominator",
          ]
        )
        const_set :SDL_CAMERA_POSITION_UNKNOWN, 0
        const_set :SDL_CAMERA_POSITION_FRONT_FACING, 1
        const_set :SDL_CAMERA_POSITION_BACK_FACING, 2
        typealias "SDL_CameraPosition", "enum"
        extern "int SDL_GetNumCameraDrivers(void)"
        extern "char * SDL_GetCameraDriver(int)"
        extern "char * SDL_GetCurrentCameraDriver(void)"
        extern "SDL_CameraID * SDL_GetCameras(int *)"
        extern "SDL_CameraSpec ** SDL_GetCameraSupportedFormats(SDL_CameraID, int *)"
        extern "char * SDL_GetCameraName(SDL_CameraID)"
        extern "SDL_CameraPosition SDL_GetCameraPosition(SDL_CameraID)"
        extern "SDL_Camera * SDL_OpenCamera(SDL_CameraID, SDL_CameraSpec *)"
        extern "int SDL_GetCameraPermissionState(SDL_Camera *)"
        extern "SDL_CameraID SDL_GetCameraID(SDL_Camera *)"
        extern "SDL_PropertiesID SDL_GetCameraProperties(SDL_Camera *)"
        extern "bool SDL_GetCameraFormat(SDL_Camera *, SDL_CameraSpec *)"
        extern "SDL_Surface * SDL_AcquireCameraFrame(SDL_Camera *, Uint64 *)"
        extern "void SDL_ReleaseCameraFrame(SDL_Camera *, SDL_Surface *)"
        extern "void SDL_CloseCamera(SDL_Camera *)"
        extern "bool SDL_SetClipboardText(char *)"
        extern "char * SDL_GetClipboardText(void)"
        extern "bool SDL_HasClipboardText(void)"
        extern "bool SDL_SetPrimarySelectionText(char *)"
        extern "char * SDL_GetPrimarySelectionText(void)"
        extern "bool SDL_HasPrimarySelectionText(void)"
        typealias "SDL_ClipboardDataCallback", "function (*pointer)()"
        const_set :SDL_ClipboardDataCallback, "void * SDL_ClipboardDataCallback(void *, char *, size_t *)"
        typealias "SDL_ClipboardCleanupCallback", "function (*pointer)()"
        const_set :SDL_ClipboardCleanupCallback, "void SDL_ClipboardCleanupCallback(void *)"
        extern "bool SDL_SetClipboardData(SDL_ClipboardDataCallback, SDL_ClipboardCleanupCallback, void *, char **, size_t)"
        extern "bool SDL_ClearClipboardData(void)"
        extern "void * SDL_GetClipboardData(char *, size_t *)"
        extern "bool SDL_HasClipboardData(char *)"
        extern "char ** SDL_GetClipboardMimeTypes(size_t *)"
        extern "int SDL_GetNumLogicalCPUCores(void)"
        extern "int SDL_GetCPUCacheLineSize(void)"
        extern "bool SDL_HasAltiVec(void)"
        extern "bool SDL_HasMMX(void)"
        extern "bool SDL_HasSSE(void)"
        extern "bool SDL_HasSSE2(void)"
        extern "bool SDL_HasSSE3(void)"
        extern "bool SDL_HasSSE41(void)"
        extern "bool SDL_HasSSE42(void)"
        extern "bool SDL_HasAVX(void)"
        extern "bool SDL_HasAVX2(void)"
        extern "bool SDL_HasAVX512F(void)"
        extern "bool SDL_HasARMSIMD(void)"
        extern "bool SDL_HasNEON(void)"
        extern "bool SDL_HasLSX(void)"
        extern "bool SDL_HasLASX(void)"
        extern "int SDL_GetSystemRAM(void)"
        extern "size_t SDL_GetSIMDAlignment(void)"
        typealias "SDL_DisplayID", "Uint32"
        typealias "SDL_WindowID", "Uint32"
        const_set :SDL_SYSTEM_THEME_UNKNOWN, 0
        const_set :SDL_SYSTEM_THEME_LIGHT, 1
        const_set :SDL_SYSTEM_THEME_DARK, 2
        typealias "SDL_SystemTheme", "enum"
        const_set :SDL_DisplayMode, struct(
          [
            "SDL_DisplayID displayID",
            "SDL_PixelFormat format",
            "int w",
            "int h",
            "float pixel_density",
            "float refresh_rate",
            "int refresh_rate_numerator",
            "int refresh_rate_denominator",
            "SDL_DisplayModeData * internal",
          ]
        )
        const_set :SDL_ORIENTATION_UNKNOWN, 0
        const_set :SDL_ORIENTATION_LANDSCAPE, 1
        const_set :SDL_ORIENTATION_LANDSCAPE_FLIPPED, 2
        const_set :SDL_ORIENTATION_PORTRAIT, 3
        const_set :SDL_ORIENTATION_PORTRAIT_FLIPPED, 4
        typealias "SDL_DisplayOrientation", "enum"
        typealias "SDL_WindowFlags", "Uint64"
        const_set :SDL_FLASH_CANCEL, 0
        const_set :SDL_FLASH_BRIEFLY, 1
        const_set :SDL_FLASH_UNTIL_FOCUSED, 2
        typealias "SDL_FlashOperation", "enum"
        typealias "SDL_GLContext", "SDL_GLContextState *"
        typealias "SDL_EGLDisplay", "void *"
        typealias "SDL_EGLConfig", "void *"
        typealias "SDL_EGLSurface", "void *"
        typealias "SDL_EGLAttrib", "intptr_t"
        typealias "SDL_EGLint", "int"
        typealias "SDL_EGLAttribArrayCallback", "function (*pointer)()"
        const_set :SDL_EGLAttribArrayCallback, "SDL_EGLAttrib * SDL_EGLAttribArrayCallback(void *)"
        typealias "SDL_EGLIntArrayCallback", "function (*pointer)()"
        const_set :SDL_EGLIntArrayCallback, "SDL_EGLint * SDL_EGLIntArrayCallback(void *, SDL_EGLDisplay, SDL_EGLConfig)"
        const_set :SDL_GL_RED_SIZE, 0
        const_set :SDL_GL_GREEN_SIZE, 1
        const_set :SDL_GL_BLUE_SIZE, 2
        const_set :SDL_GL_ALPHA_SIZE, 3
        const_set :SDL_GL_BUFFER_SIZE, 4
        const_set :SDL_GL_DOUBLEBUFFER, 5
        const_set :SDL_GL_DEPTH_SIZE, 6
        const_set :SDL_GL_STENCIL_SIZE, 7
        const_set :SDL_GL_ACCUM_RED_SIZE, 8
        const_set :SDL_GL_ACCUM_GREEN_SIZE, 9
        const_set :SDL_GL_ACCUM_BLUE_SIZE, 10
        const_set :SDL_GL_ACCUM_ALPHA_SIZE, 11
        const_set :SDL_GL_STEREO, 12
        const_set :SDL_GL_MULTISAMPLEBUFFERS, 13
        const_set :SDL_GL_MULTISAMPLESAMPLES, 14
        const_set :SDL_GL_ACCELERATED_VISUAL, 15
        const_set :SDL_GL_RETAINED_BACKING, 16
        const_set :SDL_GL_CONTEXT_MAJOR_VERSION, 17
        const_set :SDL_GL_CONTEXT_MINOR_VERSION, 18
        const_set :SDL_GL_CONTEXT_FLAGS, 19
        const_set :SDL_GL_CONTEXT_PROFILE_MASK, 20
        const_set :SDL_GL_SHARE_WITH_CURRENT_CONTEXT, 21
        const_set :SDL_GL_FRAMEBUFFER_SRGB_CAPABLE, 22
        const_set :SDL_GL_CONTEXT_RELEASE_BEHAVIOR, 23
        const_set :SDL_GL_CONTEXT_RESET_NOTIFICATION, 24
        const_set :SDL_GL_CONTEXT_NO_ERROR, 25
        const_set :SDL_GL_FLOATBUFFERS, 26
        const_set :SDL_GL_EGL_PLATFORM, 27
        typealias "SDL_GLAttr", "enum"
        typealias "SDL_GLProfile", "Uint32"
        typealias "SDL_GLContextFlag", "Uint32"
        typealias "SDL_GLContextReleaseFlag", "Uint32"
        typealias "SDL_GLContextResetNotification", "Uint32"
        extern "int SDL_GetNumVideoDrivers(void)"
        extern "char * SDL_GetVideoDriver(int)"
        extern "char * SDL_GetCurrentVideoDriver(void)"
        extern "SDL_SystemTheme SDL_GetSystemTheme(void)"
        extern "SDL_DisplayID * SDL_GetDisplays(int *)"
        extern "SDL_DisplayID SDL_GetPrimaryDisplay(void)"
        extern "SDL_PropertiesID SDL_GetDisplayProperties(SDL_DisplayID)"
        extern "char * SDL_GetDisplayName(SDL_DisplayID)"
        extern "bool SDL_GetDisplayBounds(SDL_DisplayID, SDL_Rect *)"
        extern "bool SDL_GetDisplayUsableBounds(SDL_DisplayID, SDL_Rect *)"
        extern "SDL_DisplayOrientation SDL_GetNaturalDisplayOrientation(SDL_DisplayID)"
        extern "SDL_DisplayOrientation SDL_GetCurrentDisplayOrientation(SDL_DisplayID)"
        extern "float SDL_GetDisplayContentScale(SDL_DisplayID)"
        extern "SDL_DisplayMode ** SDL_GetFullscreenDisplayModes(SDL_DisplayID, int *)"
        extern "bool SDL_GetClosestFullscreenDisplayMode(SDL_DisplayID, int, int, float, bool, SDL_DisplayMode *)"
        extern "SDL_DisplayMode * SDL_GetDesktopDisplayMode(SDL_DisplayID)"
        extern "SDL_DisplayMode * SDL_GetCurrentDisplayMode(SDL_DisplayID)"
        extern "SDL_DisplayID SDL_GetDisplayForPoint(SDL_Point *)"
        extern "SDL_DisplayID SDL_GetDisplayForRect(SDL_Rect *)"
        extern "SDL_DisplayID SDL_GetDisplayForWindow(SDL_Window *)"
        extern "float SDL_GetWindowPixelDensity(SDL_Window *)"
        extern "float SDL_GetWindowDisplayScale(SDL_Window *)"
        extern "bool SDL_SetWindowFullscreenMode(SDL_Window *, SDL_DisplayMode *)"
        extern "SDL_DisplayMode * SDL_GetWindowFullscreenMode(SDL_Window *)"
        extern "void * SDL_GetWindowICCProfile(SDL_Window *, size_t *)"
        extern "SDL_PixelFormat SDL_GetWindowPixelFormat(SDL_Window *)"
        extern "SDL_Window ** SDL_GetWindows(int *)"
        extern "SDL_Window * SDL_CreateWindow(char *, int, int, SDL_WindowFlags)"
        extern "SDL_Window * SDL_CreatePopupWindow(SDL_Window *, int, int, int, int, SDL_WindowFlags)"
        extern "SDL_Window * SDL_CreateWindowWithProperties(SDL_PropertiesID)"
        extern "SDL_WindowID SDL_GetWindowID(SDL_Window *)"
        extern "SDL_Window * SDL_GetWindowFromID(SDL_WindowID)"
        extern "SDL_Window * SDL_GetWindowParent(SDL_Window *)"
        extern "SDL_PropertiesID SDL_GetWindowProperties(SDL_Window *)"
        extern "SDL_WindowFlags SDL_GetWindowFlags(SDL_Window *)"
        extern "bool SDL_SetWindowTitle(SDL_Window *, char *)"
        extern "char * SDL_GetWindowTitle(SDL_Window *)"
        extern "bool SDL_SetWindowIcon(SDL_Window *, SDL_Surface *)"
        extern "bool SDL_SetWindowPosition(SDL_Window *, int, int)"
        extern "bool SDL_GetWindowPosition(SDL_Window *, int *, int *)"
        extern "bool SDL_SetWindowSize(SDL_Window *, int, int)"
        extern "bool SDL_GetWindowSize(SDL_Window *, int *, int *)"
        extern "bool SDL_GetWindowSafeArea(SDL_Window *, SDL_Rect *)"
        extern "bool SDL_SetWindowAspectRatio(SDL_Window *, float, float)"
        extern "bool SDL_GetWindowAspectRatio(SDL_Window *, float *, float *)"
        extern "bool SDL_GetWindowBordersSize(SDL_Window *, int *, int *, int *, int *)"
        extern "bool SDL_GetWindowSizeInPixels(SDL_Window *, int *, int *)"
        extern "bool SDL_SetWindowMinimumSize(SDL_Window *, int, int)"
        extern "bool SDL_GetWindowMinimumSize(SDL_Window *, int *, int *)"
        extern "bool SDL_SetWindowMaximumSize(SDL_Window *, int, int)"
        extern "bool SDL_GetWindowMaximumSize(SDL_Window *, int *, int *)"
        extern "bool SDL_SetWindowBordered(SDL_Window *, bool)"
        extern "bool SDL_SetWindowResizable(SDL_Window *, bool)"
        extern "bool SDL_SetWindowAlwaysOnTop(SDL_Window *, bool)"
        extern "bool SDL_ShowWindow(SDL_Window *)"
        extern "bool SDL_HideWindow(SDL_Window *)"
        extern "bool SDL_RaiseWindow(SDL_Window *)"
        extern "bool SDL_MaximizeWindow(SDL_Window *)"
        extern "bool SDL_MinimizeWindow(SDL_Window *)"
        extern "bool SDL_RestoreWindow(SDL_Window *)"
        extern "bool SDL_SetWindowFullscreen(SDL_Window *, bool)"
        extern "bool SDL_SyncWindow(SDL_Window *)"
        extern "bool SDL_WindowHasSurface(SDL_Window *)"
        extern "SDL_Surface * SDL_GetWindowSurface(SDL_Window *)"
        extern "bool SDL_SetWindowSurfaceVSync(SDL_Window *, int)"
        extern "bool SDL_GetWindowSurfaceVSync(SDL_Window *, int *)"
        extern "bool SDL_UpdateWindowSurface(SDL_Window *)"
        extern "bool SDL_UpdateWindowSurfaceRects(SDL_Window *, SDL_Rect *, int)"
        extern "bool SDL_DestroyWindowSurface(SDL_Window *)"
        extern "bool SDL_SetWindowKeyboardGrab(SDL_Window *, bool)"
        extern "bool SDL_SetWindowMouseGrab(SDL_Window *, bool)"
        extern "bool SDL_GetWindowKeyboardGrab(SDL_Window *)"
        extern "bool SDL_GetWindowMouseGrab(SDL_Window *)"
        extern "SDL_Window * SDL_GetGrabbedWindow(void)"
        extern "bool SDL_SetWindowMouseRect(SDL_Window *, SDL_Rect *)"
        extern "SDL_Rect * SDL_GetWindowMouseRect(SDL_Window *)"
        extern "bool SDL_SetWindowOpacity(SDL_Window *, float)"
        extern "float SDL_GetWindowOpacity(SDL_Window *)"
        extern "bool SDL_SetWindowParent(SDL_Window *, SDL_Window *)"
        extern "bool SDL_SetWindowModal(SDL_Window *, bool)"
        extern "bool SDL_SetWindowFocusable(SDL_Window *, bool)"
        extern "bool SDL_ShowWindowSystemMenu(SDL_Window *, int, int)"
        const_set :SDL_HITTEST_NORMAL, 0
        const_set :SDL_HITTEST_DRAGGABLE, 1
        const_set :SDL_HITTEST_RESIZE_TOPLEFT, 2
        const_set :SDL_HITTEST_RESIZE_TOP, 3
        const_set :SDL_HITTEST_RESIZE_TOPRIGHT, 4
        const_set :SDL_HITTEST_RESIZE_RIGHT, 5
        const_set :SDL_HITTEST_RESIZE_BOTTOMRIGHT, 6
        const_set :SDL_HITTEST_RESIZE_BOTTOM, 7
        const_set :SDL_HITTEST_RESIZE_BOTTOMLEFT, 8
        const_set :SDL_HITTEST_RESIZE_LEFT, 9
        typealias "SDL_HitTestResult", "enum"
        typealias "SDL_HitTest", "function (*pointer)()"
        const_set :SDL_HitTest, "SDL_HitTestResult SDL_HitTest(SDL_Window *, SDL_Point *, void *)"
        extern "bool SDL_SetWindowHitTest(SDL_Window *, SDL_HitTest, void *)"
        extern "bool SDL_SetWindowShape(SDL_Window *, SDL_Surface *)"
        extern "bool SDL_FlashWindow(SDL_Window *, SDL_FlashOperation)"
        extern "void SDL_DestroyWindow(SDL_Window *)"
        extern "bool SDL_ScreenSaverEnabled(void)"
        extern "bool SDL_EnableScreenSaver(void)"
        extern "bool SDL_DisableScreenSaver(void)"
        extern "bool SDL_GL_LoadLibrary(char *)"
        extern "SDL_FunctionPointer SDL_GL_GetProcAddress(char *)"
        extern "SDL_FunctionPointer SDL_EGL_GetProcAddress(char *)"
        extern "void SDL_GL_UnloadLibrary(void)"
        extern "bool SDL_GL_ExtensionSupported(char *)"
        extern "void SDL_GL_ResetAttributes(void)"
        extern "bool SDL_GL_SetAttribute(SDL_GLAttr, int)"
        extern "bool SDL_GL_GetAttribute(SDL_GLAttr, int *)"
        extern "SDL_GLContext SDL_GL_CreateContext(SDL_Window *)"
        extern "bool SDL_GL_MakeCurrent(SDL_Window *, SDL_GLContext)"
        extern "SDL_Window * SDL_GL_GetCurrentWindow(void)"
        extern "SDL_GLContext SDL_GL_GetCurrentContext(void)"
        extern "SDL_EGLDisplay SDL_EGL_GetCurrentDisplay(void)"
        extern "SDL_EGLConfig SDL_EGL_GetCurrentConfig(void)"
        extern "SDL_EGLSurface SDL_EGL_GetWindowSurface(SDL_Window *)"
        extern "void SDL_EGL_SetAttributeCallbacks(SDL_EGLAttribArrayCallback, SDL_EGLIntArrayCallback, SDL_EGLIntArrayCallback, void *)"
        extern "bool SDL_GL_SetSwapInterval(int)"
        extern "bool SDL_GL_GetSwapInterval(int *)"
        extern "bool SDL_GL_SwapWindow(SDL_Window *)"
        extern "bool SDL_GL_DestroyContext(SDL_GLContext)"
        const_set :SDL_DialogFileFilter, struct(
          [
            "char * name",
            "char * pattern",
          ]
        )
        typealias "SDL_DialogFileCallback", "function (*pointer)()"
        const_set :SDL_DialogFileCallback, "void SDL_DialogFileCallback(void *, char **, int)"
        extern "void SDL_ShowOpenFileDialog(SDL_DialogFileCallback, void *, SDL_Window *, SDL_DialogFileFilter *, int, char *, bool)"
        extern "void SDL_ShowSaveFileDialog(SDL_DialogFileCallback, void *, SDL_Window *, SDL_DialogFileFilter *, int, char *)"
        extern "void SDL_ShowOpenFolderDialog(SDL_DialogFileCallback, void *, SDL_Window *, char *, bool)"
        const_set :SDL_FILEDIALOG_OPENFILE, 0
        const_set :SDL_FILEDIALOG_SAVEFILE, 1
        const_set :SDL_FILEDIALOG_OPENFOLDER, 2
        typealias "SDL_FileDialogType", "enum"
        extern "void SDL_ShowFileDialogWithProperties(SDL_FileDialogType, SDL_DialogFileCallback, void *, SDL_PropertiesID)"
        const_set :SDL_GUID, struct(
          [
            "Uint8 data[16]",
          ]
        )
        const_set :SDL_POWERSTATE_ERROR, 4294967295
        const_set :SDL_POWERSTATE_UNKNOWN, 0
        const_set :SDL_POWERSTATE_ON_BATTERY, 1
        const_set :SDL_POWERSTATE_NO_BATTERY, 2
        const_set :SDL_POWERSTATE_CHARGING, 3
        const_set :SDL_POWERSTATE_CHARGED, 4
        typealias "SDL_PowerState", "enum"
        extern "SDL_PowerState SDL_GetPowerInfo(int *, int *)"
        typealias "SDL_SensorID", "Uint32"
        const_set :SDL_SENSOR_INVALID, 4294967295
        const_set :SDL_SENSOR_UNKNOWN, 0
        const_set :SDL_SENSOR_ACCEL, 1
        const_set :SDL_SENSOR_GYRO, 2
        const_set :SDL_SENSOR_ACCEL_L, 3
        const_set :SDL_SENSOR_GYRO_L, 4
        const_set :SDL_SENSOR_ACCEL_R, 5
        const_set :SDL_SENSOR_GYRO_R, 6
        const_set :SDL_SENSOR_COUNT, 7
        typealias "SDL_SensorType", "enum"
        extern "SDL_SensorID * SDL_GetSensors(int *)"
        extern "char * SDL_GetSensorNameForID(SDL_SensorID)"
        extern "SDL_SensorType SDL_GetSensorTypeForID(SDL_SensorID)"
        extern "int SDL_GetSensorNonPortableTypeForID(SDL_SensorID)"
        extern "SDL_Sensor * SDL_OpenSensor(SDL_SensorID)"
        extern "SDL_Sensor * SDL_GetSensorFromID(SDL_SensorID)"
        extern "SDL_PropertiesID SDL_GetSensorProperties(SDL_Sensor *)"
        extern "char * SDL_GetSensorName(SDL_Sensor *)"
        extern "SDL_SensorType SDL_GetSensorType(SDL_Sensor *)"
        extern "int SDL_GetSensorNonPortableType(SDL_Sensor *)"
        extern "SDL_SensorID SDL_GetSensorID(SDL_Sensor *)"
        extern "bool SDL_GetSensorData(SDL_Sensor *, float *, int)"
        extern "void SDL_CloseSensor(SDL_Sensor *)"
        extern "void SDL_UpdateSensors(void)"
        typealias "SDL_JoystickID", "Uint32"
        const_set :SDL_JOYSTICK_TYPE_UNKNOWN, 0
        const_set :SDL_JOYSTICK_TYPE_GAMEPAD, 1
        const_set :SDL_JOYSTICK_TYPE_WHEEL, 2
        const_set :SDL_JOYSTICK_TYPE_ARCADE_STICK, 3
        const_set :SDL_JOYSTICK_TYPE_FLIGHT_STICK, 4
        const_set :SDL_JOYSTICK_TYPE_DANCE_PAD, 5
        const_set :SDL_JOYSTICK_TYPE_GUITAR, 6
        const_set :SDL_JOYSTICK_TYPE_DRUM_KIT, 7
        const_set :SDL_JOYSTICK_TYPE_ARCADE_PAD, 8
        const_set :SDL_JOYSTICK_TYPE_THROTTLE, 9
        const_set :SDL_JOYSTICK_TYPE_COUNT, 10
        typealias "SDL_JoystickType", "enum"
        const_set :SDL_JOYSTICK_CONNECTION_INVALID, 4294967295
        const_set :SDL_JOYSTICK_CONNECTION_UNKNOWN, 0
        const_set :SDL_JOYSTICK_CONNECTION_WIRED, 1
        const_set :SDL_JOYSTICK_CONNECTION_WIRELESS, 2
        typealias "SDL_JoystickConnectionState", "enum"
        extern "void SDL_LockJoysticks(void)"
        extern "void SDL_UnlockJoysticks(void)"
        extern "bool SDL_HasJoystick(void)"
        extern "SDL_JoystickID * SDL_GetJoysticks(int *)"
        extern "char * SDL_GetJoystickNameForID(SDL_JoystickID)"
        extern "char * SDL_GetJoystickPathForID(SDL_JoystickID)"
        extern "int SDL_GetJoystickPlayerIndexForID(SDL_JoystickID)"
        extern "Uint16 SDL_GetJoystickVendorForID(SDL_JoystickID)"
        extern "Uint16 SDL_GetJoystickProductForID(SDL_JoystickID)"
        extern "Uint16 SDL_GetJoystickProductVersionForID(SDL_JoystickID)"
        extern "SDL_JoystickType SDL_GetJoystickTypeForID(SDL_JoystickID)"
        extern "SDL_Joystick * SDL_OpenJoystick(SDL_JoystickID)"
        extern "SDL_Joystick * SDL_GetJoystickFromID(SDL_JoystickID)"
        extern "SDL_Joystick * SDL_GetJoystickFromPlayerIndex(int)"
        const_set :SDL_VirtualJoystickTouchpadDesc, struct(
          [
            "Uint16 nfingers",
            "Uint16 padding[3]",
          ]
        )
        const_set :SDL_VirtualJoystickSensorDesc, struct(
          [
            "SDL_SensorType type",
            "float rate",
          ]
        )
        const_set :SDL_VirtualJoystickDesc, struct(
          [
            "Uint32 version",
            "Uint16 type",
            "Uint16 padding",
            "Uint16 vendor_id",
            "Uint16 product_id",
            "Uint16 naxes",
            "Uint16 nbuttons",
            "Uint16 nballs",
            "Uint16 nhats",
            "Uint16 ntouchpads",
            "Uint16 nsensors",
            "Uint16 padding2[2]",
            "Uint32 button_mask",
            "Uint32 axis_mask",
            "char * name",
            "SDL_VirtualJoystickTouchpadDesc * touchpads",
            "SDL_VirtualJoystickSensorDesc * sensors",
            "void * userdata",
            "function (*Update)()",
            "function (*SetPlayerIndex)()",
            "function (*Rumble)()",
            "function (*RumbleTriggers)()",
            "function (*SetLED)()",
            "function (*SendEffect)()",
            "function (*SetSensorsEnabled)()",
            "function (*Cleanup)()",
          ]
        )
        extern "SDL_JoystickID SDL_AttachVirtualJoystick(SDL_VirtualJoystickDesc *)"
        extern "bool SDL_DetachVirtualJoystick(SDL_JoystickID)"
        extern "bool SDL_IsJoystickVirtual(SDL_JoystickID)"
        extern "bool SDL_SetJoystickVirtualAxis(SDL_Joystick *, int, Sint16)"
        extern "bool SDL_SetJoystickVirtualBall(SDL_Joystick *, int, Sint16, Sint16)"
        extern "bool SDL_SetJoystickVirtualButton(SDL_Joystick *, int, bool)"
        extern "bool SDL_SetJoystickVirtualHat(SDL_Joystick *, int, Uint8)"
        extern "bool SDL_SetJoystickVirtualTouchpad(SDL_Joystick *, int, int, bool, float, float, float)"
        extern "bool SDL_SendJoystickVirtualSensorData(SDL_Joystick *, SDL_SensorType, Uint64, float *, int)"
        extern "SDL_PropertiesID SDL_GetJoystickProperties(SDL_Joystick *)"
        extern "char * SDL_GetJoystickName(SDL_Joystick *)"
        extern "char * SDL_GetJoystickPath(SDL_Joystick *)"
        extern "int SDL_GetJoystickPlayerIndex(SDL_Joystick *)"
        extern "bool SDL_SetJoystickPlayerIndex(SDL_Joystick *, int)"
        extern "Uint16 SDL_GetJoystickVendor(SDL_Joystick *)"
        extern "Uint16 SDL_GetJoystickProduct(SDL_Joystick *)"
        extern "Uint16 SDL_GetJoystickProductVersion(SDL_Joystick *)"
        extern "Uint16 SDL_GetJoystickFirmwareVersion(SDL_Joystick *)"
        extern "char * SDL_GetJoystickSerial(SDL_Joystick *)"
        extern "SDL_JoystickType SDL_GetJoystickType(SDL_Joystick *)"
        extern "bool SDL_JoystickConnected(SDL_Joystick *)"
        extern "SDL_JoystickID SDL_GetJoystickID(SDL_Joystick *)"
        extern "int SDL_GetNumJoystickAxes(SDL_Joystick *)"
        extern "int SDL_GetNumJoystickBalls(SDL_Joystick *)"
        extern "int SDL_GetNumJoystickHats(SDL_Joystick *)"
        extern "int SDL_GetNumJoystickButtons(SDL_Joystick *)"
        extern "void SDL_SetJoystickEventsEnabled(bool)"
        extern "bool SDL_JoystickEventsEnabled(void)"
        extern "void SDL_UpdateJoysticks(void)"
        extern "Sint16 SDL_GetJoystickAxis(SDL_Joystick *, int)"
        extern "bool SDL_GetJoystickAxisInitialState(SDL_Joystick *, int, Sint16 *)"
        extern "bool SDL_GetJoystickBall(SDL_Joystick *, int, int *, int *)"
        extern "Uint8 SDL_GetJoystickHat(SDL_Joystick *, int)"
        extern "bool SDL_GetJoystickButton(SDL_Joystick *, int)"
        extern "bool SDL_RumbleJoystick(SDL_Joystick *, Uint16, Uint16, Uint32)"
        extern "bool SDL_RumbleJoystickTriggers(SDL_Joystick *, Uint16, Uint16, Uint32)"
        extern "bool SDL_SetJoystickLED(SDL_Joystick *, Uint8, Uint8, Uint8)"
        extern "bool SDL_SendJoystickEffect(SDL_Joystick *, void *, int)"
        extern "void SDL_CloseJoystick(SDL_Joystick *)"
        extern "SDL_JoystickConnectionState SDL_GetJoystickConnectionState(SDL_Joystick *)"
        extern "SDL_PowerState SDL_GetJoystickPowerInfo(SDL_Joystick *, int *)"
        const_set :SDL_GAMEPAD_TYPE_UNKNOWN, 0
        const_set :SDL_GAMEPAD_TYPE_STANDARD, 1
        const_set :SDL_GAMEPAD_TYPE_XBOX360, 2
        const_set :SDL_GAMEPAD_TYPE_XBOXONE, 3
        const_set :SDL_GAMEPAD_TYPE_PS3, 4
        const_set :SDL_GAMEPAD_TYPE_PS4, 5
        const_set :SDL_GAMEPAD_TYPE_PS5, 6
        const_set :SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO, 7
        const_set :SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT, 8
        const_set :SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT, 9
        const_set :SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR, 10
        const_set :SDL_GAMEPAD_TYPE_COUNT, 11
        typealias "SDL_GamepadType", "enum"
        const_set :SDL_GAMEPAD_BUTTON_INVALID, 4294967295
        const_set :SDL_GAMEPAD_BUTTON_SOUTH, 0
        const_set :SDL_GAMEPAD_BUTTON_EAST, 1
        const_set :SDL_GAMEPAD_BUTTON_WEST, 2
        const_set :SDL_GAMEPAD_BUTTON_NORTH, 3
        const_set :SDL_GAMEPAD_BUTTON_BACK, 4
        const_set :SDL_GAMEPAD_BUTTON_GUIDE, 5
        const_set :SDL_GAMEPAD_BUTTON_START, 6
        const_set :SDL_GAMEPAD_BUTTON_LEFT_STICK, 7
        const_set :SDL_GAMEPAD_BUTTON_RIGHT_STICK, 8
        const_set :SDL_GAMEPAD_BUTTON_LEFT_SHOULDER, 9
        const_set :SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER, 10
        const_set :SDL_GAMEPAD_BUTTON_DPAD_UP, 11
        const_set :SDL_GAMEPAD_BUTTON_DPAD_DOWN, 12
        const_set :SDL_GAMEPAD_BUTTON_DPAD_LEFT, 13
        const_set :SDL_GAMEPAD_BUTTON_DPAD_RIGHT, 14
        const_set :SDL_GAMEPAD_BUTTON_MISC1, 15
        const_set :SDL_GAMEPAD_BUTTON_RIGHT_PADDLE1, 16
        const_set :SDL_GAMEPAD_BUTTON_LEFT_PADDLE1, 17
        const_set :SDL_GAMEPAD_BUTTON_RIGHT_PADDLE2, 18
        const_set :SDL_GAMEPAD_BUTTON_LEFT_PADDLE2, 19
        const_set :SDL_GAMEPAD_BUTTON_TOUCHPAD, 20
        const_set :SDL_GAMEPAD_BUTTON_MISC2, 21
        const_set :SDL_GAMEPAD_BUTTON_MISC3, 22
        const_set :SDL_GAMEPAD_BUTTON_MISC4, 23
        const_set :SDL_GAMEPAD_BUTTON_MISC5, 24
        const_set :SDL_GAMEPAD_BUTTON_MISC6, 25
        const_set :SDL_GAMEPAD_BUTTON_COUNT, 26
        typealias "SDL_GamepadButton", "enum"
        const_set :SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN, 0
        const_set :SDL_GAMEPAD_BUTTON_LABEL_A, 1
        const_set :SDL_GAMEPAD_BUTTON_LABEL_B, 2
        const_set :SDL_GAMEPAD_BUTTON_LABEL_X, 3
        const_set :SDL_GAMEPAD_BUTTON_LABEL_Y, 4
        const_set :SDL_GAMEPAD_BUTTON_LABEL_CROSS, 5
        const_set :SDL_GAMEPAD_BUTTON_LABEL_CIRCLE, 6
        const_set :SDL_GAMEPAD_BUTTON_LABEL_SQUARE, 7
        const_set :SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE, 8
        typealias "SDL_GamepadButtonLabel", "enum"
        const_set :SDL_GAMEPAD_AXIS_INVALID, 4294967295
        const_set :SDL_GAMEPAD_AXIS_LEFTX, 0
        const_set :SDL_GAMEPAD_AXIS_LEFTY, 1
        const_set :SDL_GAMEPAD_AXIS_RIGHTX, 2
        const_set :SDL_GAMEPAD_AXIS_RIGHTY, 3
        const_set :SDL_GAMEPAD_AXIS_LEFT_TRIGGER, 4
        const_set :SDL_GAMEPAD_AXIS_RIGHT_TRIGGER, 5
        const_set :SDL_GAMEPAD_AXIS_COUNT, 6
        typealias "SDL_GamepadAxis", "enum"
        const_set :SDL_GAMEPAD_BINDTYPE_NONE, 0
        const_set :SDL_GAMEPAD_BINDTYPE_BUTTON, 1
        const_set :SDL_GAMEPAD_BINDTYPE_AXIS, 2
        const_set :SDL_GAMEPAD_BINDTYPE_HAT, 3
        typealias "SDL_GamepadBindingType", "enum"
        const_set :SDL_GamepadBinding, struct(
          [
            "SDL_GamepadBindingType input_type",
            {
              input: union(
                [
                  "int button",
                  {
                    axis: struct(
                      [
                        "int axis",
                        "int axis_min",
                        "int axis_max",
                      ]
                    )
                  },
                  {
                    hat: struct(
                      [
                        "int hat",
                        "int hat_mask",
                      ]
                    )
                  },
                ]
              )
            },
            "SDL_GamepadBindingType output_type",
            {
              output: union(
                [
                  "SDL_GamepadButton button",
                  {
                    axis: struct(
                      [
                        "SDL_GamepadAxis axis",
                        "int axis_min",
                        "int axis_max",
                      ]
                    )
                  },
                ]
              )
            },
          ]
        )
        extern "int SDL_AddGamepadMapping(char *)"
        extern "int SDL_AddGamepadMappingsFromIO(SDL_IOStream *, bool)"
        extern "int SDL_AddGamepadMappingsFromFile(char *)"
        extern "bool SDL_ReloadGamepadMappings(void)"
        extern "char ** SDL_GetGamepadMappings(int *)"
        extern "char * SDL_GetGamepadMapping(SDL_Gamepad *)"
        extern "bool SDL_SetGamepadMapping(SDL_JoystickID, char *)"
        extern "bool SDL_HasGamepad(void)"
        extern "SDL_JoystickID * SDL_GetGamepads(int *)"
        extern "bool SDL_IsGamepad(SDL_JoystickID)"
        extern "char * SDL_GetGamepadNameForID(SDL_JoystickID)"
        extern "char * SDL_GetGamepadPathForID(SDL_JoystickID)"
        extern "int SDL_GetGamepadPlayerIndexForID(SDL_JoystickID)"
        extern "Uint16 SDL_GetGamepadVendorForID(SDL_JoystickID)"
        extern "Uint16 SDL_GetGamepadProductForID(SDL_JoystickID)"
        extern "Uint16 SDL_GetGamepadProductVersionForID(SDL_JoystickID)"
        extern "SDL_GamepadType SDL_GetGamepadTypeForID(SDL_JoystickID)"
        extern "SDL_GamepadType SDL_GetRealGamepadTypeForID(SDL_JoystickID)"
        extern "char * SDL_GetGamepadMappingForID(SDL_JoystickID)"
        extern "SDL_Gamepad * SDL_OpenGamepad(SDL_JoystickID)"
        extern "SDL_Gamepad * SDL_GetGamepadFromID(SDL_JoystickID)"
        extern "SDL_Gamepad * SDL_GetGamepadFromPlayerIndex(int)"
        extern "SDL_PropertiesID SDL_GetGamepadProperties(SDL_Gamepad *)"
        extern "SDL_JoystickID SDL_GetGamepadID(SDL_Gamepad *)"
        extern "char * SDL_GetGamepadName(SDL_Gamepad *)"
        extern "char * SDL_GetGamepadPath(SDL_Gamepad *)"
        extern "SDL_GamepadType SDL_GetGamepadType(SDL_Gamepad *)"
        extern "SDL_GamepadType SDL_GetRealGamepadType(SDL_Gamepad *)"
        extern "int SDL_GetGamepadPlayerIndex(SDL_Gamepad *)"
        extern "bool SDL_SetGamepadPlayerIndex(SDL_Gamepad *, int)"
        extern "Uint16 SDL_GetGamepadVendor(SDL_Gamepad *)"
        extern "Uint16 SDL_GetGamepadProduct(SDL_Gamepad *)"
        extern "Uint16 SDL_GetGamepadProductVersion(SDL_Gamepad *)"
        extern "Uint16 SDL_GetGamepadFirmwareVersion(SDL_Gamepad *)"
        extern "char * SDL_GetGamepadSerial(SDL_Gamepad *)"
        extern "Uint64 SDL_GetGamepadSteamHandle(SDL_Gamepad *)"
        extern "SDL_JoystickConnectionState SDL_GetGamepadConnectionState(SDL_Gamepad *)"
        extern "SDL_PowerState SDL_GetGamepadPowerInfo(SDL_Gamepad *, int *)"
        extern "bool SDL_GamepadConnected(SDL_Gamepad *)"
        extern "SDL_Joystick * SDL_GetGamepadJoystick(SDL_Gamepad *)"
        extern "void SDL_SetGamepadEventsEnabled(bool)"
        extern "bool SDL_GamepadEventsEnabled(void)"
        extern "SDL_GamepadBinding ** SDL_GetGamepadBindings(SDL_Gamepad *, int *)"
        extern "void SDL_UpdateGamepads(void)"
        extern "SDL_GamepadType SDL_GetGamepadTypeFromString(char *)"
        extern "char * SDL_GetGamepadStringForType(SDL_GamepadType)"
        extern "SDL_GamepadAxis SDL_GetGamepadAxisFromString(char *)"
        extern "char * SDL_GetGamepadStringForAxis(SDL_GamepadAxis)"
        extern "bool SDL_GamepadHasAxis(SDL_Gamepad *, SDL_GamepadAxis)"
        extern "Sint16 SDL_GetGamepadAxis(SDL_Gamepad *, SDL_GamepadAxis)"
        extern "SDL_GamepadButton SDL_GetGamepadButtonFromString(char *)"
        extern "char * SDL_GetGamepadStringForButton(SDL_GamepadButton)"
        extern "bool SDL_GamepadHasButton(SDL_Gamepad *, SDL_GamepadButton)"
        extern "bool SDL_GetGamepadButton(SDL_Gamepad *, SDL_GamepadButton)"
        extern "SDL_GamepadButtonLabel SDL_GetGamepadButtonLabelForType(SDL_GamepadType, SDL_GamepadButton)"
        extern "SDL_GamepadButtonLabel SDL_GetGamepadButtonLabel(SDL_Gamepad *, SDL_GamepadButton)"
        extern "int SDL_GetNumGamepadTouchpads(SDL_Gamepad *)"
        extern "int SDL_GetNumGamepadTouchpadFingers(SDL_Gamepad *, int)"
        extern "bool SDL_GetGamepadTouchpadFinger(SDL_Gamepad *, int, int, bool *, float *, float *, float *)"
        extern "bool SDL_GamepadHasSensor(SDL_Gamepad *, SDL_SensorType)"
        extern "bool SDL_SetGamepadSensorEnabled(SDL_Gamepad *, SDL_SensorType, bool)"
        extern "bool SDL_GamepadSensorEnabled(SDL_Gamepad *, SDL_SensorType)"
        extern "float SDL_GetGamepadSensorDataRate(SDL_Gamepad *, SDL_SensorType)"
        extern "bool SDL_GetGamepadSensorData(SDL_Gamepad *, SDL_SensorType, float *, int)"
        extern "bool SDL_RumbleGamepad(SDL_Gamepad *, Uint16, Uint16, Uint32)"
        extern "bool SDL_RumbleGamepadTriggers(SDL_Gamepad *, Uint16, Uint16, Uint32)"
        extern "bool SDL_SetGamepadLED(SDL_Gamepad *, Uint8, Uint8, Uint8)"
        extern "bool SDL_SendGamepadEffect(SDL_Gamepad *, void *, int)"
        extern "void SDL_CloseGamepad(SDL_Gamepad *)"
        extern "char * SDL_GetGamepadAppleSFSymbolsNameForButton(SDL_Gamepad *, SDL_GamepadButton)"
        extern "char * SDL_GetGamepadAppleSFSymbolsNameForAxis(SDL_Gamepad *, SDL_GamepadAxis)"
        const_set :SDL_SCANCODE_UNKNOWN, 0
        const_set :SDL_SCANCODE_A, 4
        const_set :SDL_SCANCODE_B, 5
        const_set :SDL_SCANCODE_C, 6
        const_set :SDL_SCANCODE_D, 7
        const_set :SDL_SCANCODE_E, 8
        const_set :SDL_SCANCODE_F, 9
        const_set :SDL_SCANCODE_G, 10
        const_set :SDL_SCANCODE_H, 11
        const_set :SDL_SCANCODE_I, 12
        const_set :SDL_SCANCODE_J, 13
        const_set :SDL_SCANCODE_K, 14
        const_set :SDL_SCANCODE_L, 15
        const_set :SDL_SCANCODE_M, 16
        const_set :SDL_SCANCODE_N, 17
        const_set :SDL_SCANCODE_O, 18
        const_set :SDL_SCANCODE_P, 19
        const_set :SDL_SCANCODE_Q, 20
        const_set :SDL_SCANCODE_R, 21
        const_set :SDL_SCANCODE_S, 22
        const_set :SDL_SCANCODE_T, 23
        const_set :SDL_SCANCODE_U, 24
        const_set :SDL_SCANCODE_V, 25
        const_set :SDL_SCANCODE_W, 26
        const_set :SDL_SCANCODE_X, 27
        const_set :SDL_SCANCODE_Y, 28
        const_set :SDL_SCANCODE_Z, 29
        const_set :SDL_SCANCODE_1, 30
        const_set :SDL_SCANCODE_2, 31
        const_set :SDL_SCANCODE_3, 32
        const_set :SDL_SCANCODE_4, 33
        const_set :SDL_SCANCODE_5, 34
        const_set :SDL_SCANCODE_6, 35
        const_set :SDL_SCANCODE_7, 36
        const_set :SDL_SCANCODE_8, 37
        const_set :SDL_SCANCODE_9, 38
        const_set :SDL_SCANCODE_0, 39
        const_set :SDL_SCANCODE_RETURN, 40
        const_set :SDL_SCANCODE_ESCAPE, 41
        const_set :SDL_SCANCODE_BACKSPACE, 42
        const_set :SDL_SCANCODE_TAB, 43
        const_set :SDL_SCANCODE_SPACE, 44
        const_set :SDL_SCANCODE_MINUS, 45
        const_set :SDL_SCANCODE_EQUALS, 46
        const_set :SDL_SCANCODE_LEFTBRACKET, 47
        const_set :SDL_SCANCODE_RIGHTBRACKET, 48
        const_set :SDL_SCANCODE_BACKSLASH, 49
        const_set :SDL_SCANCODE_NONUSHASH, 50
        const_set :SDL_SCANCODE_SEMICOLON, 51
        const_set :SDL_SCANCODE_APOSTROPHE, 52
        const_set :SDL_SCANCODE_GRAVE, 53
        const_set :SDL_SCANCODE_COMMA, 54
        const_set :SDL_SCANCODE_PERIOD, 55
        const_set :SDL_SCANCODE_SLASH, 56
        const_set :SDL_SCANCODE_CAPSLOCK, 57
        const_set :SDL_SCANCODE_F1, 58
        const_set :SDL_SCANCODE_F2, 59
        const_set :SDL_SCANCODE_F3, 60
        const_set :SDL_SCANCODE_F4, 61
        const_set :SDL_SCANCODE_F5, 62
        const_set :SDL_SCANCODE_F6, 63
        const_set :SDL_SCANCODE_F7, 64
        const_set :SDL_SCANCODE_F8, 65
        const_set :SDL_SCANCODE_F9, 66
        const_set :SDL_SCANCODE_F10, 67
        const_set :SDL_SCANCODE_F11, 68
        const_set :SDL_SCANCODE_F12, 69
        const_set :SDL_SCANCODE_PRINTSCREEN, 70
        const_set :SDL_SCANCODE_SCROLLLOCK, 71
        const_set :SDL_SCANCODE_PAUSE, 72
        const_set :SDL_SCANCODE_INSERT, 73
        const_set :SDL_SCANCODE_HOME, 74
        const_set :SDL_SCANCODE_PAGEUP, 75
        const_set :SDL_SCANCODE_DELETE, 76
        const_set :SDL_SCANCODE_END, 77
        const_set :SDL_SCANCODE_PAGEDOWN, 78
        const_set :SDL_SCANCODE_RIGHT, 79
        const_set :SDL_SCANCODE_LEFT, 80
        const_set :SDL_SCANCODE_DOWN, 81
        const_set :SDL_SCANCODE_UP, 82
        const_set :SDL_SCANCODE_NUMLOCKCLEAR, 83
        const_set :SDL_SCANCODE_KP_DIVIDE, 84
        const_set :SDL_SCANCODE_KP_MULTIPLY, 85
        const_set :SDL_SCANCODE_KP_MINUS, 86
        const_set :SDL_SCANCODE_KP_PLUS, 87
        const_set :SDL_SCANCODE_KP_ENTER, 88
        const_set :SDL_SCANCODE_KP_1, 89
        const_set :SDL_SCANCODE_KP_2, 90
        const_set :SDL_SCANCODE_KP_3, 91
        const_set :SDL_SCANCODE_KP_4, 92
        const_set :SDL_SCANCODE_KP_5, 93
        const_set :SDL_SCANCODE_KP_6, 94
        const_set :SDL_SCANCODE_KP_7, 95
        const_set :SDL_SCANCODE_KP_8, 96
        const_set :SDL_SCANCODE_KP_9, 97
        const_set :SDL_SCANCODE_KP_0, 98
        const_set :SDL_SCANCODE_KP_PERIOD, 99
        const_set :SDL_SCANCODE_NONUSBACKSLASH, 100
        const_set :SDL_SCANCODE_APPLICATION, 101
        const_set :SDL_SCANCODE_POWER, 102
        const_set :SDL_SCANCODE_KP_EQUALS, 103
        const_set :SDL_SCANCODE_F13, 104
        const_set :SDL_SCANCODE_F14, 105
        const_set :SDL_SCANCODE_F15, 106
        const_set :SDL_SCANCODE_F16, 107
        const_set :SDL_SCANCODE_F17, 108
        const_set :SDL_SCANCODE_F18, 109
        const_set :SDL_SCANCODE_F19, 110
        const_set :SDL_SCANCODE_F20, 111
        const_set :SDL_SCANCODE_F21, 112
        const_set :SDL_SCANCODE_F22, 113
        const_set :SDL_SCANCODE_F23, 114
        const_set :SDL_SCANCODE_F24, 115
        const_set :SDL_SCANCODE_EXECUTE, 116
        const_set :SDL_SCANCODE_HELP, 117
        const_set :SDL_SCANCODE_MENU, 118
        const_set :SDL_SCANCODE_SELECT, 119
        const_set :SDL_SCANCODE_STOP, 120
        const_set :SDL_SCANCODE_AGAIN, 121
        const_set :SDL_SCANCODE_UNDO, 122
        const_set :SDL_SCANCODE_CUT, 123
        const_set :SDL_SCANCODE_COPY, 124
        const_set :SDL_SCANCODE_PASTE, 125
        const_set :SDL_SCANCODE_FIND, 126
        const_set :SDL_SCANCODE_MUTE, 127
        const_set :SDL_SCANCODE_VOLUMEUP, 128
        const_set :SDL_SCANCODE_VOLUMEDOWN, 129
        const_set :SDL_SCANCODE_KP_COMMA, 133
        const_set :SDL_SCANCODE_KP_EQUALSAS400, 134
        const_set :SDL_SCANCODE_INTERNATIONAL1, 135
        const_set :SDL_SCANCODE_INTERNATIONAL2, 136
        const_set :SDL_SCANCODE_INTERNATIONAL3, 137
        const_set :SDL_SCANCODE_INTERNATIONAL4, 138
        const_set :SDL_SCANCODE_INTERNATIONAL5, 139
        const_set :SDL_SCANCODE_INTERNATIONAL6, 140
        const_set :SDL_SCANCODE_INTERNATIONAL7, 141
        const_set :SDL_SCANCODE_INTERNATIONAL8, 142
        const_set :SDL_SCANCODE_INTERNATIONAL9, 143
        const_set :SDL_SCANCODE_LANG1, 144
        const_set :SDL_SCANCODE_LANG2, 145
        const_set :SDL_SCANCODE_LANG3, 146
        const_set :SDL_SCANCODE_LANG4, 147
        const_set :SDL_SCANCODE_LANG5, 148
        const_set :SDL_SCANCODE_LANG6, 149
        const_set :SDL_SCANCODE_LANG7, 150
        const_set :SDL_SCANCODE_LANG8, 151
        const_set :SDL_SCANCODE_LANG9, 152
        const_set :SDL_SCANCODE_ALTERASE, 153
        const_set :SDL_SCANCODE_SYSREQ, 154
        const_set :SDL_SCANCODE_CANCEL, 155
        const_set :SDL_SCANCODE_CLEAR, 156
        const_set :SDL_SCANCODE_PRIOR, 157
        const_set :SDL_SCANCODE_RETURN2, 158
        const_set :SDL_SCANCODE_SEPARATOR, 159
        const_set :SDL_SCANCODE_OUT, 160
        const_set :SDL_SCANCODE_OPER, 161
        const_set :SDL_SCANCODE_CLEARAGAIN, 162
        const_set :SDL_SCANCODE_CRSEL, 163
        const_set :SDL_SCANCODE_EXSEL, 164
        const_set :SDL_SCANCODE_KP_00, 176
        const_set :SDL_SCANCODE_KP_000, 177
        const_set :SDL_SCANCODE_THOUSANDSSEPARATOR, 178
        const_set :SDL_SCANCODE_DECIMALSEPARATOR, 179
        const_set :SDL_SCANCODE_CURRENCYUNIT, 180
        const_set :SDL_SCANCODE_CURRENCYSUBUNIT, 181
        const_set :SDL_SCANCODE_KP_LEFTPAREN, 182
        const_set :SDL_SCANCODE_KP_RIGHTPAREN, 183
        const_set :SDL_SCANCODE_KP_LEFTBRACE, 184
        const_set :SDL_SCANCODE_KP_RIGHTBRACE, 185
        const_set :SDL_SCANCODE_KP_TAB, 186
        const_set :SDL_SCANCODE_KP_BACKSPACE, 187
        const_set :SDL_SCANCODE_KP_A, 188
        const_set :SDL_SCANCODE_KP_B, 189
        const_set :SDL_SCANCODE_KP_C, 190
        const_set :SDL_SCANCODE_KP_D, 191
        const_set :SDL_SCANCODE_KP_E, 192
        const_set :SDL_SCANCODE_KP_F, 193
        const_set :SDL_SCANCODE_KP_XOR, 194
        const_set :SDL_SCANCODE_KP_POWER, 195
        const_set :SDL_SCANCODE_KP_PERCENT, 196
        const_set :SDL_SCANCODE_KP_LESS, 197
        const_set :SDL_SCANCODE_KP_GREATER, 198
        const_set :SDL_SCANCODE_KP_AMPERSAND, 199
        const_set :SDL_SCANCODE_KP_DBLAMPERSAND, 200
        const_set :SDL_SCANCODE_KP_VERTICALBAR, 201
        const_set :SDL_SCANCODE_KP_DBLVERTICALBAR, 202
        const_set :SDL_SCANCODE_KP_COLON, 203
        const_set :SDL_SCANCODE_KP_HASH, 204
        const_set :SDL_SCANCODE_KP_SPACE, 205
        const_set :SDL_SCANCODE_KP_AT, 206
        const_set :SDL_SCANCODE_KP_EXCLAM, 207
        const_set :SDL_SCANCODE_KP_MEMSTORE, 208
        const_set :SDL_SCANCODE_KP_MEMRECALL, 209
        const_set :SDL_SCANCODE_KP_MEMCLEAR, 210
        const_set :SDL_SCANCODE_KP_MEMADD, 211
        const_set :SDL_SCANCODE_KP_MEMSUBTRACT, 212
        const_set :SDL_SCANCODE_KP_MEMMULTIPLY, 213
        const_set :SDL_SCANCODE_KP_MEMDIVIDE, 214
        const_set :SDL_SCANCODE_KP_PLUSMINUS, 215
        const_set :SDL_SCANCODE_KP_CLEAR, 216
        const_set :SDL_SCANCODE_KP_CLEARENTRY, 217
        const_set :SDL_SCANCODE_KP_BINARY, 218
        const_set :SDL_SCANCODE_KP_OCTAL, 219
        const_set :SDL_SCANCODE_KP_DECIMAL, 220
        const_set :SDL_SCANCODE_KP_HEXADECIMAL, 221
        const_set :SDL_SCANCODE_LCTRL, 224
        const_set :SDL_SCANCODE_LSHIFT, 225
        const_set :SDL_SCANCODE_LALT, 226
        const_set :SDL_SCANCODE_LGUI, 227
        const_set :SDL_SCANCODE_RCTRL, 228
        const_set :SDL_SCANCODE_RSHIFT, 229
        const_set :SDL_SCANCODE_RALT, 230
        const_set :SDL_SCANCODE_RGUI, 231
        const_set :SDL_SCANCODE_MODE, 257
        const_set :SDL_SCANCODE_SLEEP, 258
        const_set :SDL_SCANCODE_WAKE, 259
        const_set :SDL_SCANCODE_CHANNEL_INCREMENT, 260
        const_set :SDL_SCANCODE_CHANNEL_DECREMENT, 261
        const_set :SDL_SCANCODE_MEDIA_PLAY, 262
        const_set :SDL_SCANCODE_MEDIA_PAUSE, 263
        const_set :SDL_SCANCODE_MEDIA_RECORD, 264
        const_set :SDL_SCANCODE_MEDIA_FAST_FORWARD, 265
        const_set :SDL_SCANCODE_MEDIA_REWIND, 266
        const_set :SDL_SCANCODE_MEDIA_NEXT_TRACK, 267
        const_set :SDL_SCANCODE_MEDIA_PREVIOUS_TRACK, 268
        const_set :SDL_SCANCODE_MEDIA_STOP, 269
        const_set :SDL_SCANCODE_MEDIA_EJECT, 270
        const_set :SDL_SCANCODE_MEDIA_PLAY_PAUSE, 271
        const_set :SDL_SCANCODE_MEDIA_SELECT, 272
        const_set :SDL_SCANCODE_AC_NEW, 273
        const_set :SDL_SCANCODE_AC_OPEN, 274
        const_set :SDL_SCANCODE_AC_CLOSE, 275
        const_set :SDL_SCANCODE_AC_EXIT, 276
        const_set :SDL_SCANCODE_AC_SAVE, 277
        const_set :SDL_SCANCODE_AC_PRINT, 278
        const_set :SDL_SCANCODE_AC_PROPERTIES, 279
        const_set :SDL_SCANCODE_AC_SEARCH, 280
        const_set :SDL_SCANCODE_AC_HOME, 281
        const_set :SDL_SCANCODE_AC_BACK, 282
        const_set :SDL_SCANCODE_AC_FORWARD, 283
        const_set :SDL_SCANCODE_AC_STOP, 284
        const_set :SDL_SCANCODE_AC_REFRESH, 285
        const_set :SDL_SCANCODE_AC_BOOKMARKS, 286
        const_set :SDL_SCANCODE_SOFTLEFT, 287
        const_set :SDL_SCANCODE_SOFTRIGHT, 288
        const_set :SDL_SCANCODE_CALL, 289
        const_set :SDL_SCANCODE_ENDCALL, 290
        const_set :SDL_SCANCODE_RESERVED, 400
        const_set :SDL_SCANCODE_COUNT, 512
        typealias "SDL_Scancode", "enum"
        typealias "SDL_Keycode", "Uint32"
        typealias "SDL_Keymod", "Uint16"
        typealias "SDL_KeyboardID", "Uint32"
        extern "bool SDL_HasKeyboard(void)"
        extern "SDL_KeyboardID * SDL_GetKeyboards(int *)"
        extern "char * SDL_GetKeyboardNameForID(SDL_KeyboardID)"
        extern "SDL_Window * SDL_GetKeyboardFocus(void)"
        extern "bool * SDL_GetKeyboardState(int *)"
        extern "void SDL_ResetKeyboard(void)"
        extern "SDL_Keymod SDL_GetModState(void)"
        extern "void SDL_SetModState(SDL_Keymod)"
        extern "SDL_Keycode SDL_GetKeyFromScancode(SDL_Scancode, SDL_Keymod, bool)"
        extern "SDL_Scancode SDL_GetScancodeFromKey(SDL_Keycode, SDL_Keymod *)"
        extern "bool SDL_SetScancodeName(SDL_Scancode, char *)"
        extern "char * SDL_GetScancodeName(SDL_Scancode)"
        extern "SDL_Scancode SDL_GetScancodeFromName(char *)"
        extern "char * SDL_GetKeyName(SDL_Keycode)"
        extern "SDL_Keycode SDL_GetKeyFromName(char *)"
        extern "bool SDL_StartTextInput(SDL_Window *)"
        const_set :SDL_TEXTINPUT_TYPE_TEXT, 0
        const_set :SDL_TEXTINPUT_TYPE_TEXT_NAME, 1
        const_set :SDL_TEXTINPUT_TYPE_TEXT_EMAIL, 2
        const_set :SDL_TEXTINPUT_TYPE_TEXT_USERNAME, 3
        const_set :SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_HIDDEN, 4
        const_set :SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_VISIBLE, 5
        const_set :SDL_TEXTINPUT_TYPE_NUMBER, 6
        const_set :SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_HIDDEN, 7
        const_set :SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_VISIBLE, 8
        typealias "SDL_TextInputType", "enum"
        const_set :SDL_CAPITALIZE_NONE, 0
        const_set :SDL_CAPITALIZE_SENTENCES, 1
        const_set :SDL_CAPITALIZE_WORDS, 2
        const_set :SDL_CAPITALIZE_LETTERS, 3
        typealias "SDL_Capitalization", "enum"
        extern "bool SDL_StartTextInputWithProperties(SDL_Window *, SDL_PropertiesID)"
        extern "bool SDL_TextInputActive(SDL_Window *)"
        extern "bool SDL_StopTextInput(SDL_Window *)"
        extern "bool SDL_ClearComposition(SDL_Window *)"
        extern "bool SDL_SetTextInputArea(SDL_Window *, SDL_Rect *, int)"
        extern "bool SDL_GetTextInputArea(SDL_Window *, SDL_Rect *, int *)"
        extern "bool SDL_HasScreenKeyboardSupport(void)"
        extern "bool SDL_ScreenKeyboardShown(SDL_Window *)"
        typealias "SDL_MouseID", "Uint32"
        const_set :SDL_SYSTEM_CURSOR_DEFAULT, 0
        const_set :SDL_SYSTEM_CURSOR_TEXT, 1
        const_set :SDL_SYSTEM_CURSOR_WAIT, 2
        const_set :SDL_SYSTEM_CURSOR_CROSSHAIR, 3
        const_set :SDL_SYSTEM_CURSOR_PROGRESS, 4
        const_set :SDL_SYSTEM_CURSOR_NWSE_RESIZE, 5
        const_set :SDL_SYSTEM_CURSOR_NESW_RESIZE, 6
        const_set :SDL_SYSTEM_CURSOR_EW_RESIZE, 7
        const_set :SDL_SYSTEM_CURSOR_NS_RESIZE, 8
        const_set :SDL_SYSTEM_CURSOR_MOVE, 9
        const_set :SDL_SYSTEM_CURSOR_NOT_ALLOWED, 10
        const_set :SDL_SYSTEM_CURSOR_POINTER, 11
        const_set :SDL_SYSTEM_CURSOR_NW_RESIZE, 12
        const_set :SDL_SYSTEM_CURSOR_N_RESIZE, 13
        const_set :SDL_SYSTEM_CURSOR_NE_RESIZE, 14
        const_set :SDL_SYSTEM_CURSOR_E_RESIZE, 15
        const_set :SDL_SYSTEM_CURSOR_SE_RESIZE, 16
        const_set :SDL_SYSTEM_CURSOR_S_RESIZE, 17
        const_set :SDL_SYSTEM_CURSOR_SW_RESIZE, 18
        const_set :SDL_SYSTEM_CURSOR_W_RESIZE, 19
        const_set :SDL_SYSTEM_CURSOR_COUNT, 20
        typealias "SDL_SystemCursor", "enum"
        const_set :SDL_MOUSEWHEEL_NORMAL, 0
        const_set :SDL_MOUSEWHEEL_FLIPPED, 1
        typealias "SDL_MouseWheelDirection", "enum"
        typealias "SDL_MouseButtonFlags", "Uint32"
        extern "bool SDL_HasMouse(void)"
        extern "SDL_MouseID * SDL_GetMice(int *)"
        extern "char * SDL_GetMouseNameForID(SDL_MouseID)"
        extern "SDL_Window * SDL_GetMouseFocus(void)"
        extern "SDL_MouseButtonFlags SDL_GetMouseState(float *, float *)"
        extern "SDL_MouseButtonFlags SDL_GetGlobalMouseState(float *, float *)"
        extern "SDL_MouseButtonFlags SDL_GetRelativeMouseState(float *, float *)"
        extern "void SDL_WarpMouseInWindow(SDL_Window *, float, float)"
        extern "bool SDL_WarpMouseGlobal(float, float)"
        extern "bool SDL_SetWindowRelativeMouseMode(SDL_Window *, bool)"
        extern "bool SDL_GetWindowRelativeMouseMode(SDL_Window *)"
        extern "bool SDL_CaptureMouse(bool)"
        extern "SDL_Cursor * SDL_CreateCursor(Uint8 *, Uint8 *, int, int, int, int)"
        extern "SDL_Cursor * SDL_CreateColorCursor(SDL_Surface *, int, int)"
        extern "SDL_Cursor * SDL_CreateSystemCursor(SDL_SystemCursor)"
        extern "bool SDL_SetCursor(SDL_Cursor *)"
        extern "SDL_Cursor * SDL_GetCursor(void)"
        extern "SDL_Cursor * SDL_GetDefaultCursor(void)"
        extern "void SDL_DestroyCursor(SDL_Cursor *)"
        extern "bool SDL_ShowCursor(void)"
        extern "bool SDL_HideCursor(void)"
        extern "bool SDL_CursorVisible(void)"
        typealias "SDL_TouchID", "Uint64"
        typealias "SDL_FingerID", "Uint64"
        const_set :SDL_TOUCH_DEVICE_INVALID, 4294967295
        const_set :SDL_TOUCH_DEVICE_DIRECT, 0
        const_set :SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE, 1
        const_set :SDL_TOUCH_DEVICE_INDIRECT_RELATIVE, 2
        typealias "SDL_TouchDeviceType", "enum"
        const_set :SDL_Finger, struct(
          [
            "SDL_FingerID id",
            "float x",
            "float y",
            "float pressure",
          ]
        )
        extern "SDL_TouchID * SDL_GetTouchDevices(int *)"
        extern "char * SDL_GetTouchDeviceName(SDL_TouchID)"
        extern "SDL_TouchDeviceType SDL_GetTouchDeviceType(SDL_TouchID)"
        extern "SDL_Finger ** SDL_GetTouchFingers(SDL_TouchID, int *)"
        typealias "SDL_PenID", "Uint32"
        typealias "SDL_PenInputFlags", "Uint32"
        const_set :SDL_PEN_AXIS_PRESSURE, 0
        const_set :SDL_PEN_AXIS_XTILT, 1
        const_set :SDL_PEN_AXIS_YTILT, 2
        const_set :SDL_PEN_AXIS_DISTANCE, 3
        const_set :SDL_PEN_AXIS_ROTATION, 4
        const_set :SDL_PEN_AXIS_SLIDER, 5
        const_set :SDL_PEN_AXIS_TANGENTIAL_PRESSURE, 6
        const_set :SDL_PEN_AXIS_COUNT, 7
        typealias "SDL_PenAxis", "enum"
        const_set :SDL_EVENT_FIRST, 0
        const_set :SDL_EVENT_QUIT, 256
        const_set :SDL_EVENT_TERMINATING, 257
        const_set :SDL_EVENT_LOW_MEMORY, 258
        const_set :SDL_EVENT_WILL_ENTER_BACKGROUND, 259
        const_set :SDL_EVENT_DID_ENTER_BACKGROUND, 260
        const_set :SDL_EVENT_WILL_ENTER_FOREGROUND, 261
        const_set :SDL_EVENT_DID_ENTER_FOREGROUND, 262
        const_set :SDL_EVENT_LOCALE_CHANGED, 263
        const_set :SDL_EVENT_SYSTEM_THEME_CHANGED, 264
        const_set :SDL_EVENT_DISPLAY_ORIENTATION, 337
        const_set :SDL_EVENT_DISPLAY_ADDED, 338
        const_set :SDL_EVENT_DISPLAY_REMOVED, 339
        const_set :SDL_EVENT_DISPLAY_MOVED, 340
        const_set :SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED, 341
        const_set :SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED, 342
        const_set :SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED, 343
        const_set :SDL_EVENT_DISPLAY_FIRST, 337
        const_set :SDL_EVENT_DISPLAY_LAST, 343
        const_set :SDL_EVENT_WINDOW_SHOWN, 514
        const_set :SDL_EVENT_WINDOW_HIDDEN, 515
        const_set :SDL_EVENT_WINDOW_EXPOSED, 516
        const_set :SDL_EVENT_WINDOW_MOVED, 517
        const_set :SDL_EVENT_WINDOW_RESIZED, 518
        const_set :SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED, 519
        const_set :SDL_EVENT_WINDOW_METAL_VIEW_RESIZED, 520
        const_set :SDL_EVENT_WINDOW_MINIMIZED, 521
        const_set :SDL_EVENT_WINDOW_MAXIMIZED, 522
        const_set :SDL_EVENT_WINDOW_RESTORED, 523
        const_set :SDL_EVENT_WINDOW_MOUSE_ENTER, 524
        const_set :SDL_EVENT_WINDOW_MOUSE_LEAVE, 525
        const_set :SDL_EVENT_WINDOW_FOCUS_GAINED, 526
        const_set :SDL_EVENT_WINDOW_FOCUS_LOST, 527
        const_set :SDL_EVENT_WINDOW_CLOSE_REQUESTED, 528
        const_set :SDL_EVENT_WINDOW_HIT_TEST, 529
        const_set :SDL_EVENT_WINDOW_ICCPROF_CHANGED, 530
        const_set :SDL_EVENT_WINDOW_DISPLAY_CHANGED, 531
        const_set :SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED, 532
        const_set :SDL_EVENT_WINDOW_SAFE_AREA_CHANGED, 533
        const_set :SDL_EVENT_WINDOW_OCCLUDED, 534
        const_set :SDL_EVENT_WINDOW_ENTER_FULLSCREEN, 535
        const_set :SDL_EVENT_WINDOW_LEAVE_FULLSCREEN, 536
        const_set :SDL_EVENT_WINDOW_DESTROYED, 537
        const_set :SDL_EVENT_WINDOW_HDR_STATE_CHANGED, 538
        const_set :SDL_EVENT_WINDOW_FIRST, 514
        const_set :SDL_EVENT_WINDOW_LAST, 538
        const_set :SDL_EVENT_KEY_DOWN, 768
        const_set :SDL_EVENT_KEY_UP, 769
        const_set :SDL_EVENT_TEXT_EDITING, 770
        const_set :SDL_EVENT_TEXT_INPUT, 771
        const_set :SDL_EVENT_KEYMAP_CHANGED, 772
        const_set :SDL_EVENT_KEYBOARD_ADDED, 773
        const_set :SDL_EVENT_KEYBOARD_REMOVED, 774
        const_set :SDL_EVENT_TEXT_EDITING_CANDIDATES, 775
        const_set :SDL_EVENT_MOUSE_MOTION, 1024
        const_set :SDL_EVENT_MOUSE_BUTTON_DOWN, 1025
        const_set :SDL_EVENT_MOUSE_BUTTON_UP, 1026
        const_set :SDL_EVENT_MOUSE_WHEEL, 1027
        const_set :SDL_EVENT_MOUSE_ADDED, 1028
        const_set :SDL_EVENT_MOUSE_REMOVED, 1029
        const_set :SDL_EVENT_JOYSTICK_AXIS_MOTION, 1536
        const_set :SDL_EVENT_JOYSTICK_BALL_MOTION, 1537
        const_set :SDL_EVENT_JOYSTICK_HAT_MOTION, 1538
        const_set :SDL_EVENT_JOYSTICK_BUTTON_DOWN, 1539
        const_set :SDL_EVENT_JOYSTICK_BUTTON_UP, 1540
        const_set :SDL_EVENT_JOYSTICK_ADDED, 1541
        const_set :SDL_EVENT_JOYSTICK_REMOVED, 1542
        const_set :SDL_EVENT_JOYSTICK_BATTERY_UPDATED, 1543
        const_set :SDL_EVENT_JOYSTICK_UPDATE_COMPLETE, 1544
        const_set :SDL_EVENT_GAMEPAD_AXIS_MOTION, 1616
        const_set :SDL_EVENT_GAMEPAD_BUTTON_DOWN, 1617
        const_set :SDL_EVENT_GAMEPAD_BUTTON_UP, 1618
        const_set :SDL_EVENT_GAMEPAD_ADDED, 1619
        const_set :SDL_EVENT_GAMEPAD_REMOVED, 1620
        const_set :SDL_EVENT_GAMEPAD_REMAPPED, 1621
        const_set :SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN, 1622
        const_set :SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION, 1623
        const_set :SDL_EVENT_GAMEPAD_TOUCHPAD_UP, 1624
        const_set :SDL_EVENT_GAMEPAD_SENSOR_UPDATE, 1625
        const_set :SDL_EVENT_GAMEPAD_UPDATE_COMPLETE, 1626
        const_set :SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED, 1627
        const_set :SDL_EVENT_FINGER_DOWN, 1792
        const_set :SDL_EVENT_FINGER_UP, 1793
        const_set :SDL_EVENT_FINGER_MOTION, 1794
        const_set :SDL_EVENT_FINGER_CANCELED, 1795
        const_set :SDL_EVENT_CLIPBOARD_UPDATE, 2304
        const_set :SDL_EVENT_DROP_FILE, 4096
        const_set :SDL_EVENT_DROP_TEXT, 4097
        const_set :SDL_EVENT_DROP_BEGIN, 4098
        const_set :SDL_EVENT_DROP_COMPLETE, 4099
        const_set :SDL_EVENT_DROP_POSITION, 4100
        const_set :SDL_EVENT_AUDIO_DEVICE_ADDED, 4352
        const_set :SDL_EVENT_AUDIO_DEVICE_REMOVED, 4353
        const_set :SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED, 4354
        const_set :SDL_EVENT_SENSOR_UPDATE, 4608
        const_set :SDL_EVENT_PEN_PROXIMITY_IN, 4864
        const_set :SDL_EVENT_PEN_PROXIMITY_OUT, 4865
        const_set :SDL_EVENT_PEN_DOWN, 4866
        const_set :SDL_EVENT_PEN_UP, 4867
        const_set :SDL_EVENT_PEN_BUTTON_DOWN, 4868
        const_set :SDL_EVENT_PEN_BUTTON_UP, 4869
        const_set :SDL_EVENT_PEN_MOTION, 4870
        const_set :SDL_EVENT_PEN_AXIS, 4871
        const_set :SDL_EVENT_CAMERA_DEVICE_ADDED, 5120
        const_set :SDL_EVENT_CAMERA_DEVICE_REMOVED, 5121
        const_set :SDL_EVENT_CAMERA_DEVICE_APPROVED, 5122
        const_set :SDL_EVENT_CAMERA_DEVICE_DENIED, 5123
        const_set :SDL_EVENT_RENDER_TARGETS_RESET, 8192
        const_set :SDL_EVENT_RENDER_DEVICE_RESET, 8193
        const_set :SDL_EVENT_RENDER_DEVICE_LOST, 8194
        const_set :SDL_EVENT_PRIVATE0, 16384
        const_set :SDL_EVENT_PRIVATE1, 16385
        const_set :SDL_EVENT_PRIVATE2, 16386
        const_set :SDL_EVENT_PRIVATE3, 16387
        const_set :SDL_EVENT_POLL_SENTINEL, 32512
        const_set :SDL_EVENT_USER, 32768
        const_set :SDL_EVENT_LAST, 65535
        const_set :SDL_EVENT_ENUM_PADDING, 2147483647
        typealias "SDL_EventType", "enum"
        const_set :SDL_CommonEvent, struct(
          [
            "Uint32 type",
            "Uint32 reserved",
            "Uint64 timestamp",
          ]
        )
        const_set :SDL_DisplayEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_DisplayID displayID",
            "Sint32 data1",
            "Sint32 data2",
          ]
        )
        const_set :SDL_WindowEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "Sint32 data1",
            "Sint32 data2",
          ]
        )
        const_set :SDL_KeyboardDeviceEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_KeyboardID which",
          ]
        )
        const_set :SDL_KeyboardEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_KeyboardID which",
            "SDL_Scancode scancode",
            "SDL_Keycode key",
            "SDL_Keymod mod",
            "Uint16 raw",
            "bool down",
            "bool repeat",
          ]
        )
        const_set :SDL_TextEditingEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "char * text",
            "Sint32 start",
            "Sint32 length",
          ]
        )
        const_set :SDL_TextEditingCandidatesEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "char ** candidates",
            "Sint32 num_candidates",
            "Sint32 selected_candidate",
            "bool horizontal",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        const_set :SDL_TextInputEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "char * text",
          ]
        )
        const_set :SDL_MouseDeviceEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_MouseID which",
          ]
        )
        const_set :SDL_MouseMotionEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_MouseID which",
            "SDL_MouseButtonFlags state",
            "float x",
            "float y",
            "float xrel",
            "float yrel",
          ]
        )
        const_set :SDL_MouseButtonEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_MouseID which",
            "Uint8 button",
            "bool down",
            "Uint8 clicks",
            "Uint8 padding",
            "float x",
            "float y",
          ]
        )
        const_set :SDL_MouseWheelEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_MouseID which",
            "float x",
            "float y",
            "SDL_MouseWheelDirection direction",
            "float mouse_x",
            "float mouse_y",
            "Sint32 integer_x",
            "Sint32 integer_y",
          ]
        )
        const_set :SDL_JoyAxisEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Uint8 axis",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
            "Sint16 value",
            "Uint16 padding4",
          ]
        )
        const_set :SDL_JoyBallEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Uint8 ball",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
            "Sint16 xrel",
            "Sint16 yrel",
          ]
        )
        const_set :SDL_JoyHatEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Uint8 hat",
            "Uint8 value",
            "Uint8 padding1",
            "Uint8 padding2",
          ]
        )
        const_set :SDL_JoyButtonEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Uint8 button",
            "bool down",
            "Uint8 padding1",
            "Uint8 padding2",
          ]
        )
        const_set :SDL_JoyDeviceEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
          ]
        )
        const_set :SDL_JoyBatteryEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "SDL_PowerState state",
            "int percent",
          ]
        )
        const_set :SDL_GamepadAxisEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Uint8 axis",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
            "Sint16 value",
            "Uint16 padding4",
          ]
        )
        const_set :SDL_GamepadButtonEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Uint8 button",
            "bool down",
            "Uint8 padding1",
            "Uint8 padding2",
          ]
        )
        const_set :SDL_GamepadDeviceEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
          ]
        )
        const_set :SDL_GamepadTouchpadEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Sint32 touchpad",
            "Sint32 finger",
            "float x",
            "float y",
            "float pressure",
          ]
        )
        const_set :SDL_GamepadSensorEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_JoystickID which",
            "Sint32 sensor",
            "float data[3]",
            "Uint64 sensor_timestamp",
          ]
        )
        const_set :SDL_AudioDeviceEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_AudioDeviceID which",
            "bool recording",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        const_set :SDL_CameraDeviceEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_CameraID which",
          ]
        )
        const_set :SDL_RenderEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
          ]
        )
        const_set :SDL_TouchFingerEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_TouchID touchID",
            "SDL_FingerID fingerID",
            "float x",
            "float y",
            "float dx",
            "float dy",
            "float pressure",
            "SDL_WindowID windowID",
          ]
        )
        const_set :SDL_PenProximityEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_PenID which",
          ]
        )
        const_set :SDL_PenMotionEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_PenID which",
            "SDL_PenInputFlags pen_state",
            "float x",
            "float y",
          ]
        )
        const_set :SDL_PenTouchEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_PenID which",
            "SDL_PenInputFlags pen_state",
            "float x",
            "float y",
            "bool eraser",
            "bool down",
          ]
        )
        const_set :SDL_PenButtonEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_PenID which",
            "SDL_PenInputFlags pen_state",
            "float x",
            "float y",
            "Uint8 button",
            "bool down",
          ]
        )
        const_set :SDL_PenAxisEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "SDL_PenID which",
            "SDL_PenInputFlags pen_state",
            "float x",
            "float y",
            "SDL_PenAxis axis",
            "float value",
          ]
        )
        const_set :SDL_DropEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "float x",
            "float y",
            "char * source",
            "char * data",
          ]
        )
        const_set :SDL_ClipboardEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "bool owner",
            "Sint32 num_mime_types",
            "char ** mime_types",
          ]
        )
        const_set :SDL_SensorEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_SensorID which",
            "float data[6]",
            "Uint64 sensor_timestamp",
          ]
        )
        const_set :SDL_QuitEvent, struct(
          [
            "SDL_EventType type",
            "Uint32 reserved",
            "Uint64 timestamp",
          ]
        )
        const_set :SDL_UserEvent, struct(
          [
            "Uint32 type",
            "Uint32 reserved",
            "Uint64 timestamp",
            "SDL_WindowID windowID",
            "Sint32 code",
            "void * data1",
            "void * data2",
          ]
        )
        const_set :SDL_Event, union(
          [
            "Uint32 type",
            { "common": SDL_CommonEvent },
            { "display": SDL_DisplayEvent },
            { "window": SDL_WindowEvent },
            { "kdevice": SDL_KeyboardDeviceEvent },
            { "key": SDL_KeyboardEvent },
            { "edit": SDL_TextEditingEvent },
            { "edit_candidates": SDL_TextEditingCandidatesEvent },
            { "text": SDL_TextInputEvent },
            { "mdevice": SDL_MouseDeviceEvent },
            { "motion": SDL_MouseMotionEvent },
            { "button": SDL_MouseButtonEvent },
            { "wheel": SDL_MouseWheelEvent },
            { "jdevice": SDL_JoyDeviceEvent },
            { "jaxis": SDL_JoyAxisEvent },
            { "jball": SDL_JoyBallEvent },
            { "jhat": SDL_JoyHatEvent },
            { "jbutton": SDL_JoyButtonEvent },
            { "jbattery": SDL_JoyBatteryEvent },
            { "gdevice": SDL_GamepadDeviceEvent },
            { "gaxis": SDL_GamepadAxisEvent },
            { "gbutton": SDL_GamepadButtonEvent },
            { "gtouchpad": SDL_GamepadTouchpadEvent },
            { "gsensor": SDL_GamepadSensorEvent },
            { "adevice": SDL_AudioDeviceEvent },
            { "cdevice": SDL_CameraDeviceEvent },
            { "sensor": SDL_SensorEvent },
            { "quit": SDL_QuitEvent },
            { "user": SDL_UserEvent },
            { "tfinger": SDL_TouchFingerEvent },
            { "pproximity": SDL_PenProximityEvent },
            { "ptouch": SDL_PenTouchEvent },
            { "pmotion": SDL_PenMotionEvent },
            { "pbutton": SDL_PenButtonEvent },
            { "paxis": SDL_PenAxisEvent },
            { "render": SDL_RenderEvent },
            { "drop": SDL_DropEvent },
            { "clipboard": SDL_ClipboardEvent },
            "Uint8 padding[128]",
          ]
        )
        extern "void SDL_PumpEvents(void)"
        const_set :SDL_ADDEVENT, 0
        const_set :SDL_PEEKEVENT, 1
        const_set :SDL_GETEVENT, 2
        typealias "SDL_EventAction", "enum"
        extern "int SDL_PeepEvents(SDL_Event *, int, SDL_EventAction, Uint32, Uint32)"
        extern "bool SDL_HasEvent(Uint32)"
        extern "bool SDL_HasEvents(Uint32, Uint32)"
        extern "void SDL_FlushEvent(Uint32)"
        extern "void SDL_FlushEvents(Uint32, Uint32)"
        extern "bool SDL_PollEvent(SDL_Event *)"
        extern "bool SDL_WaitEvent(SDL_Event *)"
        extern "bool SDL_WaitEventTimeout(SDL_Event *, Sint32)"
        extern "bool SDL_PushEvent(SDL_Event *)"
        typealias "SDL_EventFilter", "function (*pointer)()"
        const_set :SDL_EventFilter, "bool SDL_EventFilter(void *, SDL_Event *)"
        extern "void SDL_SetEventFilter(SDL_EventFilter, void *)"
        extern "bool SDL_GetEventFilter(SDL_EventFilter *, void **)"
        extern "bool SDL_AddEventWatch(SDL_EventFilter, void *)"
        extern "void SDL_RemoveEventWatch(SDL_EventFilter, void *)"
        extern "void SDL_FilterEvents(SDL_EventFilter, void *)"
        extern "void SDL_SetEventEnabled(Uint32, bool)"
        extern "bool SDL_EventEnabled(Uint32)"
        extern "Uint32 SDL_RegisterEvents(int)"
        extern "SDL_Window * SDL_GetWindowFromEvent(SDL_Event *)"
        extern "char * SDL_GetBasePath(void)"
        extern "char * SDL_GetPrefPath(char *, char *)"
        const_set :SDL_FOLDER_HOME, 0
        const_set :SDL_FOLDER_DESKTOP, 1
        const_set :SDL_FOLDER_DOCUMENTS, 2
        const_set :SDL_FOLDER_DOWNLOADS, 3
        const_set :SDL_FOLDER_MUSIC, 4
        const_set :SDL_FOLDER_PICTURES, 5
        const_set :SDL_FOLDER_PUBLICSHARE, 6
        const_set :SDL_FOLDER_SAVEDGAMES, 7
        const_set :SDL_FOLDER_SCREENSHOTS, 8
        const_set :SDL_FOLDER_TEMPLATES, 9
        const_set :SDL_FOLDER_VIDEOS, 10
        const_set :SDL_FOLDER_COUNT, 11
        typealias "SDL_Folder", "enum"
        extern "char * SDL_GetUserFolder(SDL_Folder)"
        const_set :SDL_PATHTYPE_NONE, 0
        const_set :SDL_PATHTYPE_FILE, 1
        const_set :SDL_PATHTYPE_DIRECTORY, 2
        const_set :SDL_PATHTYPE_OTHER, 3
        typealias "SDL_PathType", "enum"
        const_set :SDL_PathInfo, struct(
          [
            "SDL_PathType type",
            "Uint64 size",
            "SDL_Time create_time",
            "SDL_Time modify_time",
            "SDL_Time access_time",
          ]
        )
        typealias "SDL_GlobFlags", "Uint32"
        extern "bool SDL_CreateDirectory(char *)"
        const_set :SDL_ENUM_CONTINUE, 0
        const_set :SDL_ENUM_SUCCESS, 1
        const_set :SDL_ENUM_FAILURE, 2
        typealias "SDL_EnumerationResult", "enum"
        typealias "SDL_EnumerateDirectoryCallback", "function (*pointer)()"
        const_set :SDL_EnumerateDirectoryCallback, "SDL_EnumerationResult SDL_EnumerateDirectoryCallback(void *, char *, char *)"
        extern "bool SDL_EnumerateDirectory(char *, SDL_EnumerateDirectoryCallback, void *)"
        extern "bool SDL_RemovePath(char *)"
        extern "bool SDL_RenamePath(char *, char *)"
        extern "bool SDL_CopyFile(char *, char *)"
        extern "bool SDL_GetPathInfo(char *, SDL_PathInfo *)"
        extern "char ** SDL_GlobDirectory(char *, char *, SDL_GlobFlags, int *)"
        extern "char * SDL_GetCurrentDirectory(void)"
        const_set :SDL_GPU_PRIMITIVETYPE_TRIANGLELIST, 0
        const_set :SDL_GPU_PRIMITIVETYPE_TRIANGLESTRIP, 1
        const_set :SDL_GPU_PRIMITIVETYPE_LINELIST, 2
        const_set :SDL_GPU_PRIMITIVETYPE_LINESTRIP, 3
        const_set :SDL_GPU_PRIMITIVETYPE_POINTLIST, 4
        typealias "SDL_GPUPrimitiveType", "enum"
        const_set :SDL_GPU_LOADOP_LOAD, 0
        const_set :SDL_GPU_LOADOP_CLEAR, 1
        const_set :SDL_GPU_LOADOP_DONT_CARE, 2
        typealias "SDL_GPULoadOp", "enum"
        const_set :SDL_GPU_STOREOP_STORE, 0
        const_set :SDL_GPU_STOREOP_DONT_CARE, 1
        const_set :SDL_GPU_STOREOP_RESOLVE, 2
        const_set :SDL_GPU_STOREOP_RESOLVE_AND_STORE, 3
        typealias "SDL_GPUStoreOp", "enum"
        const_set :SDL_GPU_INDEXELEMENTSIZE_16BIT, 0
        const_set :SDL_GPU_INDEXELEMENTSIZE_32BIT, 1
        typealias "SDL_GPUIndexElementSize", "enum"
        const_set :SDL_GPU_TEXTUREFORMAT_INVALID, 0
        const_set :SDL_GPU_TEXTUREFORMAT_A8_UNORM, 1
        const_set :SDL_GPU_TEXTUREFORMAT_R8_UNORM, 2
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8_UNORM, 3
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM, 4
        const_set :SDL_GPU_TEXTUREFORMAT_R16_UNORM, 5
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16_UNORM, 6
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UNORM, 7
        const_set :SDL_GPU_TEXTUREFORMAT_R10G10B10A2_UNORM, 8
        const_set :SDL_GPU_TEXTUREFORMAT_B5G6R5_UNORM, 9
        const_set :SDL_GPU_TEXTUREFORMAT_B5G5R5A1_UNORM, 10
        const_set :SDL_GPU_TEXTUREFORMAT_B4G4R4A4_UNORM, 11
        const_set :SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM, 12
        const_set :SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM, 13
        const_set :SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM, 14
        const_set :SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM, 15
        const_set :SDL_GPU_TEXTUREFORMAT_BC4_R_UNORM, 16
        const_set :SDL_GPU_TEXTUREFORMAT_BC5_RG_UNORM, 17
        const_set :SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM, 18
        const_set :SDL_GPU_TEXTUREFORMAT_BC6H_RGB_FLOAT, 19
        const_set :SDL_GPU_TEXTUREFORMAT_BC6H_RGB_UFLOAT, 20
        const_set :SDL_GPU_TEXTUREFORMAT_R8_SNORM, 21
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8_SNORM, 22
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8B8A8_SNORM, 23
        const_set :SDL_GPU_TEXTUREFORMAT_R16_SNORM, 24
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16_SNORM, 25
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16B16A16_SNORM, 26
        const_set :SDL_GPU_TEXTUREFORMAT_R16_FLOAT, 27
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16_FLOAT, 28
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16B16A16_FLOAT, 29
        const_set :SDL_GPU_TEXTUREFORMAT_R32_FLOAT, 30
        const_set :SDL_GPU_TEXTUREFORMAT_R32G32_FLOAT, 31
        const_set :SDL_GPU_TEXTUREFORMAT_R32G32B32A32_FLOAT, 32
        const_set :SDL_GPU_TEXTUREFORMAT_R11G11B10_UFLOAT, 33
        const_set :SDL_GPU_TEXTUREFORMAT_R8_UINT, 34
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8_UINT, 35
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UINT, 36
        const_set :SDL_GPU_TEXTUREFORMAT_R16_UINT, 37
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16_UINT, 38
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UINT, 39
        const_set :SDL_GPU_TEXTUREFORMAT_R32_UINT, 40
        const_set :SDL_GPU_TEXTUREFORMAT_R32G32_UINT, 41
        const_set :SDL_GPU_TEXTUREFORMAT_R32G32B32A32_UINT, 42
        const_set :SDL_GPU_TEXTUREFORMAT_R8_INT, 43
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8_INT, 44
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8B8A8_INT, 45
        const_set :SDL_GPU_TEXTUREFORMAT_R16_INT, 46
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16_INT, 47
        const_set :SDL_GPU_TEXTUREFORMAT_R16G16B16A16_INT, 48
        const_set :SDL_GPU_TEXTUREFORMAT_R32_INT, 49
        const_set :SDL_GPU_TEXTUREFORMAT_R32G32_INT, 50
        const_set :SDL_GPU_TEXTUREFORMAT_R32G32B32A32_INT, 51
        const_set :SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM_SRGB, 52
        const_set :SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM_SRGB, 53
        const_set :SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM_SRGB, 54
        const_set :SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM_SRGB, 55
        const_set :SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM_SRGB, 56
        const_set :SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM_SRGB, 57
        const_set :SDL_GPU_TEXTUREFORMAT_D16_UNORM, 58
        const_set :SDL_GPU_TEXTUREFORMAT_D24_UNORM, 59
        const_set :SDL_GPU_TEXTUREFORMAT_D32_FLOAT, 60
        const_set :SDL_GPU_TEXTUREFORMAT_D24_UNORM_S8_UINT, 61
        const_set :SDL_GPU_TEXTUREFORMAT_D32_FLOAT_S8_UINT, 62
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM, 63
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM, 64
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM, 65
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM, 66
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM, 67
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM, 68
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM, 69
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM, 70
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM, 71
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM, 72
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM, 73
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM, 74
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM, 75
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM, 76
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB, 77
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB, 78
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB, 79
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB, 80
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB, 81
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB, 82
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB, 83
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB, 84
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB, 85
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB, 86
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB, 87
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB, 88
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB, 89
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB, 90
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT, 91
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT, 92
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT, 93
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT, 94
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT, 95
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT, 96
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT, 97
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT, 98
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT, 99
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT, 100
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT, 101
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT, 102
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT, 103
        const_set :SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT, 104
        typealias "SDL_GPUTextureFormat", "enum"
        typealias "SDL_GPUTextureUsageFlags", "Uint32"
        const_set :SDL_GPU_TEXTURETYPE_2D, 0
        const_set :SDL_GPU_TEXTURETYPE_2D_ARRAY, 1
        const_set :SDL_GPU_TEXTURETYPE_3D, 2
        const_set :SDL_GPU_TEXTURETYPE_CUBE, 3
        const_set :SDL_GPU_TEXTURETYPE_CUBE_ARRAY, 4
        typealias "SDL_GPUTextureType", "enum"
        const_set :SDL_GPU_SAMPLECOUNT_1, 0
        const_set :SDL_GPU_SAMPLECOUNT_2, 1
        const_set :SDL_GPU_SAMPLECOUNT_4, 2
        const_set :SDL_GPU_SAMPLECOUNT_8, 3
        typealias "SDL_GPUSampleCount", "enum"
        const_set :SDL_GPU_CUBEMAPFACE_POSITIVEX, 0
        const_set :SDL_GPU_CUBEMAPFACE_NEGATIVEX, 1
        const_set :SDL_GPU_CUBEMAPFACE_POSITIVEY, 2
        const_set :SDL_GPU_CUBEMAPFACE_NEGATIVEY, 3
        const_set :SDL_GPU_CUBEMAPFACE_POSITIVEZ, 4
        const_set :SDL_GPU_CUBEMAPFACE_NEGATIVEZ, 5
        typealias "SDL_GPUCubeMapFace", "enum"
        typealias "SDL_GPUBufferUsageFlags", "Uint32"
        const_set :SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD, 0
        const_set :SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD, 1
        typealias "SDL_GPUTransferBufferUsage", "enum"
        const_set :SDL_GPU_SHADERSTAGE_VERTEX, 0
        const_set :SDL_GPU_SHADERSTAGE_FRAGMENT, 1
        typealias "SDL_GPUShaderStage", "enum"
        typealias "SDL_GPUShaderFormat", "Uint32"
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_INVALID, 0
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_INT, 1
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_INT2, 2
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_INT3, 3
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_INT4, 4
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UINT, 5
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UINT2, 6
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UINT3, 7
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UINT4, 8
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_FLOAT, 9
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2, 10
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3, 11
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4, 12
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_BYTE2, 13
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_BYTE4, 14
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2, 15
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4, 16
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_BYTE2_NORM, 17
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_BYTE4_NORM, 18
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2_NORM, 19
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4_NORM, 20
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_SHORT2, 21
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_SHORT4, 22
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_USHORT2, 23
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_USHORT4, 24
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_SHORT2_NORM, 25
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_SHORT4_NORM, 26
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_USHORT2_NORM, 27
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_USHORT4_NORM, 28
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_HALF2, 29
        const_set :SDL_GPU_VERTEXELEMENTFORMAT_HALF4, 30
        typealias "SDL_GPUVertexElementFormat", "enum"
        const_set :SDL_GPU_VERTEXINPUTRATE_VERTEX, 0
        const_set :SDL_GPU_VERTEXINPUTRATE_INSTANCE, 1
        typealias "SDL_GPUVertexInputRate", "enum"
        const_set :SDL_GPU_FILLMODE_FILL, 0
        const_set :SDL_GPU_FILLMODE_LINE, 1
        typealias "SDL_GPUFillMode", "enum"
        const_set :SDL_GPU_CULLMODE_NONE, 0
        const_set :SDL_GPU_CULLMODE_FRONT, 1
        const_set :SDL_GPU_CULLMODE_BACK, 2
        typealias "SDL_GPUCullMode", "enum"
        const_set :SDL_GPU_FRONTFACE_COUNTER_CLOCKWISE, 0
        const_set :SDL_GPU_FRONTFACE_CLOCKWISE, 1
        typealias "SDL_GPUFrontFace", "enum"
        const_set :SDL_GPU_COMPAREOP_INVALID, 0
        const_set :SDL_GPU_COMPAREOP_NEVER, 1
        const_set :SDL_GPU_COMPAREOP_LESS, 2
        const_set :SDL_GPU_COMPAREOP_EQUAL, 3
        const_set :SDL_GPU_COMPAREOP_LESS_OR_EQUAL, 4
        const_set :SDL_GPU_COMPAREOP_GREATER, 5
        const_set :SDL_GPU_COMPAREOP_NOT_EQUAL, 6
        const_set :SDL_GPU_COMPAREOP_GREATER_OR_EQUAL, 7
        const_set :SDL_GPU_COMPAREOP_ALWAYS, 8
        typealias "SDL_GPUCompareOp", "enum"
        const_set :SDL_GPU_STENCILOP_INVALID, 0
        const_set :SDL_GPU_STENCILOP_KEEP, 1
        const_set :SDL_GPU_STENCILOP_ZERO, 2
        const_set :SDL_GPU_STENCILOP_REPLACE, 3
        const_set :SDL_GPU_STENCILOP_INCREMENT_AND_CLAMP, 4
        const_set :SDL_GPU_STENCILOP_DECREMENT_AND_CLAMP, 5
        const_set :SDL_GPU_STENCILOP_INVERT, 6
        const_set :SDL_GPU_STENCILOP_INCREMENT_AND_WRAP, 7
        const_set :SDL_GPU_STENCILOP_DECREMENT_AND_WRAP, 8
        typealias "SDL_GPUStencilOp", "enum"
        const_set :SDL_GPU_BLENDOP_INVALID, 0
        const_set :SDL_GPU_BLENDOP_ADD, 1
        const_set :SDL_GPU_BLENDOP_SUBTRACT, 2
        const_set :SDL_GPU_BLENDOP_REVERSE_SUBTRACT, 3
        const_set :SDL_GPU_BLENDOP_MIN, 4
        const_set :SDL_GPU_BLENDOP_MAX, 5
        typealias "SDL_GPUBlendOp", "enum"
        const_set :SDL_GPU_BLENDFACTOR_INVALID, 0
        const_set :SDL_GPU_BLENDFACTOR_ZERO, 1
        const_set :SDL_GPU_BLENDFACTOR_ONE, 2
        const_set :SDL_GPU_BLENDFACTOR_SRC_COLOR, 3
        const_set :SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR, 4
        const_set :SDL_GPU_BLENDFACTOR_DST_COLOR, 5
        const_set :SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR, 6
        const_set :SDL_GPU_BLENDFACTOR_SRC_ALPHA, 7
        const_set :SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA, 8
        const_set :SDL_GPU_BLENDFACTOR_DST_ALPHA, 9
        const_set :SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA, 10
        const_set :SDL_GPU_BLENDFACTOR_CONSTANT_COLOR, 11
        const_set :SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR, 12
        const_set :SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE, 13
        typealias "SDL_GPUBlendFactor", "enum"
        typealias "SDL_GPUColorComponentFlags", "Uint8"
        const_set :SDL_GPU_FILTER_NEAREST, 0
        const_set :SDL_GPU_FILTER_LINEAR, 1
        typealias "SDL_GPUFilter", "enum"
        const_set :SDL_GPU_SAMPLERMIPMAPMODE_NEAREST, 0
        const_set :SDL_GPU_SAMPLERMIPMAPMODE_LINEAR, 1
        typealias "SDL_GPUSamplerMipmapMode", "enum"
        const_set :SDL_GPU_SAMPLERADDRESSMODE_REPEAT, 0
        const_set :SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT, 1
        const_set :SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE, 2
        typealias "SDL_GPUSamplerAddressMode", "enum"
        const_set :SDL_GPU_PRESENTMODE_VSYNC, 0
        const_set :SDL_GPU_PRESENTMODE_IMMEDIATE, 1
        const_set :SDL_GPU_PRESENTMODE_MAILBOX, 2
        typealias "SDL_GPUPresentMode", "enum"
        const_set :SDL_GPU_SWAPCHAINCOMPOSITION_SDR, 0
        const_set :SDL_GPU_SWAPCHAINCOMPOSITION_SDR_LINEAR, 1
        const_set :SDL_GPU_SWAPCHAINCOMPOSITION_HDR_EXTENDED_LINEAR, 2
        const_set :SDL_GPU_SWAPCHAINCOMPOSITION_HDR10_ST2084, 3
        typealias "SDL_GPUSwapchainComposition", "enum"
        const_set :SDL_GPUViewport, struct(
          [
            "float x",
            "float y",
            "float w",
            "float h",
            "float min_depth",
            "float max_depth",
          ]
        )
        const_set :SDL_GPUTextureTransferInfo, struct(
          [
            "SDL_GPUTransferBuffer * transfer_buffer",
            "Uint32 offset",
            "Uint32 pixels_per_row",
            "Uint32 rows_per_layer",
          ]
        )
        const_set :SDL_GPUTransferBufferLocation, struct(
          [
            "SDL_GPUTransferBuffer * transfer_buffer",
            "Uint32 offset",
          ]
        )
        const_set :SDL_GPUTextureLocation, struct(
          [
            "SDL_GPUTexture * texture",
            "Uint32 mip_level",
            "Uint32 layer",
            "Uint32 x",
            "Uint32 y",
            "Uint32 z",
          ]
        )
        const_set :SDL_GPUTextureRegion, struct(
          [
            "SDL_GPUTexture * texture",
            "Uint32 mip_level",
            "Uint32 layer",
            "Uint32 x",
            "Uint32 y",
            "Uint32 z",
            "Uint32 w",
            "Uint32 h",
            "Uint32 d",
          ]
        )
        const_set :SDL_GPUBlitRegion, struct(
          [
            "SDL_GPUTexture * texture",
            "Uint32 mip_level",
            "Uint32 layer_or_depth_plane",
            "Uint32 x",
            "Uint32 y",
            "Uint32 w",
            "Uint32 h",
          ]
        )
        const_set :SDL_GPUBufferLocation, struct(
          [
            "SDL_GPUBuffer * buffer",
            "Uint32 offset",
          ]
        )
        const_set :SDL_GPUBufferRegion, struct(
          [
            "SDL_GPUBuffer * buffer",
            "Uint32 offset",
            "Uint32 size",
          ]
        )
        const_set :SDL_GPUIndirectDrawCommand, struct(
          [
            "Uint32 num_vertices",
            "Uint32 num_instances",
            "Uint32 first_vertex",
            "Uint32 first_instance",
          ]
        )
        const_set :SDL_GPUIndexedIndirectDrawCommand, struct(
          [
            "Uint32 num_indices",
            "Uint32 num_instances",
            "Uint32 first_index",
            "Sint32 vertex_offset",
            "Uint32 first_instance",
          ]
        )
        const_set :SDL_GPUIndirectDispatchCommand, struct(
          [
            "Uint32 groupcount_x",
            "Uint32 groupcount_y",
            "Uint32 groupcount_z",
          ]
        )
        const_set :SDL_GPUSamplerCreateInfo, struct(
          [
            "SDL_GPUFilter min_filter",
            "SDL_GPUFilter mag_filter",
            "SDL_GPUSamplerMipmapMode mipmap_mode",
            "SDL_GPUSamplerAddressMode address_mode_u",
            "SDL_GPUSamplerAddressMode address_mode_v",
            "SDL_GPUSamplerAddressMode address_mode_w",
            "float mip_lod_bias",
            "float max_anisotropy",
            "SDL_GPUCompareOp compare_op",
            "float min_lod",
            "float max_lod",
            "bool enable_anisotropy",
            "bool enable_compare",
            "Uint8 padding1",
            "Uint8 padding2",
            "SDL_PropertiesID props",
          ]
        )
        const_set :SDL_GPUVertexBufferDescription, struct(
          [
            "Uint32 slot",
            "Uint32 pitch",
            "SDL_GPUVertexInputRate input_rate",
            "Uint32 instance_step_rate",
          ]
        )
        const_set :SDL_GPUVertexAttribute, struct(
          [
            "Uint32 location",
            "Uint32 buffer_slot",
            "SDL_GPUVertexElementFormat format",
            "Uint32 offset",
          ]
        )
        const_set :SDL_GPUVertexInputState, struct(
          [
            "SDL_GPUVertexBufferDescription * vertex_buffer_descriptions",
            "Uint32 num_vertex_buffers",
            "SDL_GPUVertexAttribute * vertex_attributes",
            "Uint32 num_vertex_attributes",
          ]
        )
        const_set :SDL_GPUStencilOpState, struct(
          [
            "SDL_GPUStencilOp fail_op",
            "SDL_GPUStencilOp pass_op",
            "SDL_GPUStencilOp depth_fail_op",
            "SDL_GPUCompareOp compare_op",
          ]
        )
        const_set :SDL_GPUColorTargetBlendState, struct(
          [
            "SDL_GPUBlendFactor src_color_blendfactor",
            "SDL_GPUBlendFactor dst_color_blendfactor",
            "SDL_GPUBlendOp color_blend_op",
            "SDL_GPUBlendFactor src_alpha_blendfactor",
            "SDL_GPUBlendFactor dst_alpha_blendfactor",
            "SDL_GPUBlendOp alpha_blend_op",
            "SDL_GPUColorComponentFlags color_write_mask",
            "bool enable_blend",
            "bool enable_color_write_mask",
            "Uint8 padding1",
            "Uint8 padding2",
          ]
        )
        const_set :SDL_GPUShaderCreateInfo, struct(
          [
            "size_t code_size",
            "Uint8 * code",
            "char * entrypoint",
            "SDL_GPUShaderFormat format",
            "SDL_GPUShaderStage stage",
            "Uint32 num_samplers",
            "Uint32 num_storage_textures",
            "Uint32 num_storage_buffers",
            "Uint32 num_uniform_buffers",
            "SDL_PropertiesID props",
          ]
        )
        const_set :SDL_GPUTextureCreateInfo, struct(
          [
            "SDL_GPUTextureType type",
            "SDL_GPUTextureFormat format",
            "SDL_GPUTextureUsageFlags usage",
            "Uint32 width",
            "Uint32 height",
            "Uint32 layer_count_or_depth",
            "Uint32 num_levels",
            "SDL_GPUSampleCount sample_count",
            "SDL_PropertiesID props",
          ]
        )
        const_set :SDL_GPUBufferCreateInfo, struct(
          [
            "SDL_GPUBufferUsageFlags usage",
            "Uint32 size",
            "SDL_PropertiesID props",
          ]
        )
        const_set :SDL_GPUTransferBufferCreateInfo, struct(
          [
            "SDL_GPUTransferBufferUsage usage",
            "Uint32 size",
            "SDL_PropertiesID props",
          ]
        )
        const_set :SDL_GPURasterizerState, struct(
          [
            "SDL_GPUFillMode fill_mode",
            "SDL_GPUCullMode cull_mode",
            "SDL_GPUFrontFace front_face",
            "float depth_bias_constant_factor",
            "float depth_bias_clamp",
            "float depth_bias_slope_factor",
            "bool enable_depth_bias",
            "bool enable_depth_clip",
            "Uint8 padding1",
            "Uint8 padding2",
          ]
        )
        const_set :SDL_GPUMultisampleState, struct(
          [
            "SDL_GPUSampleCount sample_count",
            "Uint32 sample_mask",
            "bool enable_mask",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        const_set :SDL_GPUDepthStencilState, struct(
          [
            "SDL_GPUCompareOp compare_op",
            { "back_stencil_state": SDL_GPUStencilOpState },
            { "front_stencil_state": SDL_GPUStencilOpState },
            "Uint8 compare_mask",
            "Uint8 write_mask",
            "bool enable_depth_test",
            "bool enable_depth_write",
            "bool enable_stencil_test",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        const_set :SDL_GPUColorTargetDescription, struct(
          [
            "SDL_GPUTextureFormat format",
            { "blend_state": SDL_GPUColorTargetBlendState },
          ]
        )
        const_set :SDL_GPUGraphicsPipelineTargetInfo, struct(
          [
            "SDL_GPUColorTargetDescription * color_target_descriptions",
            "Uint32 num_color_targets",
            "SDL_GPUTextureFormat depth_stencil_format",
            "bool has_depth_stencil_target",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        const_set :SDL_GPUGraphicsPipelineCreateInfo, struct(
          [
            "SDL_GPUShader * vertex_shader",
            "SDL_GPUShader * fragment_shader",
            { "vertex_input_state": SDL_GPUVertexInputState },
            "SDL_GPUPrimitiveType primitive_type",
            { "rasterizer_state": SDL_GPURasterizerState },
            { "multisample_state": SDL_GPUMultisampleState },
            { "depth_stencil_state": SDL_GPUDepthStencilState },
            { "target_info": SDL_GPUGraphicsPipelineTargetInfo },
            "SDL_PropertiesID props",
          ]
        )
        const_set :SDL_GPUComputePipelineCreateInfo, struct(
          [
            "size_t code_size",
            "Uint8 * code",
            "char * entrypoint",
            "SDL_GPUShaderFormat format",
            "Uint32 num_samplers",
            "Uint32 num_readonly_storage_textures",
            "Uint32 num_readonly_storage_buffers",
            "Uint32 num_readwrite_storage_textures",
            "Uint32 num_readwrite_storage_buffers",
            "Uint32 num_uniform_buffers",
            "Uint32 threadcount_x",
            "Uint32 threadcount_y",
            "Uint32 threadcount_z",
            "SDL_PropertiesID props",
          ]
        )
        const_set :SDL_GPUColorTargetInfo, struct(
          [
            "SDL_GPUTexture * texture",
            "Uint32 mip_level",
            "Uint32 layer_or_depth_plane",
            { "clear_color": SDL_FColor },
            "SDL_GPULoadOp load_op",
            "SDL_GPUStoreOp store_op",
            "SDL_GPUTexture * resolve_texture",
            "Uint32 resolve_mip_level",
            "Uint32 resolve_layer",
            "bool cycle",
            "bool cycle_resolve_texture",
            "Uint8 padding1",
            "Uint8 padding2",
          ]
        )
        const_set :SDL_GPUDepthStencilTargetInfo, struct(
          [
            "SDL_GPUTexture * texture",
            "float clear_depth",
            "SDL_GPULoadOp load_op",
            "SDL_GPUStoreOp store_op",
            "SDL_GPULoadOp stencil_load_op",
            "SDL_GPUStoreOp stencil_store_op",
            "bool cycle",
            "Uint8 clear_stencil",
            "Uint8 padding1",
            "Uint8 padding2",
          ]
        )
        const_set :SDL_GPUBlitInfo, struct(
          [
            { "source": SDL_GPUBlitRegion },
            { "destination": SDL_GPUBlitRegion },
            "SDL_GPULoadOp load_op",
            { "clear_color": SDL_FColor },
            "SDL_FlipMode flip_mode",
            "SDL_GPUFilter filter",
            "bool cycle",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        const_set :SDL_GPUBufferBinding, struct(
          [
            "SDL_GPUBuffer * buffer",
            "Uint32 offset",
          ]
        )
        const_set :SDL_GPUTextureSamplerBinding, struct(
          [
            "SDL_GPUTexture * texture",
            "SDL_GPUSampler * sampler",
          ]
        )
        const_set :SDL_GPUStorageBufferReadWriteBinding, struct(
          [
            "SDL_GPUBuffer * buffer",
            "bool cycle",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        const_set :SDL_GPUStorageTextureReadWriteBinding, struct(
          [
            "SDL_GPUTexture * texture",
            "Uint32 mip_level",
            "Uint32 layer",
            "bool cycle",
            "Uint8 padding1",
            "Uint8 padding2",
            "Uint8 padding3",
          ]
        )
        extern "bool SDL_GPUSupportsShaderFormats(SDL_GPUShaderFormat, char *)"
        extern "bool SDL_GPUSupportsProperties(SDL_PropertiesID)"
        extern "SDL_GPUDevice * SDL_CreateGPUDevice(SDL_GPUShaderFormat, bool, char *)"
        extern "SDL_GPUDevice * SDL_CreateGPUDeviceWithProperties(SDL_PropertiesID)"
        extern "void SDL_DestroyGPUDevice(SDL_GPUDevice *)"
        extern "int SDL_GetNumGPUDrivers(void)"
        extern "char * SDL_GetGPUDriver(int)"
        extern "char * SDL_GetGPUDeviceDriver(SDL_GPUDevice *)"
        extern "SDL_GPUShaderFormat SDL_GetGPUShaderFormats(SDL_GPUDevice *)"
        extern "SDL_GPUComputePipeline * SDL_CreateGPUComputePipeline(SDL_GPUDevice *, SDL_GPUComputePipelineCreateInfo *)"
        extern "SDL_GPUGraphicsPipeline * SDL_CreateGPUGraphicsPipeline(SDL_GPUDevice *, SDL_GPUGraphicsPipelineCreateInfo *)"
        extern "SDL_GPUSampler * SDL_CreateGPUSampler(SDL_GPUDevice *, SDL_GPUSamplerCreateInfo *)"
        extern "SDL_GPUShader * SDL_CreateGPUShader(SDL_GPUDevice *, SDL_GPUShaderCreateInfo *)"
        extern "SDL_GPUTexture * SDL_CreateGPUTexture(SDL_GPUDevice *, SDL_GPUTextureCreateInfo *)"
        extern "SDL_GPUBuffer * SDL_CreateGPUBuffer(SDL_GPUDevice *, SDL_GPUBufferCreateInfo *)"
        extern "SDL_GPUTransferBuffer * SDL_CreateGPUTransferBuffer(SDL_GPUDevice *, SDL_GPUTransferBufferCreateInfo *)"
        extern "void SDL_SetGPUBufferName(SDL_GPUDevice *, SDL_GPUBuffer *, char *)"
        extern "void SDL_SetGPUTextureName(SDL_GPUDevice *, SDL_GPUTexture *, char *)"
        extern "void SDL_InsertGPUDebugLabel(SDL_GPUCommandBuffer *, char *)"
        extern "void SDL_PushGPUDebugGroup(SDL_GPUCommandBuffer *, char *)"
        extern "void SDL_PopGPUDebugGroup(SDL_GPUCommandBuffer *)"
        extern "void SDL_ReleaseGPUTexture(SDL_GPUDevice *, SDL_GPUTexture *)"
        extern "void SDL_ReleaseGPUSampler(SDL_GPUDevice *, SDL_GPUSampler *)"
        extern "void SDL_ReleaseGPUBuffer(SDL_GPUDevice *, SDL_GPUBuffer *)"
        extern "void SDL_ReleaseGPUTransferBuffer(SDL_GPUDevice *, SDL_GPUTransferBuffer *)"
        extern "void SDL_ReleaseGPUComputePipeline(SDL_GPUDevice *, SDL_GPUComputePipeline *)"
        extern "void SDL_ReleaseGPUShader(SDL_GPUDevice *, SDL_GPUShader *)"
        extern "void SDL_ReleaseGPUGraphicsPipeline(SDL_GPUDevice *, SDL_GPUGraphicsPipeline *)"
        extern "SDL_GPUCommandBuffer * SDL_AcquireGPUCommandBuffer(SDL_GPUDevice *)"
        extern "void SDL_PushGPUVertexUniformData(SDL_GPUCommandBuffer *, Uint32, void *, Uint32)"
        extern "void SDL_PushGPUFragmentUniformData(SDL_GPUCommandBuffer *, Uint32, void *, Uint32)"
        extern "void SDL_PushGPUComputeUniformData(SDL_GPUCommandBuffer *, Uint32, void *, Uint32)"
        extern "SDL_GPURenderPass * SDL_BeginGPURenderPass(SDL_GPUCommandBuffer *, SDL_GPUColorTargetInfo *, Uint32, SDL_GPUDepthStencilTargetInfo *)"
        extern "void SDL_BindGPUGraphicsPipeline(SDL_GPURenderPass *, SDL_GPUGraphicsPipeline *)"
        extern "void SDL_SetGPUViewport(SDL_GPURenderPass *, SDL_GPUViewport *)"
        extern "void SDL_SetGPUScissor(SDL_GPURenderPass *, SDL_Rect *)"
        extern "void SDL_SetGPUStencilReference(SDL_GPURenderPass *, Uint8)"
        extern "void SDL_BindGPUVertexBuffers(SDL_GPURenderPass *, Uint32, SDL_GPUBufferBinding *, Uint32)"
        extern "void SDL_BindGPUIndexBuffer(SDL_GPURenderPass *, SDL_GPUBufferBinding *, SDL_GPUIndexElementSize)"
        extern "void SDL_BindGPUVertexSamplers(SDL_GPURenderPass *, Uint32, SDL_GPUTextureSamplerBinding *, Uint32)"
        extern "void SDL_BindGPUVertexStorageTextures(SDL_GPURenderPass *, Uint32, SDL_GPUTexture **, Uint32)"
        extern "void SDL_BindGPUVertexStorageBuffers(SDL_GPURenderPass *, Uint32, SDL_GPUBuffer **, Uint32)"
        extern "void SDL_BindGPUFragmentSamplers(SDL_GPURenderPass *, Uint32, SDL_GPUTextureSamplerBinding *, Uint32)"
        extern "void SDL_BindGPUFragmentStorageTextures(SDL_GPURenderPass *, Uint32, SDL_GPUTexture **, Uint32)"
        extern "void SDL_BindGPUFragmentStorageBuffers(SDL_GPURenderPass *, Uint32, SDL_GPUBuffer **, Uint32)"
        extern "void SDL_DrawGPUIndexedPrimitives(SDL_GPURenderPass *, Uint32, Uint32, Uint32, Sint32, Uint32)"
        extern "void SDL_DrawGPUPrimitives(SDL_GPURenderPass *, Uint32, Uint32, Uint32, Uint32)"
        extern "void SDL_DrawGPUPrimitivesIndirect(SDL_GPURenderPass *, SDL_GPUBuffer *, Uint32, Uint32)"
        extern "void SDL_DrawGPUIndexedPrimitivesIndirect(SDL_GPURenderPass *, SDL_GPUBuffer *, Uint32, Uint32)"
        extern "void SDL_EndGPURenderPass(SDL_GPURenderPass *)"
        extern "SDL_GPUComputePass * SDL_BeginGPUComputePass(SDL_GPUCommandBuffer *, SDL_GPUStorageTextureReadWriteBinding *, Uint32, SDL_GPUStorageBufferReadWriteBinding *, Uint32)"
        extern "void SDL_BindGPUComputePipeline(SDL_GPUComputePass *, SDL_GPUComputePipeline *)"
        extern "void SDL_BindGPUComputeSamplers(SDL_GPUComputePass *, Uint32, SDL_GPUTextureSamplerBinding *, Uint32)"
        extern "void SDL_BindGPUComputeStorageTextures(SDL_GPUComputePass *, Uint32, SDL_GPUTexture **, Uint32)"
        extern "void SDL_BindGPUComputeStorageBuffers(SDL_GPUComputePass *, Uint32, SDL_GPUBuffer **, Uint32)"
        extern "void SDL_DispatchGPUCompute(SDL_GPUComputePass *, Uint32, Uint32, Uint32)"
        extern "void SDL_DispatchGPUComputeIndirect(SDL_GPUComputePass *, SDL_GPUBuffer *, Uint32)"
        extern "void SDL_EndGPUComputePass(SDL_GPUComputePass *)"
        extern "void * SDL_MapGPUTransferBuffer(SDL_GPUDevice *, SDL_GPUTransferBuffer *, bool)"
        extern "void SDL_UnmapGPUTransferBuffer(SDL_GPUDevice *, SDL_GPUTransferBuffer *)"
        extern "SDL_GPUCopyPass * SDL_BeginGPUCopyPass(SDL_GPUCommandBuffer *)"
        extern "void SDL_UploadToGPUTexture(SDL_GPUCopyPass *, SDL_GPUTextureTransferInfo *, SDL_GPUTextureRegion *, bool)"
        extern "void SDL_UploadToGPUBuffer(SDL_GPUCopyPass *, SDL_GPUTransferBufferLocation *, SDL_GPUBufferRegion *, bool)"
        extern "void SDL_CopyGPUTextureToTexture(SDL_GPUCopyPass *, SDL_GPUTextureLocation *, SDL_GPUTextureLocation *, Uint32, Uint32, Uint32, bool)"
        extern "void SDL_CopyGPUBufferToBuffer(SDL_GPUCopyPass *, SDL_GPUBufferLocation *, SDL_GPUBufferLocation *, Uint32, bool)"
        extern "void SDL_DownloadFromGPUTexture(SDL_GPUCopyPass *, SDL_GPUTextureRegion *, SDL_GPUTextureTransferInfo *)"
        extern "void SDL_DownloadFromGPUBuffer(SDL_GPUCopyPass *, SDL_GPUBufferRegion *, SDL_GPUTransferBufferLocation *)"
        extern "void SDL_EndGPUCopyPass(SDL_GPUCopyPass *)"
        extern "void SDL_GenerateMipmapsForGPUTexture(SDL_GPUCommandBuffer *, SDL_GPUTexture *)"
        extern "void SDL_BlitGPUTexture(SDL_GPUCommandBuffer *, SDL_GPUBlitInfo *)"
        extern "bool SDL_WindowSupportsGPUSwapchainComposition(SDL_GPUDevice *, SDL_Window *, SDL_GPUSwapchainComposition)"
        extern "bool SDL_WindowSupportsGPUPresentMode(SDL_GPUDevice *, SDL_Window *, SDL_GPUPresentMode)"
        extern "bool SDL_ClaimWindowForGPUDevice(SDL_GPUDevice *, SDL_Window *)"
        extern "void SDL_ReleaseWindowFromGPUDevice(SDL_GPUDevice *, SDL_Window *)"
        extern "bool SDL_SetGPUSwapchainParameters(SDL_GPUDevice *, SDL_Window *, SDL_GPUSwapchainComposition, SDL_GPUPresentMode)"
        extern "bool SDL_SetGPUAllowedFramesInFlight(SDL_GPUDevice *, Uint32)"
        extern "SDL_GPUTextureFormat SDL_GetGPUSwapchainTextureFormat(SDL_GPUDevice *, SDL_Window *)"
        extern "bool SDL_AcquireGPUSwapchainTexture(SDL_GPUCommandBuffer *, SDL_Window *, SDL_GPUTexture **, Uint32 *, Uint32 *)"
        extern "bool SDL_WaitForGPUSwapchain(SDL_GPUDevice *, SDL_Window *)"
        extern "bool SDL_WaitAndAcquireGPUSwapchainTexture(SDL_GPUCommandBuffer *, SDL_Window *, SDL_GPUTexture **, Uint32 *, Uint32 *)"
        extern "bool SDL_SubmitGPUCommandBuffer(SDL_GPUCommandBuffer *)"
        extern "SDL_GPUFence * SDL_SubmitGPUCommandBufferAndAcquireFence(SDL_GPUCommandBuffer *)"
        extern "bool SDL_CancelGPUCommandBuffer(SDL_GPUCommandBuffer *)"
        extern "bool SDL_WaitForGPUIdle(SDL_GPUDevice *)"
        extern "bool SDL_WaitForGPUFences(SDL_GPUDevice *, bool, SDL_GPUFence **, Uint32)"
        extern "bool SDL_QueryGPUFence(SDL_GPUDevice *, SDL_GPUFence *)"
        extern "void SDL_ReleaseGPUFence(SDL_GPUDevice *, SDL_GPUFence *)"
        extern "Uint32 SDL_GPUTextureFormatTexelBlockSize(SDL_GPUTextureFormat)"
        extern "bool SDL_GPUTextureSupportsFormat(SDL_GPUDevice *, SDL_GPUTextureFormat, SDL_GPUTextureType, SDL_GPUTextureUsageFlags)"
        extern "bool SDL_GPUTextureSupportsSampleCount(SDL_GPUDevice *, SDL_GPUTextureFormat, SDL_GPUSampleCount)"
        extern "Uint32 SDL_CalculateGPUTextureFormatSize(SDL_GPUTextureFormat, Uint32, Uint32, Uint32)"
        const_set :SDL_HapticDirection, struct(
          [
            "Uint8 type",
            "Sint32 dir[3]",
          ]
        )
        const_set :SDL_HapticConstant, struct(
          [
            "Uint16 type",
            { "direction": SDL_HapticDirection },
            "Uint32 length",
            "Uint16 delay",
            "Uint16 button",
            "Uint16 interval",
            "Sint16 level",
            "Uint16 attack_length",
            "Uint16 attack_level",
            "Uint16 fade_length",
            "Uint16 fade_level",
          ]
        )
        const_set :SDL_HapticPeriodic, struct(
          [
            "Uint16 type",
            { "direction": SDL_HapticDirection },
            "Uint32 length",
            "Uint16 delay",
            "Uint16 button",
            "Uint16 interval",
            "Uint16 period",
            "Sint16 magnitude",
            "Sint16 offset",
            "Uint16 phase",
            "Uint16 attack_length",
            "Uint16 attack_level",
            "Uint16 fade_length",
            "Uint16 fade_level",
          ]
        )
        const_set :SDL_HapticCondition, struct(
          [
            "Uint16 type",
            { "direction": SDL_HapticDirection },
            "Uint32 length",
            "Uint16 delay",
            "Uint16 button",
            "Uint16 interval",
            "Uint16 right_sat[3]",
            "Uint16 left_sat[3]",
            "Sint16 right_coeff[3]",
            "Sint16 left_coeff[3]",
            "Uint16 deadband[3]",
            "Sint16 center[3]",
          ]
        )
        const_set :SDL_HapticRamp, struct(
          [
            "Uint16 type",
            { "direction": SDL_HapticDirection },
            "Uint32 length",
            "Uint16 delay",
            "Uint16 button",
            "Uint16 interval",
            "Sint16 start",
            "Sint16 end",
            "Uint16 attack_length",
            "Uint16 attack_level",
            "Uint16 fade_length",
            "Uint16 fade_level",
          ]
        )
        const_set :SDL_HapticLeftRight, struct(
          [
            "Uint16 type",
            "Uint32 length",
            "Uint16 large_magnitude",
            "Uint16 small_magnitude",
          ]
        )
        const_set :SDL_HapticCustom, struct(
          [
            "Uint16 type",
            { "direction": SDL_HapticDirection },
            "Uint32 length",
            "Uint16 delay",
            "Uint16 button",
            "Uint16 interval",
            "Uint8 channels",
            "Uint16 period",
            "Uint16 samples",
            "Uint16 * data",
            "Uint16 attack_length",
            "Uint16 attack_level",
            "Uint16 fade_length",
            "Uint16 fade_level",
          ]
        )
        const_set :SDL_HapticEffect, union(
          [
            "Uint16 type",
            { "constant": SDL_HapticConstant },
            { "periodic": SDL_HapticPeriodic },
            { "condition": SDL_HapticCondition },
            { "ramp": SDL_HapticRamp },
            { "leftright": SDL_HapticLeftRight },
            { "custom": SDL_HapticCustom },
          ]
        )
        typealias "SDL_HapticID", "Uint32"
        extern "SDL_HapticID * SDL_GetHaptics(int *)"
        extern "char * SDL_GetHapticNameForID(SDL_HapticID)"
        extern "SDL_Haptic * SDL_OpenHaptic(SDL_HapticID)"
        extern "SDL_Haptic * SDL_GetHapticFromID(SDL_HapticID)"
        extern "SDL_HapticID SDL_GetHapticID(SDL_Haptic *)"
        extern "char * SDL_GetHapticName(SDL_Haptic *)"
        extern "bool SDL_IsMouseHaptic(void)"
        extern "SDL_Haptic * SDL_OpenHapticFromMouse(void)"
        extern "bool SDL_IsJoystickHaptic(SDL_Joystick *)"
        extern "SDL_Haptic * SDL_OpenHapticFromJoystick(SDL_Joystick *)"
        extern "void SDL_CloseHaptic(SDL_Haptic *)"
        extern "int SDL_GetMaxHapticEffects(SDL_Haptic *)"
        extern "int SDL_GetMaxHapticEffectsPlaying(SDL_Haptic *)"
        extern "Uint32 SDL_GetHapticFeatures(SDL_Haptic *)"
        extern "int SDL_GetNumHapticAxes(SDL_Haptic *)"
        extern "bool SDL_HapticEffectSupported(SDL_Haptic *, SDL_HapticEffect *)"
        extern "int SDL_CreateHapticEffect(SDL_Haptic *, SDL_HapticEffect *)"
        extern "bool SDL_UpdateHapticEffect(SDL_Haptic *, int, SDL_HapticEffect *)"
        extern "bool SDL_RunHapticEffect(SDL_Haptic *, int, Uint32)"
        extern "bool SDL_StopHapticEffect(SDL_Haptic *, int)"
        extern "void SDL_DestroyHapticEffect(SDL_Haptic *, int)"
        extern "bool SDL_GetHapticEffectStatus(SDL_Haptic *, int)"
        extern "bool SDL_SetHapticGain(SDL_Haptic *, int)"
        extern "bool SDL_SetHapticAutocenter(SDL_Haptic *, int)"
        extern "bool SDL_PauseHaptic(SDL_Haptic *)"
        extern "bool SDL_ResumeHaptic(SDL_Haptic *)"
        extern "bool SDL_StopHapticEffects(SDL_Haptic *)"
        extern "bool SDL_HapticRumbleSupported(SDL_Haptic *)"
        extern "bool SDL_InitHapticRumble(SDL_Haptic *)"
        extern "bool SDL_PlayHapticRumble(SDL_Haptic *, float, Uint32)"
        extern "bool SDL_StopHapticRumble(SDL_Haptic *)"
        const_set :SDL_HID_API_BUS_UNKNOWN, 0
        const_set :SDL_HID_API_BUS_USB, 1
        const_set :SDL_HID_API_BUS_BLUETOOTH, 2
        const_set :SDL_HID_API_BUS_I2C, 3
        const_set :SDL_HID_API_BUS_SPI, 4
        typealias "SDL_hid_bus_type", "enum"
        const_set :SDL_hid_device_info, struct(
          [
            "char * path",
            "unsigned short vendor_id",
            "unsigned short product_id",
            "wchar_t * serial_number",
            "unsigned short release_number",
            "wchar_t * manufacturer_string",
            "wchar_t * product_string",
            "unsigned short usage_page",
            "unsigned short usage",
            "int interface_number",
            "int interface_class",
            "int interface_subclass",
            "int interface_protocol",
            "SDL_hid_bus_type bus_type",
            "SDL_hid_device_info * next",
          ]
        )
        extern "int SDL_hid_init(void)"
        extern "int SDL_hid_exit(void)"
        extern "Uint32 SDL_hid_device_change_count(void)"
        extern "SDL_hid_device_info * SDL_hid_enumerate(unsigned short, unsigned short)"
        extern "void SDL_hid_free_enumeration(SDL_hid_device_info *)"
        extern "SDL_hid_device * SDL_hid_open(unsigned short, unsigned short, wchar_t *)"
        extern "SDL_hid_device * SDL_hid_open_path(char *)"
        extern "int SDL_hid_write(SDL_hid_device *, unsigned char *, size_t)"
        extern "int SDL_hid_read_timeout(SDL_hid_device *, unsigned char *, size_t, int)"
        extern "int SDL_hid_read(SDL_hid_device *, unsigned char *, size_t)"
        extern "int SDL_hid_set_nonblocking(SDL_hid_device *, int)"
        extern "int SDL_hid_send_feature_report(SDL_hid_device *, unsigned char *, size_t)"
        extern "int SDL_hid_get_feature_report(SDL_hid_device *, unsigned char *, size_t)"
        extern "int SDL_hid_get_input_report(SDL_hid_device *, unsigned char *, size_t)"
        extern "int SDL_hid_close(SDL_hid_device *)"
        extern "int SDL_hid_get_manufacturer_string(SDL_hid_device *, wchar_t *, size_t)"
        extern "int SDL_hid_get_product_string(SDL_hid_device *, wchar_t *, size_t)"
        extern "int SDL_hid_get_serial_number_string(SDL_hid_device *, wchar_t *, size_t)"
        extern "int SDL_hid_get_indexed_string(SDL_hid_device *, int, wchar_t *, size_t)"
        extern "SDL_hid_device_info * SDL_hid_get_device_info(SDL_hid_device *)"
        extern "int SDL_hid_get_report_descriptor(SDL_hid_device *, unsigned char *, size_t)"
        extern "void SDL_hid_ble_scan(bool)"
        const_set :SDL_HINT_DEFAULT, 0
        const_set :SDL_HINT_NORMAL, 1
        const_set :SDL_HINT_OVERRIDE, 2
        typealias "SDL_HintPriority", "enum"
        extern "bool SDL_SetHintWithPriority(char *, char *, SDL_HintPriority)"
        extern "bool SDL_SetHint(char *, char *)"
        extern "bool SDL_ResetHint(char *)"
        extern "void SDL_ResetHints(void)"
        extern "char * SDL_GetHint(char *)"
        extern "bool SDL_GetHintBoolean(char *, bool)"
        typealias "SDL_HintCallback", "function (*pointer)()"
        const_set :SDL_HintCallback, "void SDL_HintCallback(void *, char *, char *, char *)"
        extern "bool SDL_AddHintCallback(char *, SDL_HintCallback, void *)"
        extern "void SDL_RemoveHintCallback(char *, SDL_HintCallback, void *)"
        typealias "SDL_InitFlags", "Uint32"
        const_set :SDL_APP_CONTINUE, 0
        const_set :SDL_APP_SUCCESS, 1
        const_set :SDL_APP_FAILURE, 2
        typealias "SDL_AppResult", "enum"
        typealias "SDL_AppInit_func", "function (*pointer)()"
        const_set :SDL_AppInit_func, "SDL_AppResult SDL_AppInit_func(void **, int, char **)"
        typealias "SDL_AppIterate_func", "function (*pointer)()"
        const_set :SDL_AppIterate_func, "SDL_AppResult SDL_AppIterate_func(void *)"
        typealias "SDL_AppEvent_func", "function (*pointer)()"
        const_set :SDL_AppEvent_func, "SDL_AppResult SDL_AppEvent_func(void *, SDL_Event *)"
        typealias "SDL_AppQuit_func", "function (*pointer)()"
        const_set :SDL_AppQuit_func, "void SDL_AppQuit_func(void *, SDL_AppResult)"
        extern "bool SDL_Init(SDL_InitFlags)"
        extern "bool SDL_InitSubSystem(SDL_InitFlags)"
        extern "void SDL_QuitSubSystem(SDL_InitFlags)"
        extern "SDL_InitFlags SDL_WasInit(SDL_InitFlags)"
        extern "void SDL_Quit(void)"
        extern "bool SDL_IsMainThread(void)"
        typealias "SDL_MainThreadCallback", "function (*pointer)()"
        const_set :SDL_MainThreadCallback, "void SDL_MainThreadCallback(void *)"
        extern "bool SDL_RunOnMainThread(SDL_MainThreadCallback, void *, bool)"
        extern "bool SDL_SetAppMetadata(char *, char *, char *)"
        extern "bool SDL_SetAppMetadataProperty(char *, char *)"
        extern "char * SDL_GetAppMetadataProperty(char *)"
        extern "SDL_SharedObject * SDL_LoadObject(char *)"
        extern "SDL_FunctionPointer SDL_LoadFunction(SDL_SharedObject *, char *)"
        extern "void SDL_UnloadObject(SDL_SharedObject *)"
        const_set :SDL_Locale, struct(
          [
            "char * language",
            "char * country",
          ]
        )
        extern "SDL_Locale ** SDL_GetPreferredLocales(int *)"
        const_set :SDL_LOG_CATEGORY_APPLICATION, 0
        const_set :SDL_LOG_CATEGORY_ERROR, 1
        const_set :SDL_LOG_CATEGORY_ASSERT, 2
        const_set :SDL_LOG_CATEGORY_SYSTEM, 3
        const_set :SDL_LOG_CATEGORY_AUDIO, 4
        const_set :SDL_LOG_CATEGORY_VIDEO, 5
        const_set :SDL_LOG_CATEGORY_RENDER, 6
        const_set :SDL_LOG_CATEGORY_INPUT, 7
        const_set :SDL_LOG_CATEGORY_TEST, 8
        const_set :SDL_LOG_CATEGORY_GPU, 9
        const_set :SDL_LOG_CATEGORY_RESERVED2, 10
        const_set :SDL_LOG_CATEGORY_RESERVED3, 11
        const_set :SDL_LOG_CATEGORY_RESERVED4, 12
        const_set :SDL_LOG_CATEGORY_RESERVED5, 13
        const_set :SDL_LOG_CATEGORY_RESERVED6, 14
        const_set :SDL_LOG_CATEGORY_RESERVED7, 15
        const_set :SDL_LOG_CATEGORY_RESERVED8, 16
        const_set :SDL_LOG_CATEGORY_RESERVED9, 17
        const_set :SDL_LOG_CATEGORY_RESERVED10, 18
        const_set :SDL_LOG_CATEGORY_CUSTOM, 19
        typealias "SDL_LogCategory", "enum"
        const_set :SDL_LOG_PRIORITY_INVALID, 0
        const_set :SDL_LOG_PRIORITY_TRACE, 1
        const_set :SDL_LOG_PRIORITY_VERBOSE, 2
        const_set :SDL_LOG_PRIORITY_DEBUG, 3
        const_set :SDL_LOG_PRIORITY_INFO, 4
        const_set :SDL_LOG_PRIORITY_WARN, 5
        const_set :SDL_LOG_PRIORITY_ERROR, 6
        const_set :SDL_LOG_PRIORITY_CRITICAL, 7
        const_set :SDL_LOG_PRIORITY_COUNT, 8
        typealias "SDL_LogPriority", "enum"
        extern "void SDL_SetLogPriorities(SDL_LogPriority)"
        extern "void SDL_SetLogPriority(int, SDL_LogPriority)"
        extern "SDL_LogPriority SDL_GetLogPriority(int)"
        extern "void SDL_ResetLogPriorities(void)"
        extern "bool SDL_SetLogPriorityPrefix(SDL_LogPriority, char *)"
        extern "void SDL_Log(char *, ...)"
        extern "void SDL_LogTrace(int, char *, ...)"
        extern "void SDL_LogVerbose(int, char *, ...)"
        extern "void SDL_LogDebug(int, char *, ...)"
        extern "void SDL_LogInfo(int, char *, ...)"
        extern "void SDL_LogWarn(int, char *, ...)"
        extern "void SDL_LogError(int, char *, ...)"
        extern "void SDL_LogCritical(int, char *, ...)"
        extern "void SDL_LogMessage(int, SDL_LogPriority, char *, ...)"
        typealias "SDL_LogOutputFunction", "function (*pointer)()"
        const_set :SDL_LogOutputFunction, "void SDL_LogOutputFunction(void *, int, SDL_LogPriority, char *)"
        extern "SDL_LogOutputFunction SDL_GetDefaultLogOutputFunction(void)"
        extern "void SDL_GetLogOutputFunction(SDL_LogOutputFunction *, void **)"
        extern "void SDL_SetLogOutputFunction(SDL_LogOutputFunction, void *)"
        typealias "SDL_MessageBoxFlags", "Uint32"
        typealias "SDL_MessageBoxButtonFlags", "Uint32"
        const_set :SDL_MessageBoxButtonData, struct(
          [
            "SDL_MessageBoxButtonFlags flags",
            "int buttonID",
            "char * text",
          ]
        )
        const_set :SDL_MessageBoxColor, struct(
          [
            "Uint8 r",
            "Uint8 g",
            "Uint8 b",
          ]
        )
        const_set :SDL_MESSAGEBOX_COLOR_BACKGROUND, 0
        const_set :SDL_MESSAGEBOX_COLOR_TEXT, 1
        const_set :SDL_MESSAGEBOX_COLOR_BUTTON_BORDER, 2
        const_set :SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND, 3
        const_set :SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED, 4
        const_set :SDL_MESSAGEBOX_COLOR_COUNT, 5
        typealias "SDL_MessageBoxColorType", "enum"
        const_set :SDL_MessageBoxColorScheme, struct(
          [
            { "colors[5]": SDL_MessageBoxColor },
          ]
        )
        const_set :SDL_MessageBoxData, struct(
          [
            "SDL_MessageBoxFlags flags",
            "SDL_Window * window",
            "char * title",
            "char * message",
            "int numbuttons",
            "SDL_MessageBoxButtonData * buttons",
            "SDL_MessageBoxColorScheme * colorScheme",
          ]
        )
        extern "bool SDL_ShowMessageBox(SDL_MessageBoxData *, int *)"
        extern "bool SDL_ShowSimpleMessageBox(SDL_MessageBoxFlags, char *, char *, SDL_Window *)"
        typealias "SDL_MetalView", "void *"
        extern "SDL_MetalView SDL_Metal_CreateView(SDL_Window *)"
        extern "void SDL_Metal_DestroyView(SDL_MetalView)"
        extern "void * SDL_Metal_GetLayer(SDL_MetalView)"
        extern "bool SDL_OpenURL(char *)"
        extern "char * SDL_GetPlatform(void)"
        extern "SDL_Process * SDL_CreateProcess(char **, bool)"
        const_set :SDL_PROCESS_STDIO_INHERITED, 0
        const_set :SDL_PROCESS_STDIO_NULL, 1
        const_set :SDL_PROCESS_STDIO_APP, 2
        const_set :SDL_PROCESS_STDIO_REDIRECT, 3
        typealias "SDL_ProcessIO", "enum"
        extern "SDL_Process * SDL_CreateProcessWithProperties(SDL_PropertiesID)"
        extern "SDL_PropertiesID SDL_GetProcessProperties(SDL_Process *)"
        extern "void * SDL_ReadProcess(SDL_Process *, size_t *, int *)"
        extern "SDL_IOStream * SDL_GetProcessInput(SDL_Process *)"
        extern "SDL_IOStream * SDL_GetProcessOutput(SDL_Process *)"
        extern "bool SDL_KillProcess(SDL_Process *, bool)"
        extern "bool SDL_WaitProcess(SDL_Process *, bool, int *)"
        extern "void SDL_DestroyProcess(SDL_Process *)"
        const_set :SDL_Vertex, struct(
          [
            { "position": SDL_FPoint },
            { "color": SDL_FColor },
            { "tex_coord": SDL_FPoint },
          ]
        )
        const_set :SDL_TEXTUREACCESS_STATIC, 0
        const_set :SDL_TEXTUREACCESS_STREAMING, 1
        const_set :SDL_TEXTUREACCESS_TARGET, 2
        typealias "SDL_TextureAccess", "enum"
        const_set :SDL_LOGICAL_PRESENTATION_DISABLED, 0
        const_set :SDL_LOGICAL_PRESENTATION_STRETCH, 1
        const_set :SDL_LOGICAL_PRESENTATION_LETTERBOX, 2
        const_set :SDL_LOGICAL_PRESENTATION_OVERSCAN, 3
        const_set :SDL_LOGICAL_PRESENTATION_INTEGER_SCALE, 4
        typealias "SDL_RendererLogicalPresentation", "enum"
        const_set :SDL_Texture, struct(
          [
            "SDL_PixelFormat format",
            "int w",
            "int h",
            "int refcount",
          ]
        )
        extern "int SDL_GetNumRenderDrivers(void)"
        extern "char * SDL_GetRenderDriver(int)"
        extern "bool SDL_CreateWindowAndRenderer(char *, int, int, SDL_WindowFlags, SDL_Window **, SDL_Renderer **)"
        extern "SDL_Renderer * SDL_CreateRenderer(SDL_Window *, char *)"
        extern "SDL_Renderer * SDL_CreateRendererWithProperties(SDL_PropertiesID)"
        extern "SDL_Renderer * SDL_CreateSoftwareRenderer(SDL_Surface *)"
        extern "SDL_Renderer * SDL_GetRenderer(SDL_Window *)"
        extern "SDL_Window * SDL_GetRenderWindow(SDL_Renderer *)"
        extern "char * SDL_GetRendererName(SDL_Renderer *)"
        extern "SDL_PropertiesID SDL_GetRendererProperties(SDL_Renderer *)"
        extern "bool SDL_GetRenderOutputSize(SDL_Renderer *, int *, int *)"
        extern "bool SDL_GetCurrentRenderOutputSize(SDL_Renderer *, int *, int *)"
        extern "SDL_Texture * SDL_CreateTexture(SDL_Renderer *, SDL_PixelFormat, SDL_TextureAccess, int, int)"
        extern "SDL_Texture * SDL_CreateTextureFromSurface(SDL_Renderer *, SDL_Surface *)"
        extern "SDL_Texture * SDL_CreateTextureWithProperties(SDL_Renderer *, SDL_PropertiesID)"
        extern "SDL_PropertiesID SDL_GetTextureProperties(SDL_Texture *)"
        extern "SDL_Renderer * SDL_GetRendererFromTexture(SDL_Texture *)"
        extern "bool SDL_GetTextureSize(SDL_Texture *, float *, float *)"
        extern "bool SDL_SetTextureColorMod(SDL_Texture *, Uint8, Uint8, Uint8)"
        extern "bool SDL_SetTextureColorModFloat(SDL_Texture *, float, float, float)"
        extern "bool SDL_GetTextureColorMod(SDL_Texture *, Uint8 *, Uint8 *, Uint8 *)"
        extern "bool SDL_GetTextureColorModFloat(SDL_Texture *, float *, float *, float *)"
        extern "bool SDL_SetTextureAlphaMod(SDL_Texture *, Uint8)"
        extern "bool SDL_SetTextureAlphaModFloat(SDL_Texture *, float)"
        extern "bool SDL_GetTextureAlphaMod(SDL_Texture *, Uint8 *)"
        extern "bool SDL_GetTextureAlphaModFloat(SDL_Texture *, float *)"
        extern "bool SDL_SetTextureBlendMode(SDL_Texture *, SDL_BlendMode)"
        extern "bool SDL_GetTextureBlendMode(SDL_Texture *, SDL_BlendMode *)"
        extern "bool SDL_SetTextureScaleMode(SDL_Texture *, SDL_ScaleMode)"
        extern "bool SDL_GetTextureScaleMode(SDL_Texture *, SDL_ScaleMode *)"
        extern "bool SDL_UpdateTexture(SDL_Texture *, SDL_Rect *, void *, int)"
        extern "bool SDL_UpdateYUVTexture(SDL_Texture *, SDL_Rect *, Uint8 *, int, Uint8 *, int, Uint8 *, int)"
        extern "bool SDL_UpdateNVTexture(SDL_Texture *, SDL_Rect *, Uint8 *, int, Uint8 *, int)"
        extern "bool SDL_LockTexture(SDL_Texture *, SDL_Rect *, void **, int *)"
        extern "bool SDL_LockTextureToSurface(SDL_Texture *, SDL_Rect *, SDL_Surface **)"
        extern "void SDL_UnlockTexture(SDL_Texture *)"
        extern "bool SDL_SetRenderTarget(SDL_Renderer *, SDL_Texture *)"
        extern "SDL_Texture * SDL_GetRenderTarget(SDL_Renderer *)"
        extern "bool SDL_SetRenderLogicalPresentation(SDL_Renderer *, int, int, SDL_RendererLogicalPresentation)"
        extern "bool SDL_GetRenderLogicalPresentation(SDL_Renderer *, int *, int *, SDL_RendererLogicalPresentation *)"
        extern "bool SDL_GetRenderLogicalPresentationRect(SDL_Renderer *, SDL_FRect *)"
        extern "bool SDL_RenderCoordinatesFromWindow(SDL_Renderer *, float, float, float *, float *)"
        extern "bool SDL_RenderCoordinatesToWindow(SDL_Renderer *, float, float, float *, float *)"
        extern "bool SDL_ConvertEventToRenderCoordinates(SDL_Renderer *, SDL_Event *)"
        extern "bool SDL_SetRenderViewport(SDL_Renderer *, SDL_Rect *)"
        extern "bool SDL_GetRenderViewport(SDL_Renderer *, SDL_Rect *)"
        extern "bool SDL_RenderViewportSet(SDL_Renderer *)"
        extern "bool SDL_GetRenderSafeArea(SDL_Renderer *, SDL_Rect *)"
        extern "bool SDL_SetRenderClipRect(SDL_Renderer *, SDL_Rect *)"
        extern "bool SDL_GetRenderClipRect(SDL_Renderer *, SDL_Rect *)"
        extern "bool SDL_RenderClipEnabled(SDL_Renderer *)"
        extern "bool SDL_SetRenderScale(SDL_Renderer *, float, float)"
        extern "bool SDL_GetRenderScale(SDL_Renderer *, float *, float *)"
        extern "bool SDL_SetRenderDrawColor(SDL_Renderer *, Uint8, Uint8, Uint8, Uint8)"
        extern "bool SDL_SetRenderDrawColorFloat(SDL_Renderer *, float, float, float, float)"
        extern "bool SDL_GetRenderDrawColor(SDL_Renderer *, Uint8 *, Uint8 *, Uint8 *, Uint8 *)"
        extern "bool SDL_GetRenderDrawColorFloat(SDL_Renderer *, float *, float *, float *, float *)"
        extern "bool SDL_SetRenderColorScale(SDL_Renderer *, float)"
        extern "bool SDL_GetRenderColorScale(SDL_Renderer *, float *)"
        extern "bool SDL_SetRenderDrawBlendMode(SDL_Renderer *, SDL_BlendMode)"
        extern "bool SDL_GetRenderDrawBlendMode(SDL_Renderer *, SDL_BlendMode *)"
        extern "bool SDL_RenderClear(SDL_Renderer *)"
        extern "bool SDL_RenderPoint(SDL_Renderer *, float, float)"
        extern "bool SDL_RenderPoints(SDL_Renderer *, SDL_FPoint *, int)"
        extern "bool SDL_RenderLine(SDL_Renderer *, float, float, float, float)"
        extern "bool SDL_RenderLines(SDL_Renderer *, SDL_FPoint *, int)"
        extern "bool SDL_RenderRect(SDL_Renderer *, SDL_FRect *)"
        extern "bool SDL_RenderRects(SDL_Renderer *, SDL_FRect *, int)"
        extern "bool SDL_RenderFillRect(SDL_Renderer *, SDL_FRect *)"
        extern "bool SDL_RenderFillRects(SDL_Renderer *, SDL_FRect *, int)"
        extern "bool SDL_RenderTexture(SDL_Renderer *, SDL_Texture *, SDL_FRect *, SDL_FRect *)"
        extern "bool SDL_RenderTextureRotated(SDL_Renderer *, SDL_Texture *, SDL_FRect *, SDL_FRect *, double, SDL_FPoint *, SDL_FlipMode)"
        extern "bool SDL_RenderTextureAffine(SDL_Renderer *, SDL_Texture *, SDL_FRect *, SDL_FPoint *, SDL_FPoint *, SDL_FPoint *)"
        extern "bool SDL_RenderTextureTiled(SDL_Renderer *, SDL_Texture *, SDL_FRect *, float, SDL_FRect *)"
        extern "bool SDL_RenderTexture9Grid(SDL_Renderer *, SDL_Texture *, SDL_FRect *, float, float, float, float, float, SDL_FRect *)"
        extern "bool SDL_RenderGeometry(SDL_Renderer *, SDL_Texture *, SDL_Vertex *, int, int *, int)"
        extern "bool SDL_RenderGeometryRaw(SDL_Renderer *, SDL_Texture *, float *, int, SDL_FColor *, int, float *, int, int, void *, int, int)"
        extern "SDL_Surface * SDL_RenderReadPixels(SDL_Renderer *, SDL_Rect *)"
        extern "bool SDL_RenderPresent(SDL_Renderer *)"
        extern "void SDL_DestroyTexture(SDL_Texture *)"
        extern "void SDL_DestroyRenderer(SDL_Renderer *)"
        extern "bool SDL_FlushRenderer(SDL_Renderer *)"
        extern "void * SDL_GetRenderMetalLayer(SDL_Renderer *)"
        extern "void * SDL_GetRenderMetalCommandEncoder(SDL_Renderer *)"
        extern "bool SDL_AddVulkanRenderSemaphores(SDL_Renderer *, Uint32, Sint64, Sint64)"
        extern "bool SDL_SetRenderVSync(SDL_Renderer *, int)"
        extern "bool SDL_GetRenderVSync(SDL_Renderer *, int *)"
        extern "bool SDL_RenderDebugText(SDL_Renderer *, float, float, char *)"
        extern "bool SDL_RenderDebugTextFormat(SDL_Renderer *, float, float, char *, ...)"
        const_set :SDL_StorageInterface, struct(
          [
            "Uint32 version",
            "function (*close)()",
            "function (*ready)()",
            "function (*enumerate)()",
            "function (*info)()",
            "function (*read_file)()",
            "function (*write_file)()",
            "function (*mkdir)()",
            "function (*remove)()",
            "function (*rename)()",
            "function (*copy)()",
            "function (*space_remaining)()",
          ]
        )
        extern "SDL_Storage * SDL_OpenTitleStorage(char *, SDL_PropertiesID)"
        extern "SDL_Storage * SDL_OpenUserStorage(char *, char *, SDL_PropertiesID)"
        extern "SDL_Storage * SDL_OpenFileStorage(char *)"
        extern "SDL_Storage * SDL_OpenStorage(SDL_StorageInterface *, void *)"
        extern "bool SDL_CloseStorage(SDL_Storage *)"
        extern "bool SDL_StorageReady(SDL_Storage *)"
        extern "bool SDL_GetStorageFileSize(SDL_Storage *, char *, Uint64 *)"
        extern "bool SDL_ReadStorageFile(SDL_Storage *, char *, void *, Uint64)"
        extern "bool SDL_WriteStorageFile(SDL_Storage *, char *, void *, Uint64)"
        extern "bool SDL_CreateStorageDirectory(SDL_Storage *, char *)"
        extern "bool SDL_EnumerateStorageDirectory(SDL_Storage *, char *, SDL_EnumerateDirectoryCallback, void *)"
        extern "bool SDL_RemoveStoragePath(SDL_Storage *, char *)"
        extern "bool SDL_RenameStoragePath(SDL_Storage *, char *, char *)"
        extern "bool SDL_CopyStorageFile(SDL_Storage *, char *, char *)"
        extern "bool SDL_GetStoragePathInfo(SDL_Storage *, char *, SDL_PathInfo *)"
        extern "Uint64 SDL_GetStorageSpaceRemaining(SDL_Storage *)"
        extern "char ** SDL_GlobStorageDirectory(SDL_Storage *, char *, char *, SDL_GlobFlags, int *)"
        typealias "SDL_X11EventHook", "function (*pointer)()"
        const_set :SDL_X11EventHook, "bool SDL_X11EventHook(void *, XEvent *)"
        extern "void SDL_SetX11EventHook(SDL_X11EventHook, void *)"
        extern "bool SDL_SetLinuxThreadPriority(Sint64, int)"
        extern "bool SDL_SetLinuxThreadPriorityAndPolicy(Sint64, int, int)"
        extern "bool SDL_IsTablet(void)"
        extern "bool SDL_IsTV(void)"
        const_set :SDL_SANDBOX_NONE, 0
        const_set :SDL_SANDBOX_UNKNOWN_CONTAINER, 1
        const_set :SDL_SANDBOX_FLATPAK, 2
        const_set :SDL_SANDBOX_SNAP, 3
        const_set :SDL_SANDBOX_MACOS, 4
        typealias "SDL_Sandbox", "enum"
        extern "SDL_Sandbox SDL_GetSandbox(void)"
        extern "void SDL_OnApplicationWillTerminate(void)"
        extern "void SDL_OnApplicationDidReceiveMemoryWarning(void)"
        extern "void SDL_OnApplicationWillEnterBackground(void)"
        extern "void SDL_OnApplicationDidEnterBackground(void)"
        extern "void SDL_OnApplicationWillEnterForeground(void)"
        extern "void SDL_OnApplicationDidEnterForeground(void)"
        const_set :SDL_DateTime, struct(
          [
            "int year",
            "int month",
            "int day",
            "int hour",
            "int minute",
            "int second",
            "int nanosecond",
            "int day_of_week",
            "int utc_offset",
          ]
        )
        const_set :SDL_DATE_FORMAT_YYYYMMDD, 0
        const_set :SDL_DATE_FORMAT_DDMMYYYY, 1
        const_set :SDL_DATE_FORMAT_MMDDYYYY, 2
        typealias "SDL_DateFormat", "enum"
        const_set :SDL_TIME_FORMAT_24HR, 0
        const_set :SDL_TIME_FORMAT_12HR, 1
        typealias "SDL_TimeFormat", "enum"
        extern "bool SDL_GetDateTimeLocalePreferences(SDL_DateFormat *, SDL_TimeFormat *)"
        extern "bool SDL_GetCurrentTime(SDL_Time *)"
        extern "bool SDL_TimeToDateTime(SDL_Time, SDL_DateTime *, bool)"
        extern "bool SDL_DateTimeToTime(SDL_DateTime *, SDL_Time *)"
        extern "void SDL_TimeToWindows(SDL_Time, Uint32 *, Uint32 *)"
        extern "SDL_Time SDL_TimeFromWindows(Uint32, Uint32)"
        extern "int SDL_GetDaysInMonth(int, int)"
        extern "int SDL_GetDayOfYear(int, int, int)"
        extern "int SDL_GetDayOfWeek(int, int, int)"
        extern "Uint64 SDL_GetTicks(void)"
        extern "Uint64 SDL_GetTicksNS(void)"
        extern "Uint64 SDL_GetPerformanceCounter(void)"
        extern "Uint64 SDL_GetPerformanceFrequency(void)"
        extern "void SDL_Delay(Uint32)"
        extern "void SDL_DelayNS(Uint64)"
        extern "void SDL_DelayPrecise(Uint64)"
        typealias "SDL_TimerID", "Uint32"
        typealias "SDL_TimerCallback", "function (*pointer)()"
        const_set :SDL_TimerCallback, "Uint32 SDL_TimerCallback(void *, SDL_TimerID, Uint32)"
        extern "SDL_TimerID SDL_AddTimer(Uint32, SDL_TimerCallback, void *)"
        typealias "SDL_NSTimerCallback", "function (*pointer)()"
        const_set :SDL_NSTimerCallback, "Uint64 SDL_NSTimerCallback(void *, SDL_TimerID, Uint64)"
        extern "SDL_TimerID SDL_AddTimerNS(Uint64, SDL_NSTimerCallback, void *)"
        extern "bool SDL_RemoveTimer(SDL_TimerID)"
        typealias "SDL_TrayEntryFlags", "Uint32"
        typealias "SDL_TrayCallback", "function (*pointer)()"
        const_set :SDL_TrayCallback, "void SDL_TrayCallback(void *, SDL_TrayEntry *)"
        extern "SDL_Tray * SDL_CreateTray(SDL_Surface *, char *)"
        extern "void SDL_SetTrayIcon(SDL_Tray *, SDL_Surface *)"
        extern "void SDL_SetTrayTooltip(SDL_Tray *, char *)"
        extern "SDL_TrayMenu * SDL_CreateTrayMenu(SDL_Tray *)"
        extern "SDL_TrayMenu * SDL_CreateTraySubmenu(SDL_TrayEntry *)"
        extern "SDL_TrayMenu * SDL_GetTrayMenu(SDL_Tray *)"
        extern "SDL_TrayMenu * SDL_GetTraySubmenu(SDL_TrayEntry *)"
        extern "SDL_TrayEntry ** SDL_GetTrayEntries(SDL_TrayMenu *, int *)"
        extern "void SDL_RemoveTrayEntry(SDL_TrayEntry *)"
        extern "SDL_TrayEntry * SDL_InsertTrayEntryAt(SDL_TrayMenu *, int, char *, SDL_TrayEntryFlags)"
        extern "void SDL_SetTrayEntryLabel(SDL_TrayEntry *, char *)"
        extern "char * SDL_GetTrayEntryLabel(SDL_TrayEntry *)"
        extern "void SDL_SetTrayEntryChecked(SDL_TrayEntry *, bool)"
        extern "bool SDL_GetTrayEntryChecked(SDL_TrayEntry *)"
        extern "void SDL_SetTrayEntryEnabled(SDL_TrayEntry *, bool)"
        extern "bool SDL_GetTrayEntryEnabled(SDL_TrayEntry *)"
        extern "void SDL_SetTrayEntryCallback(SDL_TrayEntry *, SDL_TrayCallback, void *)"
        extern "void SDL_ClickTrayEntry(SDL_TrayEntry *)"
        extern "void SDL_DestroyTray(SDL_Tray *)"
        extern "SDL_TrayMenu * SDL_GetTrayEntryParent(SDL_TrayEntry *)"
        extern "SDL_TrayEntry * SDL_GetTrayMenuParentEntry(SDL_TrayMenu *)"
        extern "SDL_Tray * SDL_GetTrayMenuParentTray(SDL_TrayMenu *)"
        extern "void SDL_UpdateTrays(void)"
        extern "int SDL_GetVersion(void)"
        extern "char * SDL_GetRevision(void)"
      }
    end
  end
  private_constant :SDL

  SDL.included(self)
end
