import Cocoa
// DScribe icon, variant "Wave": black rounded square (full tile, avoids the macOS grey plate), one continuous white voice line.
let out = CommandLine.arguments[1]
try? FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
func png(_ px: Int, _ name: String) {
    let img = NSImage(size: NSSize(width: px, height: px), flipped: false) { r in
        let s = CGFloat(px) / 64.0
        let inset = CGFloat(px) * 0.06
        let circle = NSBezierPath(roundedRect: r.insetBy(dx: inset, dy: inset), xRadius: CGFloat(px) * 0.225, yRadius: CGFloat(px) * 0.225)
        NSColor.black.setFill(); circle.fill()
        NSColor(white: 1, alpha: 0.16).setStroke(); circle.lineWidth = max(1, CGFloat(px) * 0.012); circle.stroke()
        // wave path from the design (64-unit grid), y flipped for AppKit
        func P(_ x: CGFloat, _ y: CGFloat) -> NSPoint { NSPoint(x: x * s, y: (64 - y) * s) }
        let w = NSBezierPath()
        w.move(to: P(11, 32))
        w.curve(to: P(21, 20), controlPoint1: P(15, 32), controlPoint2: P(16, 20))
        w.curve(to: P(31, 44), controlPoint1: P(26, 20), controlPoint2: P(26, 44))
        w.curve(to: P(41, 17), controlPoint1: P(36, 44), controlPoint2: P(36, 17))
        w.curve(to: P(53, 32), controlPoint1: P(46, 17), controlPoint2: P(45, 32))
        w.lineWidth = 3.6 * s; w.lineCapStyle = .round; w.lineJoinStyle = .round
        NSColor.white.setStroke(); w.stroke()
        return true
    }
    let rep = NSBitmapImageRep(data: img.tiffRepresentation!)!
    try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out + "/" + name))
}
for (px, n) in [(16,"icon_16x16"),(32,"icon_16x16@2x"),(32,"icon_32x32"),(64,"icon_32x32@2x"),(128,"icon_128x128"),(256,"icon_128x128@2x"),(256,"icon_256x256"),(512,"icon_256x256@2x"),(512,"icon_512x512"),(1024,"icon_512x512@2x")] { png(px, n + ".png") }
