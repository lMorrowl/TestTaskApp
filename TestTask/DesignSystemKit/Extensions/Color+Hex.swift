import SwiftUI

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            _ = scanner.scanString("#")
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r, g, b, a: Double
        if hex.count == 9 {
            r = Double((rgb & 0xff000000) >> 24) / 255
            g = Double((rgb & 0x00ff0000) >> 16) / 255
            b = Double((rgb & 0x0000ff00) >> 8) / 255
            a = Double(rgb & 0x000000ff) / 255
        } else {
            r = Double((rgb & 0xff0000) >> 16) / 255
            g = Double((rgb & 0x00ff00) >> 8) / 255
            b = Double(rgb & 0x0000ff) / 255
            a = 1
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
