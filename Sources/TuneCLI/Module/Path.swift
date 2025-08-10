import Foundation

let AUDIO_DIRECTORY = FileManager.default.currentDirectoryPath + "/audio"
let AUDIO_FILE_EXTENSION = "mp3"
let LRYIC_FILE_EXTENSION = "lrc"
func initDirectory() -> ([String], [String]) {
  if !FileManager.default.fileExists(atPath: AUDIO_DIRECTORY) {
    try! FileManager.default.createDirectory(
      atPath: AUDIO_DIRECTORY, withIntermediateDirectories: true, attributes: nil)
    return ([], [])
  }
  let items = try! FileManager.default.contentsOfDirectory(atPath: AUDIO_DIRECTORY)
  return (
    items.filter { $0.pathExtension == AUDIO_FILE_EXTENSION },
    items.filter { $0.pathExtension == LRYIC_FILE_EXTENSION }
  )
}
