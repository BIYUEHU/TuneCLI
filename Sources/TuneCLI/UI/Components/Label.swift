class Label: UIComponent {
  var frame: Rect
  var text: String
  var alignment: TextAlignment

  enum TextAlignment {
    case left, center, right
  }

  init(text: String, frame: Rect, alignment: TextAlignment = .left) {
    self.text = text
    self.frame = frame
    self.alignment = alignment
  }

  func render(in buffer: inout ScreenBuffer) {
    let maxWidth = frame.size.width
    let displayText = String(text.prefix(maxWidth))

    let x: Int
    switch alignment {
    case .left:
      x = frame.minX
    case .center:
      x = frame.minX + (maxWidth - displayText.count) / 2
    case .right:
      x = frame.minX + maxWidth - displayText.count
    }

    buffer.drawText(displayText, at: Point(x: x, y: frame.minY))
  }
}
