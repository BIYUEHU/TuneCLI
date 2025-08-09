class ProgressBar: UIComponent {
  var frame: Rect
  var progress: Double  // 0.0 - 1.0
  var filledChar: Character
  var emptyChar: Character

  init(frame: Rect, progress: Double = 0.0, filledChar: Character = "█", emptyChar: Character = "░")
  {
    self.frame = frame
    self.progress = max(0.0, min(1.0, progress))
    self.filledChar = filledChar
    self.emptyChar = emptyChar
  }

  func render(in buffer: inout ScreenBuffer) {
    let width = frame.size.width
    let filledWidth = Int(Double(width) * progress)

    for x in 0..<width {
      let char = x < filledWidth ? filledChar : emptyChar
      buffer.setChar(char, at: Point(x: frame.minX + x, y: frame.minY))
    }
  }
}
