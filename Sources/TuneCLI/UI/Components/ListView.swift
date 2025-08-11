class ListView: UIComponent {
  var frame: Rect
  var items: [String]
  var selectedIndex: Int
  var scrollOffset: Int

  init(frame: Rect, items: [String] = []) {
    self.frame = frame
    self.items = items
    self.selectedIndex = 0
    self.scrollOffset = 0
  }

  func render(in buffer: inout ScreenBuffer) {
    let maxVisible = frame.size.height
    let endIndex = min(scrollOffset + maxVisible, items.count)

    for i in scrollOffset..<endIndex {
      let y = frame.minY + (i - scrollOffset)
      let isSelected = i == selectedIndex
      let prefix = isSelected ? "► " : "  "
      var text = String((prefix + items[i]).prefix(frame.size.width))
      if isSelected {
        text = text.lightCyan
      }
      // let maxWidth = frame.size.width - prefix.count
      buffer.drawText(text, at: Point(x: frame.minX, y: y))
    }
  }

  func selectNext() {
    if selectedIndex < items.count - 1 {
      selectedIndex += 1
      if selectedIndex >= scrollOffset + frame.size.height {
        scrollOffset += 1
      }
    }
  }

  func selectPrevious() {
    if selectedIndex > 0 {
      selectedIndex -= 1
      if selectedIndex < scrollOffset {
        scrollOffset -= 1
      }
    }
  }
}
