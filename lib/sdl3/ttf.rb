# frozen_string_literal: true
require_relative "../sdl3"
require_relative "sdl"
require_relative "bindings_refinement"

module SDL3
  module TTF
    using BindingsRefinement

    def self.included(m)
      m.module_eval {
        # Ruby wrappers for SDL_ttf macros
        #
        const_set :SDL_TTF_MAJOR_VERSION, 3
        const_set :SDL_TTF_MINOR_VERSION, 2
        const_set :SDL_TTF_MICRO_VERSION, 2
        const_set :SDL_TTF_VERSION, SDL_VERSIONNUM(SDL_TTF_MAJOR_VERSION, SDL_TTF_MINOR_VERSION, SDL_TTF_MICRO_VERSION)
        module_function def SDL_TTF_VERSION_ATLEAST(x, y, z) = ((SDL_TTF_MAJOR_VERSION >= x) && (SDL_TTF_MAJOR_VERSION > x || SDL_TTF_MINOR_VERSION >= y) && (SDL_TTF_MAJOR_VERSION > x || SDL_TTF_MINOR_VERSION > y || SDL_TTF_MICRO_VERSION >= z))

        # Fiddle declarations for SDL_ttf functions, structs, and enums
        #
        extern "int TTF_Version(void)"
        extern "void TTF_GetFreeTypeVersion(int *, int *, int *)"
        extern "void TTF_GetHarfBuzzVersion(int *, int *, int *)"
        extern "bool TTF_Init(void)"
        extern "TTF_Font * TTF_OpenFont(char *, float)"
        extern "TTF_Font * TTF_OpenFontIO(SDL_IOStream *, bool, float)"
        extern "TTF_Font * TTF_OpenFontWithProperties(SDL_PropertiesID)"
        extern "TTF_Font * TTF_CopyFont(TTF_Font *)"
        extern "SDL_PropertiesID TTF_GetFontProperties(TTF_Font *)"
        extern "Uint32 TTF_GetFontGeneration(TTF_Font *)"
        extern "bool TTF_AddFallbackFont(TTF_Font *, TTF_Font *)"
        extern "void TTF_RemoveFallbackFont(TTF_Font *, TTF_Font *)"
        extern "void TTF_ClearFallbackFonts(TTF_Font *)"
        extern "bool TTF_SetFontSize(TTF_Font *, float)"
        extern "bool TTF_SetFontSizeDPI(TTF_Font *, float, int, int)"
        extern "float TTF_GetFontSize(TTF_Font *)"
        extern "bool TTF_GetFontDPI(TTF_Font *, int *, int *)"
        typealias "TTF_FontStyleFlags", "Uint32"
        extern "void TTF_SetFontStyle(TTF_Font *, TTF_FontStyleFlags)"
        extern "TTF_FontStyleFlags TTF_GetFontStyle(TTF_Font *)"
        extern "bool TTF_SetFontOutline(TTF_Font *, int)"
        extern "int TTF_GetFontOutline(TTF_Font *)"
        const_set :TTF_HINTING_INVALID, 4294967295
        const_set :TTF_HINTING_NORMAL, 0
        const_set :TTF_HINTING_LIGHT, 1
        const_set :TTF_HINTING_MONO, 2
        const_set :TTF_HINTING_NONE, 3
        const_set :TTF_HINTING_LIGHT_SUBPIXEL, 4
        typealias "TTF_HintingFlags", "enum"
        extern "void TTF_SetFontHinting(TTF_Font *, TTF_HintingFlags)"
        extern "int TTF_GetNumFontFaces(TTF_Font *)"
        extern "TTF_HintingFlags TTF_GetFontHinting(TTF_Font *)"
        extern "bool TTF_SetFontSDF(TTF_Font *, bool)"
        extern "bool TTF_GetFontSDF(TTF_Font *)"
        extern "int TTF_GetFontWeight(TTF_Font *)"
        const_set :TTF_HORIZONTAL_ALIGN_INVALID, 4294967295
        const_set :TTF_HORIZONTAL_ALIGN_LEFT, 0
        const_set :TTF_HORIZONTAL_ALIGN_CENTER, 1
        const_set :TTF_HORIZONTAL_ALIGN_RIGHT, 2
        typealias "TTF_HorizontalAlignment", "enum"
        extern "void TTF_SetFontWrapAlignment(TTF_Font *, TTF_HorizontalAlignment)"
        extern "TTF_HorizontalAlignment TTF_GetFontWrapAlignment(TTF_Font *)"
        extern "int TTF_GetFontHeight(TTF_Font *)"
        extern "int TTF_GetFontAscent(TTF_Font *)"
        extern "int TTF_GetFontDescent(TTF_Font *)"
        extern "void TTF_SetFontLineSkip(TTF_Font *, int)"
        extern "int TTF_GetFontLineSkip(TTF_Font *)"
        extern "void TTF_SetFontKerning(TTF_Font *, bool)"
        extern "bool TTF_GetFontKerning(TTF_Font *)"
        extern "bool TTF_FontIsFixedWidth(TTF_Font *)"
        extern "bool TTF_FontIsScalable(TTF_Font *)"
        extern "char * TTF_GetFontFamilyName(TTF_Font *)"
        extern "char * TTF_GetFontStyleName(TTF_Font *)"
        const_set :TTF_DIRECTION_INVALID, 0
        const_set :TTF_DIRECTION_LTR, 4
        const_set :TTF_DIRECTION_RTL, 5
        const_set :TTF_DIRECTION_TTB, 6
        const_set :TTF_DIRECTION_BTT, 7
        typealias "TTF_Direction", "enum"
        extern "bool TTF_SetFontDirection(TTF_Font *, TTF_Direction)"
        extern "TTF_Direction TTF_GetFontDirection(TTF_Font *)"
        extern "Uint32 TTF_StringToTag(char *)"
        extern "void TTF_TagToString(Uint32, char *, size_t)"
        extern "bool TTF_SetFontScript(TTF_Font *, Uint32)"
        extern "Uint32 TTF_GetFontScript(TTF_Font *)"
        extern "Uint32 TTF_GetGlyphScript(Uint32)"
        extern "bool TTF_SetFontLanguage(TTF_Font *, char *)"
        extern "bool TTF_FontHasGlyph(TTF_Font *, Uint32)"
        const_set :TTF_IMAGE_INVALID, 0
        const_set :TTF_IMAGE_ALPHA, 1
        const_set :TTF_IMAGE_COLOR, 2
        const_set :TTF_IMAGE_SDF, 3
        typealias "TTF_ImageType", "enum"
        extern "SDL_Surface * TTF_GetGlyphImage(TTF_Font *, Uint32, TTF_ImageType *)"
        extern "SDL_Surface * TTF_GetGlyphImageForIndex(TTF_Font *, Uint32, TTF_ImageType *)"
        extern "bool TTF_GetGlyphMetrics(TTF_Font *, Uint32, int *, int *, int *, int *, int *)"
        extern "bool TTF_GetGlyphKerning(TTF_Font *, Uint32, Uint32, int *)"
        extern "bool TTF_GetStringSize(TTF_Font *, char *, size_t, int *, int *)"
        extern "bool TTF_GetStringSizeWrapped(TTF_Font *, char *, size_t, int, int *, int *)"
        extern "bool TTF_MeasureString(TTF_Font *, char *, size_t, int, int *, size_t *)"
        module_function def TTF_RenderText_Solid(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_Solid()")
        module_function def TTF_RenderText_Solid_Wrapped(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_Solid_Wrapped()")
        module_function def TTF_RenderGlyph_Solid(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderGlyph_Solid()")
        module_function def TTF_RenderText_Shaded(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_Shaded()")
        module_function def TTF_RenderText_Shaded_Wrapped(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_Shaded_Wrapped()")
        module_function def TTF_RenderGlyph_Shaded(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderGlyph_Shaded()")
        module_function def TTF_RenderText_Blended(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_Blended()")
        module_function def TTF_RenderText_Blended_Wrapped(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_Blended_Wrapped()")
        module_function def TTF_RenderGlyph_Blended(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderGlyph_Blended()")
        module_function def TTF_RenderText_LCD(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_LCD()")
        module_function def TTF_RenderText_LCD_Wrapped(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderText_LCD_Wrapped()")
        module_function def TTF_RenderGlyph_LCD(...) = raise(NotImplementedError, "cannot bind SDL function (by-value parameters): TTF_RenderGlyph_LCD()")
        const_set :TTF_Text, struct(
          [
            "char *text",
            "int num_lines",
            "int refcount",
            "TTF_TextData *internal",
          ]
        )
        extern "TTF_TextEngine * TTF_CreateSurfaceTextEngine(void)"
        extern "bool TTF_DrawSurfaceText(TTF_Text *, int, int, SDL_Surface *)"
        extern "void TTF_DestroySurfaceTextEngine(TTF_TextEngine *)"
        extern "TTF_TextEngine * TTF_CreateRendererTextEngine(SDL_Renderer *)"
        extern "TTF_TextEngine * TTF_CreateRendererTextEngineWithProperties(SDL_PropertiesID)"
        extern "bool TTF_DrawRendererText(TTF_Text *, float, float)"
        extern "void TTF_DestroyRendererTextEngine(TTF_TextEngine *)"
        extern "TTF_TextEngine * TTF_CreateGPUTextEngine(SDL_GPUDevice *)"
        extern "TTF_TextEngine * TTF_CreateGPUTextEngineWithProperties(SDL_PropertiesID)"
        const_set :TTF_GPUAtlasDrawSequence, struct(
          [
            "SDL_GPUTexture *atlas_texture",
            "SDL_FPoint *xy",
            "SDL_FPoint *uv",
            "int num_vertices",
            "int *indices",
            "int num_indices",
            "TTF_ImageType image_type",
            "TTF_GPUAtlasDrawSequence *next",
          ]
        )
        extern "TTF_GPUAtlasDrawSequence * TTF_GetGPUTextDrawData(TTF_Text *)"
        extern "void TTF_DestroyGPUTextEngine(TTF_TextEngine *)"
        const_set :TTF_GPU_TEXTENGINE_WINDING_INVALID, 4294967295
        const_set :TTF_GPU_TEXTENGINE_WINDING_CLOCKWISE, 0
        const_set :TTF_GPU_TEXTENGINE_WINDING_COUNTER_CLOCKWISE, 1
        typealias "TTF_GPUTextEngineWinding", "enum"
        extern "void TTF_SetGPUTextEngineWinding(TTF_TextEngine *, TTF_GPUTextEngineWinding)"
        extern "TTF_GPUTextEngineWinding TTF_GetGPUTextEngineWinding(TTF_TextEngine *)"
        extern "TTF_Text * TTF_CreateText(TTF_TextEngine *, TTF_Font *, char *, size_t)"
        extern "SDL_PropertiesID TTF_GetTextProperties(TTF_Text *)"
        extern "bool TTF_SetTextEngine(TTF_Text *, TTF_TextEngine *)"
        extern "TTF_TextEngine * TTF_GetTextEngine(TTF_Text *)"
        extern "bool TTF_SetTextFont(TTF_Text *, TTF_Font *)"
        extern "TTF_Font * TTF_GetTextFont(TTF_Text *)"
        extern "bool TTF_SetTextDirection(TTF_Text *, TTF_Direction)"
        extern "TTF_Direction TTF_GetTextDirection(TTF_Text *)"
        extern "bool TTF_SetTextScript(TTF_Text *, Uint32)"
        extern "Uint32 TTF_GetTextScript(TTF_Text *)"
        extern "bool TTF_SetTextColor(TTF_Text *, Uint8, Uint8, Uint8, Uint8)"
        extern "bool TTF_SetTextColorFloat(TTF_Text *, float, float, float, float)"
        extern "bool TTF_GetTextColor(TTF_Text *, Uint8 *, Uint8 *, Uint8 *, Uint8 *)"
        extern "bool TTF_GetTextColorFloat(TTF_Text *, float *, float *, float *, float *)"
        extern "bool TTF_SetTextPosition(TTF_Text *, int, int)"
        extern "bool TTF_GetTextPosition(TTF_Text *, int *, int *)"
        extern "bool TTF_SetTextWrapWidth(TTF_Text *, int)"
        extern "bool TTF_GetTextWrapWidth(TTF_Text *, int *)"
        extern "bool TTF_SetTextWrapWhitespaceVisible(TTF_Text *, bool)"
        extern "bool TTF_TextWrapWhitespaceVisible(TTF_Text *)"
        extern "bool TTF_SetTextString(TTF_Text *, char *, size_t)"
        extern "bool TTF_InsertTextString(TTF_Text *, int, char *, size_t)"
        extern "bool TTF_AppendTextString(TTF_Text *, char *, size_t)"
        extern "bool TTF_DeleteTextString(TTF_Text *, int, int)"
        extern "bool TTF_GetTextSize(TTF_Text *, int *, int *)"
        typealias "TTF_SubStringFlags", "Uint32"
        const_set :TTF_SubString, struct(
          [
            "TTF_SubStringFlags flags",
            "int offset",
            "int length",
            "int line_index",
            "int cluster_index",
            { "rect": SDL_Rect },
          ]
        )
        extern "bool TTF_GetTextSubString(TTF_Text *, int, TTF_SubString *)"
        extern "bool TTF_GetTextSubStringForLine(TTF_Text *, int, TTF_SubString *)"
        extern "TTF_SubString ** TTF_GetTextSubStringsForRange(TTF_Text *, int, int, int *)"
        extern "bool TTF_GetTextSubStringForPoint(TTF_Text *, int, int, TTF_SubString *)"
        extern "bool TTF_GetPreviousTextSubString(TTF_Text *, TTF_SubString *, TTF_SubString *)"
        extern "bool TTF_GetNextTextSubString(TTF_Text *, TTF_SubString *, TTF_SubString *)"
        extern "bool TTF_UpdateText(TTF_Text *)"
        extern "void TTF_DestroyText(TTF_Text *)"
        extern "void TTF_CloseFont(TTF_Font *)"
        extern "void TTF_Quit(void)"
        extern "int TTF_WasInit(void)"
        const_set :TTF_DRAW_COMMAND_NOOP, 0
        const_set :TTF_DRAW_COMMAND_FILL, 1
        const_set :TTF_DRAW_COMMAND_COPY, 2
        typealias "TTF_DrawCommand", "enum"
        const_set :TTF_FillOperation, struct(
          [
            "TTF_DrawCommand cmd",
            { "rect": SDL_Rect },
          ]
        )
        const_set :TTF_CopyOperation, struct(
          [
            "TTF_DrawCommand cmd",
            "int text_offset",
            "TTF_Font *glyph_font",
            "Uint32 glyph_index",
            { "src": SDL_Rect },
            { "dst": SDL_Rect },
            "void *reserved",
          ]
        )
        const_set :TTF_DrawOperation, union(
          [
            "TTF_DrawCommand cmd",
            { "fill": TTF_FillOperation },
            { "copy": TTF_CopyOperation },
          ]
        )
        const_set :TTF_TextData, struct(
          [
            "TTF_Font *font",
            { "color": SDL_FColor },
            "bool needs_layout_update",
            "TTF_TextLayout *layout",
            "int x",
            "int y",
            "int w",
            "int h",
            "int num_ops",
            "TTF_DrawOperation *ops",
            "int num_clusters",
            "TTF_SubString *clusters",
            "SDL_PropertiesID props",
            "bool needs_engine_update",
            "TTF_TextEngine *engine",
            "void *engine_text",
          ]
        )
        const_set :TTF_TextEngine, struct(
          [
            "Uint32 version",
            "void *userdata",
            "function (*CreateText)()",
            "function (*DestroyText)()",
          ]
        )
      }
    end
  end
  private_constant :TTF

  TTF.included(self)
end
