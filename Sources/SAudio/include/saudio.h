#ifndef SAUDIO_H
#define SAUDIO_H
#include "miniaudio.h"

#ifdef __cplusplus
extern "C"
{
#endif

  typedef struct saudio_status saudio_status;

  int saudio_init();

  ma_sound *saudio_load(const char *filename);

  saudio_status *saudio_get_status(ma_sound *sound);

  int saudio_is_playing(saudio_status *status);

  float saudio_get_total_seconds(saudio_status *status);

  float saudio_get_current_seconds(saudio_status *status);

  void saudio_pause(ma_sound *sound);

  void saudio_play(ma_sound *sound);

  void saudio_toggle(ma_sound *sound);

  void saudio_seek(ma_sound *sound, float seconds);

  void saudio_set_volume(ma_sound *sound, float volume);

  void saudio_reset(ma_sound *sound);

  void saudio_uninit(ma_sound *sound);

#ifdef __cplusplus
}
#endif

#endif
