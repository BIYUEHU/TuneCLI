import ArgumentParser

import Foundation

enum MusicPlayingMode: String, EnumerableFlag {
  case shuffle = "shuffle"
  case repeatAll = "repeat-all"
  case repeatOne = "repeat-one"
  func next() -> MusicPlayingMode {
    switch self {
    case .shuffle:
      return .repeatAll
    case .repeatAll:
      return .repeatOne
    case .repeatOne:
      return .shuffle
    }
  }
}
class MusicManager {
  private let options: TuneCLIAppOptions
  private let songList: [Song]
  var currentSong: Song

  private var config: Config {
    get {
      let configPath = options.directory + CONFIG_FILE_NAME

      if let config = try? String(contentsOfFile: configPath, encoding: .utf8) {
        return parseConfig(config: config)
      }
      return [:]
    }
    set {
      try! stringifyConfig(config: newValue).write(
        to: URL(fileURLWithPath: options.directory + CONFIG_FILE_NAME), atomically: true,
        encoding: .utf8)
    }
  }

  private var currentIndex: Int {
    // songList.firstIndex(of: currentSong)!
    get {
      if let index = config["current-index"], let index = Int(index), index < songList.count,
        index >= 0
      {
        currentSong = songList[index]
        return index
      }
      return 0
    }
    set {
      config["current-index"] = String(newValue)
    }
  }

  var playingMode: MusicPlayingMode {
    get {
      if let mode = config["playing-mode"], let mode = MusicPlayingMode(rawValue: mode) {
        return mode
      }
      if let mode = options.mode {
        return mode
      }
      return .repeatAll
    }
    set {
      config["playing-mode"] = newValue.rawValue
    }
  }

  var volume: Double {
    get {
      if let volume = config["volume"], let volume = Double(volume) {
        return volume
      }
      return 1.0
    }
    set {
      let volume: Double = if newValue < 0 { 0 } else if newValue > 1 { 1 } else { newValue }
      config["volume"] = String(volume)
      currentSong.setVolume(to: volume)
    }
  }

  private func playRandom() {
    play(at: Int.random(in: 0..<songList.count))
  }

  private func playSelf() {
    play(at: currentIndex)
  }

  init(options: TuneCLIAppOptions) {
    self.options = options
    self.songList = options.songList.map { Song(path: options.directory + $0) }
    currentSong = songList.first!

    currentSong = songList[currentIndex]
    if let mode = options.mode {
      playingMode = mode
    }
  }

  func play(at index: Int) {
    currentSong.reset()
    currentSong = songList[index]
    currentSong.setVolume(to: volume)
    currentSong.play()
    currentIndex = index
  }

  func playNext() {
    if playingMode == .shuffle {
      playRandom()
      return
    }

    let currentIndex = self.currentIndex
    let index =
      if currentIndex < songList.count - 1 {
        currentIndex + 1
      } else {
        0
      }
    play(at: index)
  }

  func playPrevious() {
    if playingMode == .shuffle {
      playRandom()
      return
    }

    let currentIndex = self.currentIndex

    let index =
      if currentIndex > 0 {
        currentIndex - 1
      } else {
        songList.count - 1
      }
    play(at: index)
  }

  func autoSwitch() {
    switch playingMode {
    case .repeatAll:
      playNext()
    case .repeatOne:
      playSelf()
      break
    case .shuffle:
      playRandom()
    }
  }

  func seek(seconds: Int) {
    currentSong.seek(to: currentSong.currentSeconds + Double(seconds))
  }
}
