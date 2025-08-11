import Foundation

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
    let cleanText = self.removingANSIEscapes
    var width = 0
    for char in cleanText {
      width += char.isFullWidth ? 2 : 1
    }
    return width
  }

  var removingANSIEscapes: String {
    let ansiPattern = "\\u{001B}\\[[0-9;]*[a-zA-Z]"

    do {
      let regex = try NSRegularExpression(pattern: ansiPattern, options: [])
      let range = NSRange(location: 0, length: self.utf16.count)
      return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    } catch {
      return self.manuallyRemoveANSI()
    }
  }

  private func manuallyRemoveANSI() -> String {
    var result = ""
    var i = self.startIndex

    while i < self.endIndex {
      if self[i] == "\u{001B}" && self.distance(from: i, to: self.endIndex) > 1 {
        let nextIndex = self.index(after: i)
        if nextIndex < self.endIndex && self[nextIndex] == "[" {
          var j = self.index(after: nextIndex)
          while j < self.endIndex {
            let char = self[j]
            if char.isLetter {
              i = self.index(after: j)
              break
            }
            j = self.index(after: j)
          }
          continue
        }
      }
      result.append(self[i])
      i = self.index(after: i)
    }
    return result
  }

  func truncated(toDisplayWidth maxWidth: Int) -> String {
    let cleanText = self.removingANSIEscapes
    var result = ""
    var currentWidth = 0
    var originalIndex = self.startIndex
    var cleanIndex = cleanText.startIndex

    while originalIndex < self.endIndex && cleanIndex < cleanText.endIndex {
      let originalChar = self[originalIndex]
      let cleanChar = cleanText[cleanIndex]

      if originalChar == "\u{001B}" {
        let ansiStart = originalIndex
        var ansiEnd = originalIndex

        while ansiEnd < self.endIndex {
          let char = self[ansiEnd]
          ansiEnd = self.index(after: ansiEnd)
          if char.isLetter {
            break
          }
        }

        result += self[ansiStart..<ansiEnd]
        originalIndex = ansiEnd
        continue
      }

      let charWidth = cleanChar.isFullWidth ? 2 : 1
      if currentWidth + charWidth > maxWidth {
        break
      }

      result.append(originalChar)
      currentWidth += charWidth
      originalIndex = self.index(after: originalIndex)
      cleanIndex = cleanText.index(after: cleanIndex)
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

  func centered(inWidth width: Int) -> String {
    let currentWidth = self.displayWidth
    if currentWidth >= width {
      return self.truncated(toDisplayWidth: width)
    }

    let padding = width - currentWidth
    let leftPadding = padding / 2
    let rightPadding = padding - leftPadding

    return String(repeating: " ", count: leftPadding) + self
      + String(repeating: " ", count: rightPadding)
  }
}
class ScreenBuffer {
  public var currentBuffer: [[Character]]
  private var previousBuffer: [[Character]]
  private var coloredTextInfo: [Int: (text: String, startX: Int)] = [:]  // 🔧 存储彩色文本和位置
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
    coloredTextInfo.removeAll()  // 🔧 清空带颜色的文本信息
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
    let text2 = text.replacingOccurrences(of: "　", with: " ")
    let displayText = maxWidth.map { text2.truncated(toDisplayWidth: $0) } ?? text2

    if displayText.contains("\u{001B}") {
      drawColoredText(displayText, at: point)
    } else {
      drawPlainText(displayText, at: point)
    }
  }

  private func drawPlainText(_ text: String, at point: Point) {
    var currentX = point.x

    for char in text {
      guard currentX < size.width else { break }
      setChar(char, at: Point(x: currentX, y: point.y))
      currentX += char.isFullWidth ? 2 : 1
    }
  }

  private func drawColoredText(_ text: String, at point: Point) {
    guard point.y >= 0 && point.y < size.height else { return }

    coloredTextInfo[point.y] = (text: text, startX: point.x)

    let cleanText = text.removingANSIEscapes
    var x = point.x
    for char in cleanText {
      guard x < size.width else { break }
      currentBuffer[point.y][x] = char
      x += char.isFullWidth ? 2 : 1
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

      if let colorInfo = coloredTextInfo[y] {
        let line = buildLineWithColoredText(
          y: y, coloredText: colorInfo.text, startX: colorInfo.startX)
        print(line, terminator: "")
      } else {
        let line = String(currentBuffer[y].filter { $0 != "\u{0000}" })
        print(line, terminator: "")
      }
    }
  }

  private func buildLineWithColoredText(y: Int, coloredText: String, startX: Int) -> String {
    let bufferRow = currentBuffer[y]
    var result = ""

    for x in 0..<startX {
      result.append(bufferRow[x] == "\u{0000}" ? " " : bufferRow[x])
    }

    result += coloredText

    let cleanText = coloredText.removingANSIEscapes
    let coloredTextWidth = cleanText.reduce(0) { $0 + ($1.isFullWidth ? 2 : 1) }
    let afterColoredX = startX + coloredTextWidth

    for x in afterColoredX..<bufferRow.count {
      result.append(bufferRow[x] == "\u{0000}" ? " " : bufferRow[x])
    }

    return result
  }
}
