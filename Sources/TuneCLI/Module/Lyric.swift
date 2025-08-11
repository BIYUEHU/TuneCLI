import Foundation

struct LyricLine {
  let startTime: Double
  let endTime: Double
  let content: String
}
typealias Lyrics = [LyricLine]
private func parseLyricTimeLine(line: String) -> (time: Double, content: String)? {
  guard
    let regex = try? NSRegularExpression(
      pattern: "^\\[(\\d{1,2}):(\\d{2})\\.(\\d{2,3})\\](.*)$"),
    let match = regex.firstMatch(
      in: line, options: [], range: NSRange(location: 0, length: line.utf16.count))
  else {
    return nil
  }

  let minutes = Double((line as NSString).substring(with: match.range(at: 1))) ?? 0
  let seconds = Double((line as NSString).substring(with: match.range(at: 2))) ?? 0
  let millisecondsStr = (line as NSString).substring(with: match.range(at: 3))
  let content = (line as NSString).substring(with: match.range(at: 4)).trimmingCharacters(
    in: .whitespacesAndNewlines)

  if content.isEmpty {
    return nil
  }

  let milliseconds = Double(millisecondsStr) ?? 0
  let millisecondsInSeconds: Double
  if millisecondsStr.count == 2 {
    millisecondsInSeconds = milliseconds / 100.0
  } else {
    millisecondsInSeconds = milliseconds / 1000.0
  }

  return (minutes * 60 + seconds + millisecondsInSeconds, content)
}
func parseLyrics(lrcContent: String) -> Lyrics {
  var lyrics: Lyrics = []

  let lines = lrcContent.components(separatedBy: .newlines)
  var timeContentPairs: [(time: Double, content: String)] = []

  for line in lines {
    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmedLine.isEmpty
      || (try? NSRegularExpression(pattern: "^\\[[a-zA-Z]+:"))?.firstMatch(
        in: trimmedLine, options: [], range: NSRange(location: 0, length: trimmedLine.utf16.count))
        != nil
    {
      continue
    }

    if let (time, content) = parseLyricTimeLine(line: trimmedLine) {
      timeContentPairs.append((time, content))
    }
  }

  timeContentPairs.sort { $0.time < $1.time }

  for i in 0..<timeContentPairs.count {
    let startTime = timeContentPairs[i].time
    let content = timeContentPairs[i].content

    let endTime: Double
    if i < timeContentPairs.count - 1 {
      var nextIndex = i + 1
      while nextIndex < timeContentPairs.count && timeContentPairs[nextIndex].time == startTime {
        nextIndex += 1
      }

      if nextIndex < timeContentPairs.count {
        endTime = timeContentPairs[nextIndex].time
      } else {
        endTime = startTime + 5.0
      }
    } else {
      endTime = startTime + 5.0
    }

    lyrics.append(LyricLine(startTime: startTime, endTime: endTime, content: content))
  }

  return lyrics
}
