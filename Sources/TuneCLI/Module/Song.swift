import Foundation

import SAudio

struct SongStatus {
  let isPlaying: Bool
  let currentSeconds: Double
  let totalSeconds: Double
}
class Song: Equatable {
  private let audio: UnsafeMutablePointer<ma_sound>!

  private var playDate: Double? = nil

  private var alreadyPlayTime: Double = 0

  private let lyrics: Lyrics

  let path: String

  var name: String {
    return path.lastPathComponent
  }

  var isPlaying: Bool {
    return playDate != nil
  }

  let totalSeconds: Double

  var currentSeconds: Double {
    if let playDate = playDate {
      return getCurrentTime() - playDate + alreadyPlayTime
    }
    return alreadyPlayTime
  }

  var currentLyrics: Lyrics {
    let time = currentSeconds
    return lyrics.filter { lyric in time >= lyric.startTime && time < lyric.endTime }
  }

  init(path: String) {
    audio = saudio_load(path)
    if audio == nil {
      fatalError("Failed to load audio file: \(path)")
    }
    totalSeconds = Double(saudio_get_total_seconds(saudio_get_status(audio)))
    self.path = path

    self.lyrics =
      if let lryics = try? String(
        contentsOfFile:
          path.replacingOccurrences(
            of: "." + AUDIO_FILE_EXTENSION, with: "." + LRYIC_FILE_EXTENSION,
            options: .regularExpression), encoding: .utf8)
      {
        parseLyrics(lrcContent: lryics)
      } else {
        []
      }
  }

  func play() {
    saudio_play(audio)
    playDate = getCurrentTime()
  }

  func pause() {
    saudio_pause(audio)
    if let playDate = playDate {
      alreadyPlayTime += getCurrentTime() - playDate
    }
    playDate = nil
  }

  func toggle() {
    if isPlaying {
      pause()
    } else {
      play()
    }
  }

  func seek(to seconds: Double) {
    if seconds < 0 {
      return seek(to: 0)
    }
    if seconds > totalSeconds {
      return seek(to: totalSeconds)
    }

    alreadyPlayTime = seconds
    if isPlaying {
      playDate = getCurrentTime()
    }
    saudio_seek(audio, Float(seconds))
  }

  func reset() {
    saudio_reset(audio)
    alreadyPlayTime = 0
    playDate = nil
  }

  func setVolume(to volume: Double) {
    saudio_set_volume(audio, Float(volume))
  }

  deinit {
    saudio_uninit(audio)
  }

  static func == (lhs: Song, rhs: Song) -> Bool {
    return lhs.path == rhs.path
  }
}
