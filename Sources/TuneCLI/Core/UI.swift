import Foundation

class UI {
  private static let size = Console.getTerminalSize()
  private let renderer = Renderer()

  private let mainBox = Box(
    frame: Rect(
      origin: Point(x: 1, y: 1), size: Size(width: size.width - 2, height: size.height - 2)),
    title: "Tune CLI - A Console Muic Player Base On Swift",
    style: .rounded
  )

  let infoLabel = Label(
    text: "",
    frame: Rect(origin: Point(x: 3, y: 3), size: Size(width: size.width - 6, height: 1)),
    alignment: .left
  )

  let songLabel = Label(
    text: "",
    frame: Rect(origin: Point(x: 3, y: 5), size: Size(width: size.width - 6, height: 1)),
    alignment: .left
  )

  let progressBar = ProgressBar(
    frame: Rect(origin: Point(x: 3, y: 7), size: Size(width: size.width - 6, height: 1)),
    progress: 0
  )

  let playlist = ListView(
    frame: Rect(
      origin: Point(x: 3, y: 11), size: Size(width: size.width - 6, height: size.height - 10)),
    items: [],
  )

  let lyric1 = Label(
    text: "",
    frame: Rect(
      origin: Point(x: 3, y: UI.size.height - 21),
      size: Size(width: UI.size.width - 6, height: 1)),
    alignment: .center
  )

  let lyric2 = Label(
    text: "",
    frame: Rect(
      origin: Point(x: 3, y: UI.size.height - 19),
      size: Size(width: UI.size.width - 6, height: 1)),
    alignment: .center
  )

  let lyric3 = Label(
    text: "",
    frame: Rect(
      origin: Point(x: 3, y: UI.size.height - 17),
      size: Size(width: UI.size.width - 6, height: 1)),
    alignment: .center
  )

  func load() {
    // Loading animation
    let progress = ProgressBar(
      frame: Rect(
        origin: Point(x: 3, y: UI.size.height / 2), size: Size(width: UI.size.width - 4, height: 2)),
      progress: 0
    )
    renderer.add(
      Label(
        text: "Loading...".magenta,
        frame: Rect(
          origin: Point(x: 3, y: UI.size.height / 2 - 2),
          size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .center
      ))
    renderer.add(progress)

    while progress.progress < 1 {
      progress.progress += 0.01
      renderer.render()
      Thread.sleep(forTimeInterval: 0.01)
    }

    renderer.removeAll()
    renderer.render()

    renderer.add(mainBox)
    renderer.add(infoLabel)
    renderer.add(songLabel)
    renderer.add(progressBar)
    renderer.add(
      Label(
        text: "Select a song to play:".magenta,
        frame: Rect(origin: Point(x: 3, y: 9), size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .left
      ))
    renderer.add(lyric1)
    renderer.add(lyric2)
    renderer.add(lyric3)
    // renderer.add(
    //   Label(
    //     text: "Width: \(UI.size.width) Height: \(UI.size.height)",
    //     frame: Rect(
    //       origin: Point(x: 3, y: UI.size.height - 13),
    //       size: Size(width: UI.size.width - 6, height: 1)),
    //     alignment: .left
    //   ))
    renderer.add(
      Label(
        text: "<Enter>: Play selected | <Space>: Toggle status".blue,
        frame: Rect(
          origin: Point(x: 3, y: UI.size.height - 13),
          size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .center
      ))
    renderer.add(
      Label(
        text: "\("q: Quit | p: Play previous | n: Play next | r: Toggle mode".blue)\("".reset)",
        frame: Rect(
          origin: Point(x: 3, y: UI.size.height - 11),
          size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .center
      ))
    renderer.add(
      Label(
        text:
          "\("k: Select next | j: Select previous | h: Turn up | k: Turn down".blue)\("".reset)",
        frame: Rect(
          origin: Point(x: 3, y: UI.size.height - 9),
          size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .center
      ))
    renderer.add(
      Label(
        text:
          "\("w: Seek 2s | s: Seek -2s | a: Seek 10s | d: Seek -10s".blue)\("".reset)",
        frame: Rect(
          origin: Point(x: 3, y: UI.size.height - 7),
          size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .center
      ))
    renderer.add(
      Label(
        text:
          "\("Made with あい by Arimura Sena \("github@biyuehu".underline)".cyan)\("".reset)",
        frame: Rect(
          origin: Point(x: 3, y: UI.size.height - 5),
          size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .center
      ))
    renderer.add(playlist)
  }

  func clear() {
    renderer.removeAll()
  }

  func render() {
    renderer.render()
  }
}
