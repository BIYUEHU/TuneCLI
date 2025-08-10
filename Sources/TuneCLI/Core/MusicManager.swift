enum MusicPlayingMode {
  case shuffle
  case repeatAll
  case repeatOne
  case none
}
class MusicManager {
  private let songList: [Song]
  var playingMode: MusicPlayingMode = .repeatAll
  var volume: Float = 1.0
  var currentSong: Song

  private var currentIndex: Int {
    songList.firstIndex(of: currentSong)!
  }

  private func playRandom() {
    play(at: Int.random(in: 0..<songList.count))
  }

  private func playSelf() {
  }

  init(songList: [Song]) {
    self.songList = songList
    currentSong = songList.first!
  }

  func play(at index: Int) {
    currentSong.reset()
    currentSong = songList[index]
    currentSong.setVolume(to: volume)
    currentSong.play()
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

  func togglePlay() {
    currentSong.toggle()
  }

  func downVolume() {
    volume = max(0.0, volume - 0.01)
    currentSong.setVolume(to: volume)
  }

  func upVolume() {
    volume = min(1.0, volume + 0.01)
    currentSong.setVolume(to: volume)
  }

  func toggleMode() {
    switch playingMode {
    case .repeatAll:
      playingMode = .repeatOne
    case .repeatOne:
      playingMode = .shuffle
    case .shuffle:
      playingMode = .none
    case .none:
      playingMode = .repeatAll
    }
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
    case .none:
      break
    }
  }
}
