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
private_class_method module_function alias_method :enum, :int

# Aliases for macro-cast emulation (typedefs and enum carriers)
#
# enum carriers
private_class_method module_function alias_method :SDL_ChromaLocation, :enum
private_class_method module_function alias_method :SDL_ColorPrimaries, :enum
private_class_method module_function alias_method :SDL_ColorRange, :enum
private_class_method module_function alias_method :SDL_ColorType, :enum
private_class_method module_function alias_method :SDL_MatrixCoefficients, :enum
private_class_method module_function alias_method :SDL_TransferCharacteristics, :enum

# Uint32 typedeffs
private_class_method module_function alias_method :SDL_AudioDeviceID, :Uint32
private_class_method module_function alias_method :SDL_MouseID, :Uint32

# Uint64 typedefs
private_class_method module_function alias_method :SDL_TouchID, :Uint64

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
extern "void SDL_SetMainReady(void)"

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
