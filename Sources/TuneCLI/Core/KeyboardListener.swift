import WinSDK

class KeyboardListener {
  private var isListening = false
  private var anyKeyHandlers: [(String) -> Void] = []

  private func readWindowsKey() -> String? {
    let hStdin = GetStdHandle(STD_INPUT_HANDLE)
    if hStdin == INVALID_HANDLE_VALUE {
      return nil
    }

    var input = INPUT_RECORD()
    var count: DWORD = 0

    if !ReadConsoleInputW(hStdin, &input, 1, &count) || count == 0 {
      return nil
    }

    if input.EventType == KEY_EVENT && input.Event.KeyEvent.bKeyDown.boolValue
      && input.Event.KeyEvent.uChar.UnicodeChar != 0
    {
      return String(input.Event.KeyEvent.uChar.UnicodeChar)
    }

    return nil
  }

  private func hasInputAvailable() -> Bool {
    let hStdin = GetStdHandle(STD_INPUT_HANDLE)
    if hStdin == INVALID_HANDLE_VALUE {
      return false
    }

    var numberOfEvents: DWORD = 0
    if !GetNumberOfConsoleInputEvents(hStdin, &numberOfEvents) {
      return false
    }

    return numberOfEvents > 0
  }

  func readNonBlocking() -> String? {
    guard hasInputAvailable() else { return nil }
    return readWindowsKey()
  }

  func onAny(callback: @escaping (String) -> Void) {
    anyKeyHandlers.append(callback)
  }

  func read() {
    if let key = readWindowsKey() {
      for c in anyKeyHandlers {
        c(key)
      }
    }
  }
}
enum WindowsKey: String {
  case A = "65"
  case a = "97"
  case B = "66"
  case b = "98"
  case C = "67"
  case c = "99"
  case D = "68"
  case d = "100"
  case E = "69"
  case e = "101"
  case F = "70"
  case f = "102"
  case G = "71"
  case g = "103"
  case H = "72"
  case h = "104"
  case I = "73"
  case i = "105"
  case J = "74"
  case j = "106"
  case K = "75"
  case k = "107"
  case L = "76"
  case l = "108"
  case M = "77"
  case m = "109"
  case N = "78"
  case n = "110"
  case O = "79"
  case o = "111"
  case P = "80"
  case p = "112"
  case Q = "81"
  case q = "113"
  case R = "82"
  case r = "114"
  case S = "83"
  case s = "115"
  case T = "84"
  case t = "116"
  case U = "85"
  case u = "117"
  case V = "86"
  case v = "118"
  case W = "87"
  case w = "119"
  case X = "88"
  case x = "120"
  case Y = "89"
  case y = "121"
  case Z = "90"
  case z = "122"
  case Space = "32"
  case Enter = "13"
  case Backspace = "8"
}
