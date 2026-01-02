# frozen_string_literal: true
require_relative "../rbsdl3"
require_relative "sdl"

module SDL3
  using BindingsRefinement
  SDL_image = proc {
    # Ruby wrappers for SDL_image macros
    #
    const_set :SDL_IMAGE_MAJOR_VERSION, 3
    const_set :SDL_IMAGE_MINOR_VERSION, 2
    const_set :SDL_IMAGE_MICRO_VERSION, 6
    const_set :SDL_IMAGE_VERSION, SDL_VERSIONNUM(SDL_IMAGE_MAJOR_VERSION, SDL_IMAGE_MINOR_VERSION, SDL_IMAGE_MICRO_VERSION)
    module_function def SDL_IMAGE_VERSION_ATLEAST(x, y, z) = ((SDL_IMAGE_MAJOR_VERSION >= x) && (SDL_IMAGE_MAJOR_VERSION > x || SDL_IMAGE_MINOR_VERSION >= y) && (SDL_IMAGE_MAJOR_VERSION > x || SDL_IMAGE_MINOR_VERSION > y || SDL_IMAGE_MICRO_VERSION >= z))

    # Fiddle declarations for SDL_image functions, structs, and enums
    #
    extern "int IMG_Version(void)"
    extern "SDL_Surface * IMG_LoadTyped_IO(SDL_IOStream *, bool, char *)"
    extern "SDL_Surface * IMG_Load(char *)"
    extern "SDL_Surface * IMG_Load_IO(SDL_IOStream *, bool)"
    extern "SDL_Texture * IMG_LoadTexture(SDL_Renderer *, char *)"
    extern "SDL_Texture * IMG_LoadTexture_IO(SDL_Renderer *, SDL_IOStream *, bool)"
    extern "SDL_Texture * IMG_LoadTextureTyped_IO(SDL_Renderer *, SDL_IOStream *, bool, char *)"
    extern "bool IMG_isAVIF(SDL_IOStream *)"
    extern "bool IMG_isICO(SDL_IOStream *)"
    extern "bool IMG_isCUR(SDL_IOStream *)"
    extern "bool IMG_isBMP(SDL_IOStream *)"
    extern "bool IMG_isGIF(SDL_IOStream *)"
    extern "bool IMG_isJPG(SDL_IOStream *)"
    extern "bool IMG_isJXL(SDL_IOStream *)"
    extern "bool IMG_isLBM(SDL_IOStream *)"
    extern "bool IMG_isPCX(SDL_IOStream *)"
    extern "bool IMG_isPNG(SDL_IOStream *)"
    extern "bool IMG_isPNM(SDL_IOStream *)"
    extern "bool IMG_isSVG(SDL_IOStream *)"
    extern "bool IMG_isQOI(SDL_IOStream *)"
    extern "bool IMG_isTIF(SDL_IOStream *)"
    extern "bool IMG_isXCF(SDL_IOStream *)"
    extern "bool IMG_isXPM(SDL_IOStream *)"
    extern "bool IMG_isXV(SDL_IOStream *)"
    extern "bool IMG_isWEBP(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadAVIF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadICO_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadCUR_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadBMP_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadGIF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadJPG_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadJXL_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadLBM_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadPCX_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadPNG_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadPNM_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadSVG_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadQOI_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadTGA_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadTIF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadXCF_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadXPM_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadXV_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadWEBP_IO(SDL_IOStream *)"
    extern "SDL_Surface * IMG_LoadSizedSVG_IO(SDL_IOStream *, int, int)"
    extern "SDL_Surface * IMG_ReadXPMFromArray(char **)"
    extern "SDL_Surface * IMG_ReadXPMFromArrayToRGB888(char **)"
    extern "bool IMG_SaveAVIF(SDL_Surface *, char *, int)"
    extern "bool IMG_SaveAVIF_IO(SDL_Surface *, SDL_IOStream *, bool, int)"
    extern "bool IMG_SavePNG(SDL_Surface *, char *)"
    extern "bool IMG_SavePNG_IO(SDL_Surface *, SDL_IOStream *, bool)"
    extern "bool IMG_SaveJPG(SDL_Surface *, char *, int)"
    extern "bool IMG_SaveJPG_IO(SDL_Surface *, SDL_IOStream *, bool, int)"
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
    extern "void IMG_FreeAnimation(IMG_Animation *)"
    extern "IMG_Animation * IMG_LoadGIFAnimation_IO(SDL_IOStream *)"
    extern "IMG_Animation * IMG_LoadWEBPAnimation_IO(SDL_IOStream *)"
  }
  private_constant :SDL_image

  SDL_image.call
end
