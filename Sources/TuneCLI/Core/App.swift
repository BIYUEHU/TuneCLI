import Foundation

import SAudio

class TuneCLIApp: @unchecked Sendable {
  private let musicManager: MusicManager
  private let keyboardListener = KeyboardListener()
  private let ui = UI()

  init(songList: [String]) {
    if saudio_init() != 1 {
      fatalError("Failed to initialize audio engine")
    }

    self.musicManager = MusicManager(
      songList: songList.map { Song(path: AUDIO_DIRECTORY + "/" + $0) })
    self.ui.playlist.items = songList

    keyboardListener.onAny {
      if let key = WindowsKey(rawValue: $0) {
        self.handleKeyPress(key: key)
      }
    }
  }

  func run() {
    updateSongLabel()
    updateInfoLabel()
    ui.render()

    while true {
      updateProgressBar()
      if let key = keyboardListener.readNonBlocking() {
        if let windowsKey = WindowsKey(rawValue: key) {
          handleKeyPress(key: windowsKey)
        }
      }
      Thread.sleep(forTimeInterval: 0.01)
    }
  }

  private func handleKeyPress(key: WindowsKey) {
    switch key {
    case .p:
      musicManager.playPrevious()
      updateSongLabel()
    case .n:
      musicManager.playNext()
      updateSongLabel()
    case .Space:
      musicManager.togglePlay()
      updateSongLabel()
    case .q:
      exit(0)
    case .k:
      updateplaylist(isDown: false)
    case .j:
      updateplaylist(isDown: true)
    case .h:
      musicManager.upVolume()
      updateInfoLabel()
    case .l:
      musicManager.downVolume()
      updateInfoLabel()
    case .r:
      musicManager.toggleMode()
      updateInfoLabel()
    case .Enter:
      musicManager.play(at: self.ui.playlist.selectedIndex)
      updateSongLabel()
    default:
      return
    }
    ui.render()
  }

  private func updateProgressBar() {
    let song = musicManager.currentSong
    if song.isPlaying {
      ui.progressBar.progress =
        song.currentSeconds / song.totalSeconds
      updateInfoLabel()
    }
  }

  private func updateInfoLabel() {
    let song = musicManager.currentSong

    if song.currentSeconds >= song.totalSeconds {
      musicManager.autoSwitch()
      updateSongLabel()
      updateInfoLabel()
      return
    }

    ui.infoLabel.text = "📢: \(Int(musicManager.volume * 100))".bold.yellow
    ui.infoLabel.text += " | "
    ui.infoLabel.text +=
      "🕒: \(formatSeconds(seconds: song.currentSeconds))/\(formatSeconds(seconds: song.totalSeconds))"
      .bold.green
    ui.infoLabel.text += " | "
    ui.infoLabel.text += "🔊: \(musicManager.playingMode)".bold.blue
    ui.render()

  }

  private func updateSongLabel() {
    ui.songLabel.text =
      if musicManager.currentSong.isPlaying {
        "🎵 Play "
      } else {
        "🎵 Pause "
      }
    ui.songLabel.text += "\(musicManager.currentSong.name)"
    ui.render()

    // ui.songLabel.text = "🙅 No Song playing"
  }

  private func updateplaylist(isDown: Bool) {
    let currentIndex = self.ui.playlist.selectedIndex
    let maxIndex = self.ui.playlist.items.count - 1
    self.ui.playlist.selectedIndex =
      if isDown, currentIndex == maxIndex {
        0
      } else if !isDown && currentIndex == 0 {
        maxIndex
      } else {
        currentIndex + (isDown ? 1 : -1)
      }
  }

}
