import ArgumentParser

struct SwiftTune: ParsableCommand {
  @Argument(help: "音乐目录")
  var directory: String = "."

  @Flag(help: "随机播放")
  var shuffle: Bool = false

  func run() throws {

    let (audioFiles, _) = initDirectory()

    let application = TuneCLIApp(songList: audioFiles)
    application.run()
  }
}

SwiftTune.main()
