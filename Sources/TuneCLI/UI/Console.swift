import WinSDK

class Console {
  static func getTerminalSize() -> Size {
    var csbi = CONSOLE_SCREEN_BUFFER_INFO()
    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi)
    return Size(
      width: max(Int(csbi.srWindow.Right - csbi.srWindow.Left + 1), 60),
      height: Int(csbi.srWindow.Bottom - csbi.srWindow.Top + 1))
  }

  static func clear() {
    print("\u{001B}[2J", terminator: "")
  }

  static func moveCursor(to point: Point) {
    print("\u{001B}[\(point.y + 1);\(point.x + 1)H", terminator: "")
  }

  static func hideCursor() {
    print("\u{001B}[?25l", terminator: "")
  }

  static func showCursor() {
    print("\u{001B}[?25h", terminator: "")
  }
}
