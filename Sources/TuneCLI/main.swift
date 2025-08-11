import ArgumentParser

struct TuneCLI: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "TuneCLI",
    abstract: AppInfo.description,
    version: AppInfo.version
  )

  @Argument(help: "audio directory")
  var directory: String = "./audio"

  @Flag(help: "repeat all the songs")
  var mode: MusicPlayingMode?

  func run() throws {
    if directory.isEmpty {
      print("Please provide a valid directory".red)
      return
    }

    let directory = self.directory.last! == "/" ? self.directory : "\(self.directory)/"

    let (audioFiles, _) = initDirectory(directory: directory)

    if audioFiles.isEmpty {
      print("No audio files found in the directory \(directory)".red)
      return
    }

    TuneCLIApp(
      options: TuneCLIAppOptions(songList: audioFiles, directory: directory, mode: mode)
    )
    .run()
  }
}

TuneCLI.main()
