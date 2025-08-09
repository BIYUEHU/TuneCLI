import SAudio

class Song {
  private var audio: OpaquePointer!

  init(_ path: String) {
    audio = saudio_load(path)
    if audio == nil {
      fatalError("Failed to load audio file: \(path)")
    }
  }

  func play() {
    saudio_play(audio)
  }

  func pause() {
    saudio_pause(audio)
  }

  func toggle() {
    if isPlaying {
      pause()
    } else {
      play()
    }
  }

  func seek(to seconds: Double) {
    saudio_seek(audio, Float(seconds))
  }

  var isPlaying: Bool {
    return saudio_is_playing(audio) == 1
  }

  var currentSeconds: Double {
    return Double(saudio_get_current_seconds(audio))
  }

  var totalSeconds: Double {
    return Double(saudio_get_total_seconds(audio))
  }

  deinit {
    saudio_uninit(audio)
  }
}
