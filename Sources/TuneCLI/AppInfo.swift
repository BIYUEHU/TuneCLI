struct AppInfo {
    static let name = "TuneCLI"
    static let version = "1.0.0"
    static let author = "Arimura Sena"
    static let description = "Modern Terminal Music Player"
    static let homepage = "https://github.com/biyuehu/TuneCLI"
    static let license = "BAN-ZHINESE-USING"
    static let buildDate = "2025-08-11"

    static func printBanner() {
        print(
            "\n            🎵 \(name) v\(version)\n                \(description)\n\n                Author: \(author)\n                Homepage: \(homepage)\n                License: \(license)\n\n                ─────────────────────\n"
        )
    }

    static func printVersion() {
        print("\(name) version \(version)")
    }
}
