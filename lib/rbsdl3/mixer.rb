# frozen_string_literal: true
require_relative "../rbsdl3"
require_relative "sdl"

module SDL3
  using BindingsRefinement
  SDL_mixer = proc {
    # Ruby wrappers for SDL_mixer macros
    #
    const_set :SDL_MIXER_MAJOR_VERSION, 3
    const_set :SDL_MIXER_MINOR_VERSION, 2
    const_set :SDL_MIXER_MICRO_VERSION, 0
    const_set :SDL_MIXER_VERSION, SDL_VERSIONNUM(SDL_MIXER_MAJOR_VERSION, SDL_MIXER_MINOR_VERSION, SDL_MIXER_MICRO_VERSION)
    module_function def SDL_MIXER_VERSION_ATLEAST(x, y, z) = ((SDL_MIXER_MAJOR_VERSION >= x) && (SDL_MIXER_MAJOR_VERSION > x || SDL_MIXER_MINOR_VERSION >= y) && (SDL_MIXER_MAJOR_VERSION > x || SDL_MIXER_MINOR_VERSION > y || SDL_MIXER_MICRO_VERSION >= z))

    # Fiddle declarations for SDL_mixer functions, structs, and enums
    #
    extern "int MIX_Version(void)"
    extern "bool MIX_Init(void)"
    extern "void MIX_Quit(void)"
    extern "int MIX_GetNumAudioDecoders(void)"
    extern "char * MIX_GetAudioDecoder(int)"
    extern "MIX_Mixer * MIX_CreateMixerDevice(SDL_AudioDeviceID, SDL_AudioSpec *)"
    extern "MIX_Mixer * MIX_CreateMixer(SDL_AudioSpec *)"
    extern "void MIX_DestroyMixer(MIX_Mixer *)"
    extern "SDL_PropertiesID MIX_GetMixerProperties(MIX_Mixer *)"
    extern "bool MIX_GetMixerFormat(MIX_Mixer *, SDL_AudioSpec *)"
    extern "void MIX_LockMixer(MIX_Mixer *)"
    extern "void MIX_UnlockMixer(MIX_Mixer *)"
    extern "MIX_Audio * MIX_LoadAudio_IO(MIX_Mixer *, SDL_IOStream *, bool, bool)"
    extern "MIX_Audio * MIX_LoadAudio(MIX_Mixer *, char *, bool)"
    extern "MIX_Audio * MIX_LoadAudioNoCopy(MIX_Mixer *, void *, size_t, bool)"
    extern "MIX_Audio * MIX_LoadAudioWithProperties(SDL_PropertiesID)"
    extern "MIX_Audio * MIX_LoadRawAudio_IO(MIX_Mixer *, SDL_IOStream *, SDL_AudioSpec *, bool)"
    extern "MIX_Audio * MIX_LoadRawAudio(MIX_Mixer *, void *, size_t, SDL_AudioSpec *)"
    extern "MIX_Audio * MIX_LoadRawAudioNoCopy(MIX_Mixer *, void *, size_t, SDL_AudioSpec *, bool)"
    extern "MIX_Audio * MIX_CreateSineWaveAudio(MIX_Mixer *, int, float, Sint64)"
    extern "SDL_PropertiesID MIX_GetAudioProperties(MIX_Audio *)"
    extern "Sint64 MIX_GetAudioDuration(MIX_Audio *)"
    extern "bool MIX_GetAudioFormat(MIX_Audio *, SDL_AudioSpec *)"
    extern "void MIX_DestroyAudio(MIX_Audio *)"
    extern "MIX_Track * MIX_CreateTrack(MIX_Mixer *)"
    extern "void MIX_DestroyTrack(MIX_Track *)"
    extern "SDL_PropertiesID MIX_GetTrackProperties(MIX_Track *)"
    extern "MIX_Mixer * MIX_GetTrackMixer(MIX_Track *)"
    extern "bool MIX_SetTrackAudio(MIX_Track *, MIX_Audio *)"
    extern "bool MIX_SetTrackAudioStream(MIX_Track *, SDL_AudioStream *)"
    extern "bool MIX_SetTrackIOStream(MIX_Track *, SDL_IOStream *, bool)"
    extern "bool MIX_SetTrackRawIOStream(MIX_Track *, SDL_IOStream *, SDL_AudioSpec *, bool)"
    extern "bool MIX_TagTrack(MIX_Track *, char *)"
    extern "void MIX_UntagTrack(MIX_Track *, char *)"
    extern "char ** MIX_GetTrackTags(MIX_Track *, int *)"
    extern "MIX_Track ** MIX_GetTaggedTracks(MIX_Mixer *, char *, int *)"
    extern "bool MIX_SetTrackPlaybackPosition(MIX_Track *, Sint64)"
    extern "Sint64 MIX_GetTrackPlaybackPosition(MIX_Track *)"
    extern "Sint64 MIX_GetTrackFadeFrames(MIX_Track *)"
    extern "int MIX_GetTrackLoops(MIX_Track *)"
    extern "bool MIX_SetTrackLoops(MIX_Track *, int)"
    extern "MIX_Audio * MIX_GetTrackAudio(MIX_Track *)"
    extern "SDL_AudioStream * MIX_GetTrackAudioStream(MIX_Track *)"
    extern "Sint64 MIX_GetTrackRemaining(MIX_Track *)"
    extern "Sint64 MIX_TrackMSToFrames(MIX_Track *, Sint64)"
    extern "Sint64 MIX_TrackFramesToMS(MIX_Track *, Sint64)"
    extern "Sint64 MIX_AudioMSToFrames(MIX_Audio *, Sint64)"
    extern "Sint64 MIX_AudioFramesToMS(MIX_Audio *, Sint64)"
    extern "Sint64 MIX_MSToFrames(int, Sint64)"
    extern "Sint64 MIX_FramesToMS(int, Sint64)"
    extern "bool MIX_PlayTrack(MIX_Track *, SDL_PropertiesID)"
    extern "bool MIX_PlayTag(MIX_Mixer *, char *, SDL_PropertiesID)"
    extern "bool MIX_PlayAudio(MIX_Mixer *, MIX_Audio *)"
    extern "bool MIX_StopTrack(MIX_Track *, Sint64)"
    extern "bool MIX_StopAllTracks(MIX_Mixer *, Sint64)"
    extern "bool MIX_StopTag(MIX_Mixer *, char *, Sint64)"
    extern "bool MIX_PauseTrack(MIX_Track *)"
    extern "bool MIX_PauseAllTracks(MIX_Mixer *)"
    extern "bool MIX_PauseTag(MIX_Mixer *, char *)"
    extern "bool MIX_ResumeTrack(MIX_Track *)"
    extern "bool MIX_ResumeAllTracks(MIX_Mixer *)"
    extern "bool MIX_ResumeTag(MIX_Mixer *, char *)"
    extern "bool MIX_TrackPlaying(MIX_Track *)"
    extern "bool MIX_TrackPaused(MIX_Track *)"
    extern "bool MIX_SetMixerGain(MIX_Mixer *, float)"
    extern "float MIX_GetMixerGain(MIX_Mixer *)"
    extern "bool MIX_SetTrackGain(MIX_Track *, float)"
    extern "float MIX_GetTrackGain(MIX_Track *)"
    extern "bool MIX_SetTagGain(MIX_Mixer *, char *, float)"
    extern "bool MIX_SetMixerFrequencyRatio(MIX_Mixer *, float)"
    extern "float MIX_GetMixerFrequencyRatio(MIX_Mixer *)"
    extern "bool MIX_SetTrackFrequencyRatio(MIX_Track *, float)"
    extern "float MIX_GetTrackFrequencyRatio(MIX_Track *)"
    extern "bool MIX_SetTrackOutputChannelMap(MIX_Track *, int *, int)"
    const_set :MIX_StereoGains, struct(
      [
        "float left",
        "float right",
      ]
    )
    extern "bool MIX_SetTrackStereo(MIX_Track *, MIX_StereoGains *)"
    const_set :MIX_Point3D, struct(
      [
        "float x",
        "float y",
        "float z",
      ]
    )
    extern "bool MIX_SetTrack3DPosition(MIX_Track *, MIX_Point3D *)"
    extern "bool MIX_GetTrack3DPosition(MIX_Track *, MIX_Point3D *)"
    extern "MIX_Group * MIX_CreateGroup(MIX_Mixer *)"
    extern "void MIX_DestroyGroup(MIX_Group *)"
    extern "SDL_PropertiesID MIX_GetGroupProperties(MIX_Group *)"
    extern "MIX_Mixer * MIX_GetGroupMixer(MIX_Group *)"
    extern "bool MIX_SetTrackGroup(MIX_Track *, MIX_Group *)"
    typealias "MIX_TrackStoppedCallback", "function (*pointer)()"
    const_set :MIX_TrackStoppedCallback, "void MIX_TrackStoppedCallback(void *, MIX_Track *)"
    extern "bool MIX_SetTrackStoppedCallback(MIX_Track *, MIX_TrackStoppedCallback, void *)"
    typealias "MIX_TrackMixCallback", "function (*pointer)()"
    const_set :MIX_TrackMixCallback, "void MIX_TrackMixCallback(void *, MIX_Track *, SDL_AudioSpec *, float *, int)"
    extern "bool MIX_SetTrackRawCallback(MIX_Track *, MIX_TrackMixCallback, void *)"
    extern "bool MIX_SetTrackCookedCallback(MIX_Track *, MIX_TrackMixCallback, void *)"
    typealias "MIX_GroupMixCallback", "function (*pointer)()"
    const_set :MIX_GroupMixCallback, "void MIX_GroupMixCallback(void *, MIX_Group *, SDL_AudioSpec *, float *, int)"
    extern "bool MIX_SetGroupPostMixCallback(MIX_Group *, MIX_GroupMixCallback, void *)"
    typealias "MIX_PostMixCallback", "function (*pointer)()"
    const_set :MIX_PostMixCallback, "void MIX_PostMixCallback(void *, MIX_Mixer *, SDL_AudioSpec *, float *, int)"
    extern "bool MIX_SetPostMixCallback(MIX_Mixer *, MIX_PostMixCallback, void *)"
    extern "int MIX_Generate(MIX_Mixer *, void *, int)"
    extern "MIX_AudioDecoder * MIX_CreateAudioDecoder(char *, SDL_PropertiesID)"
    extern "MIX_AudioDecoder * MIX_CreateAudioDecoder_IO(SDL_IOStream *, bool, SDL_PropertiesID)"
    extern "void MIX_DestroyAudioDecoder(MIX_AudioDecoder *)"
    extern "SDL_PropertiesID MIX_GetAudioDecoderProperties(MIX_AudioDecoder *)"
    extern "bool MIX_GetAudioDecoderFormat(MIX_AudioDecoder *, SDL_AudioSpec *)"
    extern "int MIX_DecodeAudio(MIX_AudioDecoder *, void *, int, SDL_AudioSpec *)"
  }
  private_constant :SDL_mixer

  SDL_mixer.call
end
