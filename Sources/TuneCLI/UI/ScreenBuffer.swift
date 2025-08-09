extension Character {
  var isFullWidth: Bool {
    let value = unicodeScalars.first!.value

    if (0x1F600...0x1F64F).contains(value)
      || (0x1F300...0x1F5FF).contains(value)
      || (0x1F680...0x1F6FF).contains(value)
      || (0x1F1E0...0x1F1FF).contains(value)
      || (0x4E00...0x9FFF).contains(value)
      || (0x3040...0x309F).contains(value)
      || (0x30A0...0x30FF).contains(value)
      || (0xFF00...0xFFEF).contains(value)
      || (0x2600...0x26FF).contains(value)
      || (0x2700...0x27BF).contains(value)
    {
      return true
    }

    return false
  }
}
extension String {
  var displayWidth: Int {
    var width = 0
    for char in self {
      width += char.isFullWidth ? 2 : 1
    }
    return width
  }

  func truncated(toDisplayWidth maxWidth: Int) -> String {
    var result = ""
    var currentWidth = 0

    for char in self {
      let charWidth = char.isFullWidth ? 2 : 1
      if currentWidth + charWidth > maxWidth {
        break
      }
      result.append(char)
      currentWidth += charWidth
    }
    return result
  }

  func padded(toDisplayWidth width: Int) -> String {
    let currentWidth = self.displayWidth
    if currentWidth >= width {
      return self.truncated(toDisplayWidth: width)
    }
    return self + String(repeating: " ", count: width - currentWidth)
  }
}
class ScreenBuffer {
  public var currentBuffer: [[Character]]
  private var previousBuffer: [[Character]]
  let size: Size

  init(size: Size) {
    self.size = size
    self.currentBuffer = Array(
      repeating: Array(repeating: " ", count: size.width), count: size.height)
    self.previousBuffer = Array(
      repeating: Array(repeating: " ", count: size.width), count: size.height)
  }

  func clear() {
    currentBuffer = Array(repeating: Array(repeating: " ", count: size.width), count: size.height)
  }

  func setChar(_ char: Character, at point: Point) {
    guard point.y >= 0 && point.y < size.height && point.x >= 0 && point.x < size.width else {
      return
    }
    currentBuffer[point.y][point.x] = char

    if char.isFullWidth && point.x + 1 < size.width {
      currentBuffer[point.y][point.x + 1] = "\u{0000}"
    }
  }

  func drawText(_ text: String, at point: Point, maxWidth: Int? = nil) {
    let displayText = maxWidth.map { text.truncated(toDisplayWidth: $0) } ?? text
    var currentX = point.x

    for char in displayText {
      setChar(char, at: Point(x: currentX, y: point.y))
      if char.isFullWidth {
        currentX += 2
      } else {
        currentX += 1
      }
    }
  }

  func drawHorizontalLine(at y: Int, from x1: Int, to x2: Int, char: Character = "─") {
    for x in x1...x2 {
      setChar(char, at: Point(x: x, y: y))
    }
  }

  func drawVerticalLine(at x: Int, from y1: Int, to y2: Int, char: Character = "│") {
    for y in y1...y2 {
      setChar(char, at: Point(x: x, y: y))
    }
  }

  func flush() {
    for y in 0..<size.height {
      Console.moveCursor(to: Point(x: 0, y: y))
      let line = String(currentBuffer[y])
      print(line, terminator: "")
    }
  }
}
