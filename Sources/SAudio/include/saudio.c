#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"
#include <stdio.h>
#include <stdlib.h>

static ma_engine engine;

int saudio_init()
{
  return ma_engine_init(NULL, &engine) == MA_SUCCESS;
}

typedef struct saudio_status
{
  int is_playing;
  float current_seconds;
  float total_seconds;
} saudio_status;

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

ma_sound *saudio_load(const char *filename)
{
  ma_sound *sound = malloc(sizeof(ma_sound));

  char *converted_filename = utf8_to_ansi(filename);
  if (converted_filename == NULL)
  {
    fprintf(stderr, "Failed to convert filename to ANSI at %s.\n", filename);
    return NULL;
  }

  if (ma_sound_init_from_file(&engine, converted_filename, 0, NULL, NULL, sound) != MA_SUCCESS)
  {
    fprintf(stderr, "Failed to load sound %s.\n", filename);
    free(sound);
    free(converted_filename);
    return NULL;
  }

  return sound;
}

saudio_status *saudio_get_status(ma_sound *sound)
{
  saudio_status *status = malloc(sizeof(saudio_status));

  status->is_playing = ma_sound_is_playing(sound);

  if (ma_sound_get_cursor_in_seconds(sound, &status->current_seconds) != MA_SUCCESS)
  {
    status->current_seconds = 0.0f;
  }

  if (ma_sound_get_length_in_seconds(sound, &status->total_seconds) != MA_SUCCESS)
  {
    status->total_seconds = 0.0f;
  }

  return status;
}

int saudio_is_playing(saudio_status *status)
{
  return status->is_playing;
};

float saudio_get_total_seconds(saudio_status *status)
{
  return status->total_seconds;
};

float saudio_get_current_seconds(saudio_status *status)
{
  return status->current_seconds;
};

void saudio_pause(ma_sound *sound)
{
  ma_sound_stop(sound);
}

void saudio_play(ma_sound *sound)
{
  ma_sound_start(sound);
}

void saudio_toggle(ma_sound *sound)
{
  if (saudio_is_playing(saudio_get_status(sound)))
  {
    saudio_pause(sound);
  }
  else
  {
    saudio_play(sound);
  }
}

void saudio_seek(ma_sound *sound, float seconds)
{
  ma_sound_seek_to_second(sound, seconds);
}

void saudio_reset(ma_sound *sound)
{
  ma_sound_stop(sound);
  ma_sound_seek_to_second(sound, 0.0f);
}

void saudio_set_volume(ma_sound *sound, float volume)
{
  ma_sound_set_volume(sound, volume);
}

void saudio_uninit(ma_sound *sound)
{
  ma_sound_uninit(sound);
  free(sound);
  sound = NULL;
}
