import Foundation

import SAudio

struct TuneCLIAppOptions {
  let songList: [String]
  let directory: String
  let mode: MusicPlayingMode?
}
class TuneCLIApp: @unchecked Sendable {
  private let musicManager: MusicManager
  private let keyboardListener = KeyboardListener()
  private let ui = UI()

  init(options: TuneCLIAppOptions) {
    if saudio_init() != 1 {
      fatalError("Failed to initialize audio engine")
    }

    self.musicManager = MusicManager(options: options)
    self.ui.playlist.items = options.songList.map { getAudioFilename(filename: $0) }

    keyboardListener.onAny {
      if let key = WindowsKey(rawValue: $0) {
        self.handleKeyPress(key: key)
      }
    }
  }

  func run() {
    ui.load()

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
      musicManager.currentSong.toggle()
      updateSongLabel()
    case .Enter:
      musicManager.play(at: self.ui.playlist.selectedIndex)
      updateSongLabel()
    case .q:
      musicManager.currentSong.pause()
      ui.clear()
      ui.render()
      Thread.sleep(forTimeInterval: 0.3)
      print("Good bye~".cyan)
      Thread.sleep(forTimeInterval: 0.9)
      exit(0)
    case .k:
      updateplaylist(isDown: false)
    case .j:
      updateplaylist(isDown: true)
    case .h:
      musicManager.volume += 0.01
      updateInfoLabel()
    case .l:
      musicManager.volume -= 0.01
      updateInfoLabel()
    case .r:
      musicManager.playingMode = musicManager.playingMode.next()
      updateInfoLabel()
    case .w:
      musicManager.seek(seconds: 2)
      updateInfoLabel()
    case .s:
      musicManager.seek(seconds: -2)
      updateInfoLabel()
    case .a:
      musicManager.seek(seconds: 10)
      updateInfoLabel()
    case .d:
      musicManager.seek(seconds: -10)
      updateInfoLabel()
    default:
      return
    }
    ui.render()
  }

  private func updateProgressBar() {
    let progress = musicManager.currentSong.currentSeconds / musicManager.currentSong.totalSeconds
    if progress == ui.progressBar.progress {
      return
    }
    ui.progressBar.progress = progress
    updateInfoLabel()
  }

  private func updateInfoLabel() {
    if musicManager.currentSong.currentSeconds >= musicManager.currentSong.totalSeconds {
      musicManager.autoSwitch()
      updateSongLabel()
    }

    ui.infoLabel.text = "🔊: \(Int(musicManager.volume * 100))".yellow
    ui.infoLabel.text += " | "
    ui.infoLabel.text +=
      "🕒: \(formatSeconds(seconds: musicManager.currentSong.currentSeconds))/\(formatSeconds(seconds: musicManager.currentSong.totalSeconds))"
      .magenta
    ui.infoLabel.text += " | "
    ui.infoLabel.text += "📼: \(musicManager.playingMode)"
    ui.infoLabel.text += "".reset

    let lyrics = musicManager.currentSong.currentLyrics
    switch lyrics.count {
    case 0:
      ui.lyric1.text = ""
      ui.lyric2.text = ""
      ui.lyric3.text = ""
      break
    case 1:
      ui.lyric1.text = lyrics[0].content.red
      ui.lyric2.text = ""
      ui.lyric3.text = ""
      break
    case 2:
      ui.lyric1.text = lyrics[0].content.red
      ui.lyric2.text = lyrics[1].content.yellow
      ui.lyric3.text = ""
      break
    default:
      ui.lyric1.text = lyrics[0].content.red
      ui.lyric2.text = lyrics[1].content.yellow
      ui.lyric3.text = lyrics[2].content.green
      break
    }

    ui.render()
  }

  private func updateSongLabel() {
    ui.songLabel.text =
      if musicManager.currentSong.isPlaying {
        "🎵 Playing ".lightGreen
      } else {
        "🎵 Paused ".lightRed
      }
    ui.songLabel.text += getAudioFilename(filename: musicManager.currentSong.name).underline
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
