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

  init() {
    renderer.add(mainBox)
    renderer.add(infoLabel)
    renderer.add(songLabel)
    renderer.add(progressBar)
    renderer.add(
      Label(
        text: "Select a song to play:",
        frame: Rect(origin: Point(x: 3, y: 9), size: Size(width: UI.size.width - 6, height: 1)),
        alignment: .left
      ))
    renderer.add(playlist)
  }

  func render() {
    renderer.render()
  }
}
