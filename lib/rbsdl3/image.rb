# frozen_string_literal: true
require_relative "../rbsdl3"
require_relative "sdl"

module SDL3
  using BindingsRefinement
  SDL_image = proc {
    # Ruby wrappers for SDL_image macros
    #
    const_set :SDL_IMAGE_MAJOR_VERSION, 3
    const_set :SDL_IMAGE_MINOR_VERSION, 4
    const_set :SDL_IMAGE_MICRO_VERSION, 0
    const_set :SDL_IMAGE_VERSION, SDL_VERSIONNUM(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_MICRO_VERSION)
    module_function def SDL_IMAGE_VERSION_ATLEAST(x, y, z) = ((SDL_IMAGE_MAJOR_VERSION >= x) && (SDL_IMAGE_MAJOR_VERSION > x || SDL_IMAGE_MINOR_VERSION >= y) && (SDL_IMAGE_MAJOR_VERSION > x || SDL_IMAGE_MINOR_VERSION > y || SDL_IMAGE_MICRO_VERSION >= z))
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_FILENAME_STRING, "SDL_image.animation_encoder.create.filename"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_IOSTREAM_POINTER, "SDL_image.animation_encoder.create.iostream"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_IOSTREAM_AUTOCLOSE_BOOLEAN, "SDL_image.animation_encoder.create.iostream.autoclose"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_TYPE_STRING, "SDL_image.animation_encoder.create.type"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_QUALITY_NUMBER, "SDL_image.animation_encoder.create.quality"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_TIMEBASE_NUMERATOR_NUMBER, "SDL_image.animation_encoder.create.timebase.numerator"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_TIMEBASE_DENOMINATOR_NUMBER, "SDL_image.animation_encoder.create.timebase.denominator"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_AVIF_MAX_THREADS_NUMBER, "SDL_image.animation_encoder.create.avif.max_threads"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_AVIF_KEYFRAME_INTERVAL_NUMBER, "SDL_image.animation_encoder.create.avif.keyframe_interval"
    const_set :IMG_PROP_ANIMATION_ENCODER_CREATE_GIF_USE_LUT_BOOLEAN, "SDL_image.animation_encoder.create.gif.use_lut"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_FILENAME_STRING, "SDL_image.animation_decoder.create.filename"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_IOSTREAM_POINTER, "SDL_image.animation_decoder.create.iostream"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_IOSTREAM_AUTOCLOSE_BOOLEAN, "SDL_image.animation_decoder.create.iostream.autoclose"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_TYPE_STRING, "SDL_image.animation_decoder.create.type"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_TIMEBASE_NUMERATOR_NUMBER, "SDL_image.animation_decoder.create.timebase.numerator"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_TIMEBASE_DENOMINATOR_NUMBER, "SDL_image.animation_decoder.create.timebase.denominator"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_AVIF_MAX_THREADS_NUMBER, "SDL_image.animation_decoder.create.avif.max_threads"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_AVIF_ALLOW_INCREMENTAL_BOOLEAN, "SDL_image.animation_decoder.create.avif.allow_incremental"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_AVIF_ALLOW_PROGRESSIVE_BOOLEAN, "SDL_image.animation_decoder.create.avif.allow_progressive"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_GIF_TRANSPARENT_COLOR_INDEX_NUMBER, "SDL_image.animation_encoder.create.gif.transparent_color_index"
    const_set :IMG_PROP_ANIMATION_DECODER_CREATE_GIF_NUM_COLORS_NUMBER, "SDL_image.animation_encoder.create.gif.num_colors"
    const_set :IMG_PROP_METADATA_IGNORE_PROPS_BOOLEAN, "SDL_image.metadata.ignore_props"
    const_set :IMG_PROP_METADATA_DESCRIPTION_STRING, "SDL_image.metadata.description"
    const_set :IMG_PROP_METADATA_COPYRIGHT_STRING, "SDL_image.metadata.copyright"
    const_set :IMG_PROP_METADATA_TITLE_STRING, "SDL_image.metadata.title"
    const_set :IMG_PROP_METADATA_AUTHOR_STRING, "SDL_image.metadata.author"
    const_set :IMG_PROP_METADATA_CREATION_TIME_STRING, "SDL_image.metadata.creation_time"
    const_set :IMG_PROP_METADATA_FRAME_COUNT_NUMBER, "SDL_image.metadata.frame_count"
    const_set :IMG_PROP_METADATA_LOOP_COUNT_NUMBER, "SDL_image.metadata.loop_count"

    # Fiddle declarations for SDL_image functions, structs, and enums
    #
    extern "int IMG_Version(void)"
    extern "SDL_Surface * IMG_Load(char *)"
    extern "SDL_Surface * IMG_Load_IO(SDL_IOStream *, bool)"
    extern "SDL_Surface * IMG_LoadTyped_IO(SDL_IOStream *, bool, char *)"
    extern "SDL_Texture * IMG_LoadTexture(SDL_Renderer *, char *)"
    extern "SDL_Texture * IMG_LoadTexture_IO(SDL_Renderer *, SDL_IOStream *, bool)"
    extern "SDL_Texture * IMG_LoadTextureTyped_IO(SDL_Renderer *, SDL_IOStream *, bool, char *)"
    extern "SDL_GPUTexture * IMG_LoadGPUTexture(SDL_GPUDevice *, SDL_GPUCopyPass *, char *, int *, int *)"
    extern "SDL_GPUTexture * IMG_LoadGPUTexture_IO(SDL_GPUDevice *, SDL_GPUCopyPass *, SDL_IOStream *, bool, int *, int *)"
    extern "SDL_GPUTexture * IMG_LoadGPUTextureTyped_IO(SDL_GPUDevice *, SDL_GPUCopyPass *, SDL_IOStream *, bool, char *, int *, int *)"
    extern "SDL_Surface * IMG_GetClipboardImage(void)"
    extern "bool IMG_isANI(SDL_IOStream *)"
    extern "bool IMG_isAVIF(SDL_IOStream *)"
    extern "bool IMG_isCUR(SDL_IOStream *)"
    extern "bool IMG_isBMP(SDL_IOStream *)"
    extern "bool IMG_isGIF(SDL_IOStream *)"
    extern "bool IMG_isICO(SDL_IOStream *)"
    extern "bool IMG_isJPG(SDL_IOStream *)"
    extern "bool IMG_isJXL(SDL_IOStream *)"
    extern "bool IMG_isLBM(SDL_IOStream *)"
    extern "bool IMG_isPCX(SDL_IOStream *)"
    extern "bool IMG_isPNG(SDL_IOStream *)"
    extern "bool IMG_isPNM(SDL_IOStream *)"
    extern "bool IMG_isQOI(SDL_IOStream *)"
    extern "bool IMG_isSVG(SDL_IOStream *)"
    extern "bool IMG_isTIF(SDL_IOStream *)"
    extern "bool IMG_isWEBP(SDL_IOStream *)"
    extern "bool IMG_isXCF(SDL_IOStream *)"
    extern "bool IMG_isXPM(SDL_IOStream *)"
    extern "bool IMG_isXV(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadAVIF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadBMP_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadCUR_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadGIF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadICO_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadJPG_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadJXL_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadLBM_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadPCX_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadPNG_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadPNM_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadSVG_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadSizedSVG_IO(SDL_IOStream *, int, int)"
    extern "SDL_Surface * IMG_LoadQOI_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadTGA_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadTIF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadWEBP_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadXCF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadXPM_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadXV_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_ReadXPMFromArray(char **)"
    extern "SDL_Surface * IMG_ReadXPMFromArrayToRGB888(char **)"
    extern "bool IMG_Save(SDL_Surface *, char *)"
    extern "bool IMG_SaveTyped_IO(SDL_Surface *, SDL_IOStream *, bool, char *)"
    extern "bool IMG_SaveAVIF(SDL_Surface *, char *, int)"
    extern "bool IMG_SaveAVIF_IO(SDL_Surface *, SDL_IOStream *, bool, int)"
    extern "bool IMG_SaveBMP(SDL_Surface *, char *)"
    extern "bool IMG_SaveBMP_IO(SDL_Surface *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveCUR(SDL_Surface *, char *)"
    extern "bool IMG_SaveCUR_IO(SDL_Surface *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveGIF(SDL_Surface *, char *)"
    extern "bool IMG_SaveGIF_IO(SDL_Surface *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveICO(SDL_Surface *, char *)"
    extern "bool IMG_SaveICO_IO(SDL_Surface *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveJPG(SDL_Surface *, char *, int)"
    extern "bool IMG_SaveJPG_IO(SDL_Surface *, SDL_IOStream *, bool, int)"
    extern "bool IMG_SavePNG(SDL_Surface *, char *)"
    extern "bool IMG_SavePNG_IO(SDL_Surface *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveTGA(SDL_Surface *, char *)"
    extern "bool IMG_SaveTGA_IO(SDL_Surface *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveWEBP(SDL_Surface *, char *, float)"
    extern "bool IMG_SaveWEBP_IO(SDL_Surface *, SDL_IOStream *, bool, float)"
    const_set :IMG_Animation, struct(
      [
        "int w",
        "int h",
        "int count",
        "SDL_Surface **frames",
        "int *delays",
      ]
    )
    extern "IMG_Animation * IMG_LoadAnimation(char *)"
    extern "IMG_Animation * IMG_LoadAnimation_IO(SDL_IOStream *, bool)"
    extern "IMG_Animation * IMG_LoadAnimationTyped_IO(SDL_IOStream *, bool, char *)"
    extern "IMG_Animation * IMG_LoadANIAnimation_IO(SDL_IOStream *)"
    extern "IMG_Animation * IMG_LoadAPNGAnimation_IO(SDL_IOStream *)"
    extern "IMG_Animation * IMG_LoadAVIFAnimation_IO(SDL_IOStream *)"
    extern "IMG_Animation * IMG_LoadGIFAnimation_IO(SDL_IOStream *)"
    extern "IMG_Animation * IMG_LoadWEBPAnimation_IO(SDL_IOStream *)"
    extern "bool IMG_SaveAnimation(IMG_Animation *, char *)"
    extern "bool IMG_SaveAnimationTyped_IO(IMG_Animation *, SDL_IOStream *, bool, char *)"
    extern "bool IMG_SaveANIAnimation_IO(IMG_Animation *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveAPNGAnimation_IO(IMG_Animation *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveAVIFAnimation_IO(IMG_Animation *, SDL_IOStream *, bool, int)"
    extern "bool IMG_SaveGIFAnimation_IO(IMG_Animation *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveWEBPAnimation_IO(IMG_Animation *, SDL_IOStream *, bool, int)"
    extern "SDL_Cursor * IMG_CreateAnimatedCursor(IMG_Animation *, int, int)"
    extern "void IMG_FreeAnimation(IMG_Animation *)"
    extern "IMG_AnimationEncoder * IMG_CreateAnimationEncoder(char *)"
    extern "IMG_AnimationEncoder * IMG_CreateAnimationEncoder_IO(SDL_IOStream *, bool, char *)"
    extern "IMG_AnimationEncoder * IMG_CreateAnimationEncoderWithProperties(SDL_PropertiesID)"
    extern "bool IMG_AddAnimationEncoderFrame(IMG_AnimationEncoder *, SDL_Surface *, Uint64)"
    extern "bool IMG_CloseAnimationEncoder(IMG_AnimationEncoder *)"
    const_set :IMG_DECODER_STATUS_INVALID, 4294967295
    const_set :IMG_DECODER_STATUS_OK, 0
    const_set :IMG_DECODER_STATUS_FAILED, 1
    const_set :IMG_DECODER_STATUS_COMPLETE, 2
    typealias "IMG_AnimationDecoderStatus", "enum"
    extern "IMG_AnimationDecoder * IMG_CreateAnimationDecoder(char *)"
    extern "IMG_AnimationDecoder * IMG_CreateAnimationDecoder_IO(SDL_IOStream *, bool, char *)"
    extern "IMG_AnimationDecoder * IMG_CreateAnimationDecoderWithProperties(SDL_PropertiesID)"
    extern "SDL_PropertiesID IMG_GetAnimationDecoderProperties(IMG_AnimationDecoder *)"
    extern "bool IMG_GetAnimationDecoderFrame(IMG_AnimationDecoder *, SDL_Surface **, Uint64 *)"
    extern "IMG_AnimationDecoderStatus IMG_GetAnimationDecoderStatus(IMG_AnimationDecoder *)"
    extern "bool IMG_ResetAnimationDecoder(IMG_AnimationDecoder *)"
    extern "bool IMG_CloseAnimationDecoder(IMG_AnimationDecoder *)"
  }
  private_constant :SDL_image

  SDL_image.call
end
