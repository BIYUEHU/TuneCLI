#include <stdio.h>
#include "saudio.h"

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("Usage: %s <audio file>\n", argv[0]);
        return -1;
    }
    printf("221");

    saudio_init();

    ma_sound *audio = saudio_load(argv[1]);
    if (audio == NULL)
    {
        printf("Failed to play audio file: %s\n", argv[1]);
        return -3;
    }

    printf("1");

    // float seconds = saudio_get_total_seconds(audio);
    // printf("Audio file length: %.2f seconds\n", seconds);

    saudio_play(audio);
    printf("Playing %s\n", argv[1]);
    printf("Press Enter to seek to 10 seconds...\n");
    getchar();
    saudio_seek(audio, 200.0f);

    printf("Press Enter to restart...\n");
    getchar();
    // saudio_reset(audio);
    saudio_seek(audio, 0.0f);

    printf("Press Enter to pause...\n");
    getchar();
    saudio_toggle(audio);

    printf("Press Enter to resume...\n");
    getchar();
    saudio_toggle(audio);

    printf("Press Enter to set volume to 0.1...\n");
    getchar();
    saudio_set_volume(audio, 0.1f);

    printf("Press Enter to quit...\n");
    getchar();

    saudio_uninit(audio);

    return 0;
}
