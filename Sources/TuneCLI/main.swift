import ArgumentParser
import Foundation

let AUDIO_DIRECTORY = FileManager.default.currentDirectoryPath + "/audio"
let AUDIO_FILE_EXTENSION = "mp3"
let LRYIC_FILE_EXTENSION = "lrc"

func initDirectory() -> [String] {
    if !FileManager.default.fileExists(atPath: AUDIO_DIRECTORY) {
        try! FileManager.default.createDirectory(
            atPath: AUDIO_DIRECTORY, withIntermediateDirectories: true, attributes: nil)
        return []
    }
    let items = try! FileManager.default.contentsOfDirectory(atPath: AUDIO_DIRECTORY)
    let audioFiles = items.filter { $0.pathExtension == AUDIO_FILE_EXTENSION }
    let lryicFiles = items.filter { $0.pathExtension == LRYIC_FILE_EXTENSION }
    print("Audio files: \(audioFiles)")
    print("Lyrics files: \(lryicFiles)")
    return audioFiles
}

let list = initDirectory()
print(AUDIO_DIRECTORY)

let song = Song(AUDIO_DIRECTORY + "/" + list[0])
song.play()

let x = readLine()!

print("Starting Tune CLI :" + AUDIO_DIRECTORY)
