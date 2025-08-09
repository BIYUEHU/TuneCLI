// import ArgumentParser
// import Foundation

// let AUDIO_DIRECTORY = FileManager.default.currentDirectoryPath + "/audio"
// let AUDIO_FILE_EXTENSION = "mp3"
// let LRYIC_FILE_EXTENSION = "lrc"

// func initDirectory() -> [String] {
//     if !FileManager.default.fileExists(atPath: AUDIO_DIRECTORY) {
//         try! FileManager.default.createDirectory(
//             atPath: AUDIO_DIRECTORY, withIntermediateDirectories: true, attributes: nil)
//         return []
//     }
//     let items = try! FileManager.default.contentsOfDirectory(atPath: AUDIO_DIRECTORY)
//     let audioFiles = items.filter { $0.pathExtension == AUDIO_FILE_EXTENSION }
//     let lryicFiles = items.filter { $0.pathExtension == LRYIC_FILE_EXTENSION }
//     print("Audio files: \(audioFiles)")
//     print("Lyrics files: \(lryicFiles)")
//     return audioFiles
// }

// let list = initDirectory()
// print(AUDIO_DIRECTORY)

// let song = Song(AUDIO_DIRECTORY + "/" + list[0])
// song.play()

// let x = readLine()!

// print("Starting Tune CLI :" + AUDIO_DIRECTORY)

// 在你的 main.swift 中：
// let renderer = Renderer()

// // 主界面框
// let playerBox = Box(
//     frame: Rect(
//         origin: Point(x: 2, y: 1),
//         size: Size(width: 60, height: 20)),
//     title: "🎵 SwiftTune Player",
//     style: .single
// )

// // 当前播放
// let nowPlaying = Label(
//     text: "♪ Now Playing: 暂无",
//     frame: Rect(
//         origin: Point(x: 4, y: 3),
//         size: Size(width: 56, height: 1))
// )

// // 播放进度
// let progress = ProgressBar(
//     frame: Rect(
//         origin: Point(x: 4, y: 5),
//         size: Size(width: 56, height: 1))
// )

// // 播放列表
// let playlist = ListView(
//     frame: Rect(
//         origin: Point(x: 4, y: 7),
//         size: Size(width: 56, height: 10))
// )

// renderer.add(playerBox)
// renderer.add(nowPlaying)
// renderer.add(progress)
// renderer.add(playlist)

// // 更新数据并重新渲染
// playlist.items = ["Song1.mp3", "Song2.mp3", "Song3.mp3"]
// progress.progress = 0.5
// renderer.render()

// 创建渲染器
let renderer = Renderer()

// 创建组件
let mainBox = Box(
    frame: Rect(origin: Point(x: 1, y: 1), size: Size(width: 90, height: 35)),
    title: "Tune CLI - A Console Muic Player Base On Swift",
    style: .rounded
)

let songLabel = Label(
    text: "🎵Now Playing: 暂无",
    frame: Rect(origin: Point(x: 3, y: 3), size: Size(width: 86, height: 1)),
    alignment: .left
)

let progressBar = ProgressBar(
    frame: Rect(origin: Point(x: 3, y: 5), size: Size(width: 86, height: 1)), progress: 0.3
)

let playlist = ListView(
    frame: Rect(origin: Point(x: 3, y: 7), size: Size(width: 86, height: 10)),
    items: ["Song 1.mp3", "Song 2.mp3", "Song 3.mp3"]
)

renderer.add(mainBox)
renderer.add(songLabel)
renderer.add(progressBar)
renderer.add(playlist)

let listener = KeyboardListener()
listener.on(key: .Enter) {

    playlist.selectedIndex =
        playlist.selectedIndex + 1 == playlist.items.count ? 0 : playlist.selectedIndex + 1
    renderer.render()
}
listener.start()
