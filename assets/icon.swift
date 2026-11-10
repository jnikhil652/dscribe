import Cocoa
let out = CommandLine.arguments[1]
try? FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
func png(_ px: Int, _ name: String) {
    let img = NSImage(size: NSSize(width: px, height: px), flipped: false) { r in
        let g = NSGradient(colors: [NSColor(red: 0.36, green: 0.30, blue: 0.95, alpha: 1), NSColor(red: 0.10, green: 0.75, blue: 0.95, alpha: 1)])!
        let path = NSBezierPath(roundedRect: r.insetBy(dx: CGFloat(px) * 0.05, dy: CGFloat(px) * 0.05), xRadius: CGFloat(px) * 0.22, yRadius: CGFloat(px) * 0.22)
        g.draw(in: path, angle: -45)
        let cfg = NSImage.SymbolConfiguration(pointSize: CGFloat(px) * 0.5, weight: .semibold).applying(.init(paletteColors: [.white]))
        if let s = NSImage(systemSymbolName: "waveform", accessibilityDescription: nil)?.withSymbolConfiguration(cfg) {
            let sz = s.size; s.draw(in: NSRect(x: (r.width - sz.width) / 2, y: (r.height - sz.height) / 2, width: sz.width, height: sz.height))
        }
        return true
    }
    let rep = NSBitmapImageRep(data: img.tiffRepresentation!)!
    try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out + "/" + name))
}
for (px, n) in [(16,"icon_16x16"),(32,"icon_16x16@2x"),(32,"icon_32x32"),(64,"icon_32x32@2x"),(128,"icon_128x128"),(256,"icon_128x128@2x"),(256,"icon_256x256"),(512,"icon_256x256@2x"),(512,"icon_512x512"),(1024,"icon_512x512@2x")] { png(px, n + ".png") }
