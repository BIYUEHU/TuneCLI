import Foundation

struct ANSIColors {
  static let reset = "\u{001B}[0m"

  static let black = "\u{001B}[30m"
  static let red = "\u{001B}[31m"
  static let green = "\u{001B}[32m"
  static let yellow = "\u{001B}[33m"
  static let blue = "\u{001B}[34m"
  static let magenta = "\u{001B}[35m"
  static let cyan = "\u{001B}[36m"
  static let white = "\u{001B}[37m"

  static let lightBlack = "\u{001B}[90m"  // 灰色
  static let lightRed = "\u{001B}[91m"
  static let lightGreen = "\u{001B}[92m"
  static let lightYellow = "\u{001B}[93m"
  static let lightBlue = "\u{001B}[94m"  // 你要的浅蓝色！
  static let lightMagenta = "\u{001B}[95m"
  static let lightCyan = "\u{001B}[96m"
  static let lightWhite = "\u{001B}[97m"

  static let bgBlack = "\u{001B}[40m"
  static let bgRed = "\u{001B}[41m"
  static let bgGreen = "\u{001B}[42m"
  static let bgYellow = "\u{001B}[43m"
  static let bgBlue = "\u{001B}[44m"
  static let bgMagenta = "\u{001B}[45m"
  static let bgCyan = "\u{001B}[46m"
  static let bgWhite = "\u{001B}[47m"

  static let bgLightBlack = "\u{001B}[100m"
  static let bgLightRed = "\u{001B}[101m"
  static let bgLightGreen = "\u{001B}[102m"
  static let bgLightYellow = "\u{001B}[103m"
  static let bgLightBlue = "\u{001B}[104m"
  static let bgLightMagenta = "\u{001B}[105m"
  static let bgLightCyan = "\u{001B}[106m"
  static let bgLightWhite = "\u{001B}[107m"

  static let bold = "\u{001B}[1m"
  static let dim = "\u{001B}[2m"
  static let italic = "\u{001B}[3m"
  static let underline = "\u{001B}[4m"
  static let blink = "\u{001B}[5m"
  static let reverse = "\u{001B}[7m"
  static let strikethrough = "\u{001B}[9m"
}
extension String {
  var black: String { ANSIColors.black + self + ANSIColors.reset }
  var red: String { ANSIColors.red + self + ANSIColors.reset }
  var green: String { ANSIColors.green + self + ANSIColors.reset }
  var yellow: String { ANSIColors.yellow + self + ANSIColors.reset }
  var blue: String { ANSIColors.blue + self + ANSIColors.reset }
  var magenta: String { ANSIColors.magenta + self + ANSIColors.reset }
  var cyan: String { ANSIColors.cyan + self + ANSIColors.reset }
  var white: String { ANSIColors.white + self + ANSIColors.reset }

  var lightBlue: String { ANSIColors.lightBlue + self + ANSIColors.reset }
  var lightRed: String { ANSIColors.lightRed + self + ANSIColors.reset }
  var lightGreen: String { ANSIColors.lightGreen + self + ANSIColors.reset }
  var lightYellow: String { ANSIColors.lightYellow + self + ANSIColors.reset }
  var lightMagenta: String { ANSIColors.lightMagenta + self + ANSIColors.reset }
  var lightCyan: String { ANSIColors.lightCyan + self + ANSIColors.reset }
  var lightWhite: String { ANSIColors.lightWhite + self + ANSIColors.reset }

  var onBlack: String { ANSIColors.bgBlack + self + ANSIColors.reset }
  var onRed: String { ANSIColors.bgRed + self + ANSIColors.reset }
  var onGreen: String { ANSIColors.bgGreen + self + ANSIColors.reset }
  var onYellow: String { ANSIColors.bgYellow + self + ANSIColors.reset }
  var onBlue: String { ANSIColors.bgBlue + self + ANSIColors.reset }
  var onMagenta: String { ANSIColors.bgMagenta + self + ANSIColors.reset }
  var onCyan: String { ANSIColors.bgCyan + self + ANSIColors.reset }
  var onWhite: String { ANSIColors.bgWhite + self + ANSIColors.reset }

  var onLightBlue: String { ANSIColors.bgLightBlue + self + ANSIColors.reset }
  var onLightRed: String { ANSIColors.bgLightRed + self + ANSIColors.reset }
  var onLightGreen: String { ANSIColors.bgLightGreen + self + ANSIColors.reset }
  var onLightYellow: String { ANSIColors.bgLightYellow + self + ANSIColors.reset }
  var onLightMagenta: String { ANSIColors.bgLightMagenta + self + ANSIColors.reset }
  var onLightCyan: String { ANSIColors.bgLightCyan + self + ANSIColors.reset }
  var onLightWhite: String { ANSIColors.bgLightWhite + self + ANSIColors.reset }

  var bold: String { ANSIColors.bold + self + ANSIColors.reset }
  var dim: String { ANSIColors.dim + self + ANSIColors.reset }
  var italic: String { ANSIColors.italic + self + ANSIColors.reset }
  var underline: String { ANSIColors.underline + self + ANSIColors.reset }
  var blink: String { ANSIColors.blink + self + ANSIColors.reset }
  var reverse: String { ANSIColors.reverse + self + ANSIColors.reset }
  var strikethrough: String { ANSIColors.strikethrough + self + ANSIColors.reset }
}
