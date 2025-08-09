#ifndef SAUDIO_H
#define SAUDIO_H
#include "miniaudio.h"

#ifdef __cplusplus
extern "C"
{
#endif

  typedef struct saudio saudio;

  saudio *saudio_load(const char *filename);

  int saudio_is_playing(saudio *audio);

  float saudio_get_total_seconds(saudio *audio);

  float saudio_get_current_seconds(saudio *audio);

  void saudio_pause(saudio *audio);

  void saudio_play(saudio *audio);

  void saudio_toggle(saudio *audio);

  void saudio_seek(saudio *audio, float seconds);

  void saudio_set_volume(saudio *audio, float volume);

  void saudio_uninit(saudio *audio);

#ifdef __cplusplus
}
#endif

#endif
