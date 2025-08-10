class Box: UIComponent {
  var frame: Rect
  let title: String?
  let style: BoxStyle

  enum BoxStyle {
    case single
    case double
    case rounded

    var chars:
      (
        topLeft: Character, topRight: Character, bottomLeft: Character, bottomRight: Character,
        horizontal: Character, vertical: Character
      )
    {
      switch self {
      case .single:
        return ("┌", "┐", "└", "┘", "─", "│")
      case .double:
        return ("╔", "╗", "╚", "╝", "═", "║")
      case .rounded:
        return ("╭", "╮", "╰", "╯", "─", "│")
      }
    }
  }

  init(frame: Rect, title: String? = nil, style: BoxStyle = .single) {
    self.frame = frame
    self.title = title
    self.style = style
  }

  func render(in buffer: inout ScreenBuffer) {
    let chars = style.chars

    buffer.setChar(chars.topLeft, at: frame.origin)
    buffer.setChar(chars.topRight, at: Point(x: frame.maxX - 1, y: frame.minY))
    buffer.setChar(chars.bottomLeft, at: Point(x: frame.minX, y: frame.maxY - 1))
    buffer.setChar(chars.bottomRight, at: Point(x: frame.maxX - 1, y: frame.maxY - 1))

    buffer.drawHorizontalLine(
      at: frame.minY, from: frame.minX + 1, to: frame.maxX - 2, char: chars.horizontal)
    buffer.drawHorizontalLine(
      at: frame.maxY - 1, from: frame.minX + 1, to: frame.maxX - 2, char: chars.horizontal)

    buffer.drawVerticalLine(
      at: frame.minX, from: frame.minY + 1, to: frame.maxY - 2, char: chars.vertical)
    buffer.drawVerticalLine(
      at: frame.maxX - 1, from: frame.minY + 1, to: frame.maxY - 2, char: chars.vertical)

    if let title = title, !title.isEmpty {
      let titleX = frame.minX + (frame.size.width - title.count) / 2
      buffer.drawText(" \(title) ", at: Point(x: titleX, y: frame.minY))
    }
  }
}
