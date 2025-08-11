import Foundation

let AUDIO_FILE_EXTENSION = "mp3"
let LRYIC_FILE_EXTENSION = "lrc"
func initDirectory(directory: String) -> ([String], [String]) {
  if !FileManager.default.fileExists(atPath: directory) {
    return ([], [])
  }
  let items = try! FileManager.default.contentsOfDirectory(atPath: directory)
  return (
    items.filter { $0.pathExtension == AUDIO_FILE_EXTENSION },
    items.filter { $0.pathExtension == LRYIC_FILE_EXTENSION }
  )
}
func getAudioFilename(filename: String) -> String {
  return filename.replacingOccurrences(of: ".\(AUDIO_FILE_EXTENSION)", with: "")
}
