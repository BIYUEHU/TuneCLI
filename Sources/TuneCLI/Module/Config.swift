let CONFIG_FILE_NAME = "tune.ini"
typealias Config = [String: String]
func parseConfig(config: String) -> Config {
  var result: [String: String] = [:]
  let lines = config.components(separatedBy: .newlines)
  for line in lines {
    let components = line.components(separatedBy: "=")
    if components.count == 2 {
      result[components[0].trimmingCharacters(in: .whitespaces)] = components[1].trimmingCharacters(
        in: .whitespaces)
    }
  }
  return result
}
func stringifyConfig(config: Config) -> String {
  config.map { (key: String, value: String) in
    "\(key)=\(value)"
  }.joined(separator: "\n")
}
