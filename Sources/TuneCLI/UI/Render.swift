struct Point {
    let x: Int
    let y: Int
}
struct Size {
    let width: Int
    let height: Int
}
struct Rect {
    let origin: Point
    let size: Size

    var minX: Int { origin.x }
    var minY: Int { origin.y }
    var maxX: Int { origin.x + size.width }
    var maxY: Int { origin.y + size.height }
}
enum Color: String {
    case black = "30"
    case red = "31"
    case green = "32"
    case yellow = "33"
    case blue = "34"
    case magenta = "35"
    case cyan = "36"
    case white = "37"
    case reset = "0"
}
enum TextStyle: String {
    case normal = "0"
    case bold = "1"
    case dim = "2"
    case italic = "3"
    case underline = "4"
}
struct StyledText {
    let text: String
    let color: Color
    let style: TextStyle

    init(_ text: String, color: Color = .white, style: TextStyle = .normal) {
        self.text = text
        self.color = color
        self.style = style
    }

    func render() -> String {
        return "\u{001B}[\(style.rawValue)m\u{001B}[\(color.rawValue)m\(text)\u{001B}[0m"
    }
}
protocol UIComponent {
    var frame: Rect { get set }
    func render(in buffer: inout ScreenBuffer)
}
class Renderer {
    private var buffer: ScreenBuffer
    private var components: [UIComponent] = []

    init() {
        self.buffer = ScreenBuffer(size: Console.getTerminalSize())
        Console.hideCursor()
        Console.clear()
    }

    deinit {
        Console.showCursor()
    }

    func add(_ component: UIComponent) {
        components.append(component)
    }

    func removeAll() {
        components.removeAll()
    }

    func render() {
        buffer.clear()

        for component in components {
            component.render(in: &buffer)
        }

        buffer.flush()
    }

    func forceFullRender() {
        Console.clear()
        render()
    }

    func updateTerminalSize() {
        let newSize = Console.getTerminalSize()
        if newSize.width != buffer.size.width || newSize.height != buffer.size.height {
            buffer = ScreenBuffer(size: newSize)
            Console.clear()
        }
    }
}
