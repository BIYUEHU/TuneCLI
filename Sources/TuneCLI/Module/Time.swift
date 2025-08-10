import WinSDK

func getCurrentTime() -> Double {
  var fileTime: FILETIME = FILETIME()
  GetSystemTimePreciseAsFileTime(&fileTime)
  let rawTime = UInt64(fileTime.dwLowDateTime) | (UInt64(fileTime.dwHighDateTime) << 32)
  return Double(rawTime) / 10_000_000.0 - 11_644_473_600.0
}
func formatSeconds(seconds: Double) -> String {
  let x = Int(seconds)
  let hours = x / 3600
  let minutes = (x % 3600) / 60
  let seconds = x % 60

  if hours == 0 {
    return "\(minutes):\(seconds)"
  } else {
    return "\(hours):\(minutes):\(seconds)"
  }
}
