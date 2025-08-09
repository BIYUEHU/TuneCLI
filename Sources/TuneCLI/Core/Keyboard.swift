import WinSDK

class KeyboardListener {
  private var isListening = false
  private var keyHandlers: [(WindowsKey, () -> Void)] = []
  private var anyKeyHandlers: [(String) -> Void] = []

  private func readWindowsKey() -> String? {
    var input: INPUT_RECORD = INPUT_RECORD()
    var count = DWORD(0)
    if !ReadConsoleInputW(GetStdHandle(STD_INPUT_HANDLE), &input, 1, &count) {
      return nil
    }
    if input.EventType == KEY_EVENT && input.Event.KeyEvent.bKeyDown.boolValue {
      return String(input.Event.KeyEvent.uChar.UnicodeChar)
    }
    return nil
  }

  func on(key: WindowsKey, callback: @escaping () -> Void) {
    keyHandlers.append((key, callback))
  }

  func onAny(callback: @escaping (String) -> Void) {
    anyKeyHandlers.append(callback)
  }

  func start() {
    isListening = true

    // Task {
    while isListening {
      if let key = readWindowsKey() {
        for c in anyKeyHandlers {
          c(key)
        }
        for (k, c) in keyHandlers {
          if key == k.rawValue {
            c()
          }
        }
      }
      // try await Task.sleep(nanoseconds: 16_666_667)  // ~60fps
    }
    // }
  }

  func stop() {
    isListening = false
    // restoreTerminal()
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
