#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct saudio
{
  ma_engine *engine;
  ma_sound *sound;
} saudio;

char *utf8_to_ansi(const char *utf8_str)
{
  int wlen = MultiByteToWideChar(CP_UTF8, 0, utf8_str, -1, NULL, 0);
  if (wlen == 0)
    return NULL;

  wchar_t *wstr = malloc(wlen * sizeof(wchar_t));
  MultiByteToWideChar(CP_UTF8, 0, utf8_str, -1, wstr, wlen);

  int alen = WideCharToMultiByte(CP_ACP, 0, wstr, -1, NULL, 0, NULL, NULL);
  if (alen == 0)
  {
    free(wstr);
    return NULL;
  }

  char *ansi_str = malloc(alen);
  WideCharToMultiByte(CP_ACP, 0, wstr, -1, ansi_str, alen, NULL, NULL);

  free(wstr);
  return ansi_str;
}

saudio *saudio_load(const char *filename)
{
  ma_engine *engine = malloc(sizeof(ma_engine));
  if (engine == NULL)
  {
    return NULL;
  }
  if (ma_engine_init(NULL, engine) != MA_SUCCESS)
  {
    free(engine);
    return NULL;
  }

  ma_sound *sound = malloc(sizeof(ma_sound));
  if (sound == NULL)
  {
    return NULL;
  }

  char *converted_filename = utf8_to_ansi(filename);
  if (converted_filename == NULL)
  {
    return NULL;
  }

  if (ma_sound_init_from_file(engine, converted_filename, 0, NULL, NULL, sound) != MA_SUCCESS)
  {
    free(sound);
    return NULL;
  }

  saudio *saudio = malloc(sizeof(saudio));
  if (saudio == NULL)
  {
    return NULL;
  }
  saudio->engine = engine;
  saudio->sound = sound;
  return saudio;
}

int saudio_is_playing(saudio *audio)
{
  return ma_sound_is_playing(audio->sound);
}

float saudio_get_total_seconds(saudio *audio)
{

  float lengthInSeconds;
  if (ma_sound_get_length_in_seconds(audio->sound, &lengthInSeconds) != MA_SUCCESS)
  {
    fprintf(stderr, "Failed to get sound length in seconds.\n");
    return 0.0f;
  }
  return lengthInSeconds;
}

float saudio_get_current_seconds(saudio *audio)
{
  float currentSeconds;
  if (ma_sound_get_cursor_in_seconds(audio->sound, &currentSeconds) != MA_SUCCESS)
  {
    return 0.0f;
  }
  return currentSeconds;
}

void saudio_pause(saudio *audio)
{
  ma_sound_stop(audio->sound);
}

void saudio_play(saudio *audio)
{
  ma_sound_start(audio->sound);
}

void saudio_toggle(saudio *audio)
{
  if (saudio_is_playing(audio))
  {
    saudio_pause(audio);
  }
  else
  {
    saudio_play(audio);
  }
}

void saudio_seek(saudio *audio, float seconds)
{
  ma_sound_seek_to_second(audio->sound, seconds);
}

void saudio_set_volume(saudio *audio, float volume)
{
  ma_sound_set_volume(audio->sound, volume);
}

void saudio_uninit(saudio *audio)
{
  ma_sound_uninit(audio->sound);
  free(audio->sound);
  audio->sound = NULL;
  ma_engine_uninit(audio->engine);
  free(audio->engine);
  audio->engine = NULL;
  free(audio);
}
