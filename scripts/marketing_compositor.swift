import AppKit
import Foundation

struct MarketingAssetBuilder {
    let rawDirectory: URL
    let outputDirectory: URL
    let colors = Palette()

    func run() throws {
        try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

        let menu = try loadImage(named: "menu.png")
        let settings = try loadImage(named: "settings.png")
        let profiles = try loadImage(named: "settings-profiles.png")
        let diagnostics = try loadImage(named: "settings-diagnostics.png")
        let general = try loadImage(named: "settings-general.png")

        try hero(menu: menu, settings: settings)
            .savePNG(to: outputDirectory.appendingPathComponent("readme-hero.png"))
        try featureTrust(menu: menu, diagnostics: diagnostics)
            .savePNG(to: outputDirectory.appendingPathComponent("readme-feature-trust.png"))
        try featureProfiles(profiles: profiles, general: general)
            .savePNG(to: outputDirectory.appendingPathComponent("readme-feature-profiles.png"))
        try socialCard(menu: menu, settings: settings)
            .savePNG(to: outputDirectory.appendingPathComponent("social-card.png"))

        try slideOne(menu: menu, settings: settings)
            .savePNG(to: outputDirectory.appendingPathComponent("slide-01.png"))
        try slideTwo(menu: menu, diagnostics: diagnostics)
            .savePNG(to: outputDirectory.appendingPathComponent("slide-02.png"))
        try slideThree(profiles: profiles, general: general)
            .savePNG(to: outputDirectory.appendingPathComponent("slide-03.png"))
    }

    private func loadImage(named name: String) throws -> NSImage {
        let url = rawDirectory.appendingPathComponent(name)
        guard let image = NSImage(contentsOf: url) else {
            throw NSError(domain: "MarketingAssetBuilder", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing snapshot image: \(url.path)"
            ])
        }
        return image
    }

    private func hero(menu: NSImage, settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 1000)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1280, y: 120, radius: 220, color: colors.mint.withAlphaComponent(0.14))
            drawOrb(x: 1420, y: 780, radius: 180, color: colors.amber.withAlphaComponent(0.16))

            drawKicker("Open-source menu bar recovery for MacBook + dock desks", at: NSPoint(x: 96, y: 862))
            drawHeadline("Restore the monitor layout macOS keeps scrambling.", at: NSPoint(x: 96, y: 670), width: 680)
            drawBody(
                "Save one known-good layout, then bring it back after sleep, wake, or reconnect only when the current display set is a confident match.",
                at: NSPoint(x: 96, y: 580),
                width: 560
            )
            drawPills([
                "MacBook + dock + 2+ displays",
                "Restore only when confident",
                "Manual fallback stays visible"
            ], origin: NSPoint(x: 96, y: 480))

            drawScreenshotCard(menu, frame: NSRect(x: 860, y: 430, width: 340, height: 398), angle: -3)
            drawScreenshotCard(settings, frame: NSRect(x: 1018, y: 180, width: 500, height: 568), angle: 4)
        }
    }

    private func featureTrust(menu: NSImage, diagnostics: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawKicker("Trust before restore", at: NSPoint(x: 104, y: 750))
            drawHeadline("See why LayoutRecall acted — or why it stayed manual.", at: NSPoint(x: 104, y: 598), width: 600)
            drawBody(
                "Profile match context, dependency state, and recent diagnostics stay close to the menu bar action so recovery never feels like a blind automation gamble.",
                at: NSPoint(x: 104, y: 470),
                width: 540
            )
            drawChecklist([
                "Matched profile and confidence",
                "Manual fallback when confidence is low",
                "Dependency state before recovery",
                "Diagnostics evidence after every attempt"
            ], origin: NSPoint(x: 104, y: 306))

            drawScreenshotCard(menu, frame: NSRect(x: 860, y: 420, width: 330, height: 380), angle: -2)
            drawScreenshotCard(diagnostics, frame: NSRect(x: 1040, y: 110, width: 470, height: 610), angle: 4)
        }
    }

    private func featureProfiles(profiles: NSImage, general: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawKicker("Known desks, fast recovery", at: NSPoint(x: 104, y: 750))
            drawHeadline("Keep saved layouts and recovery controls within reach.", at: NSPoint(x: 104, y: 598), width: 600)
            drawBody(
                "Profiles, startup behavior, and manual restore tools stay in one workflow so repeat desks are easy to tune without hunting across the app.",
                at: NSPoint(x: 104, y: 470),
                width: 520
            )
            drawChecklist([
                "Multiple saved desk profiles",
                "Startup and launch-at-login controls",
                "Fix Now and Apply Layout fallbacks",
                "Predictable setup for repeat reconnects"
            ], origin: NSPoint(x: 104, y: 306))

            drawScreenshotCard(profiles, frame: NSRect(x: 820, y: 300, width: 520, height: 500), angle: -3)
            drawScreenshotCard(general, frame: NSRect(x: 1070, y: 90, width: 420, height: 450), angle: 5)
        }
    }

    private func socialCard(menu: NSImage, settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1200, height: 630)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1060, y: 120, radius: 150, color: colors.mint.withAlphaComponent(0.18))
            drawHeadline(
                "Restore the monitor layout macOS keeps scrambling.",
                at: NSPoint(x: 72, y: 336),
                width: 560,
                fontSize: 32
            )
            drawBody(
                "Open-source menu bar recovery for MacBook + dock + multi-display desks.",
                at: NSPoint(x: 72, y: 212),
                width: 500,
                fontSize: 20
            )

            drawScreenshotCard(menu, frame: NSRect(x: 700, y: 250, width: 220, height: 260), angle: -5)
            drawScreenshotCard(settings, frame: NSRect(x: 850, y: 60, width: 300, height: 380), angle: 6)
        }
    }

    private func slideOne(menu: NSImage, settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawKicker("Desk drift", at: NSPoint(x: 96, y: 748))
            drawHeadline("Your desk comes back scrambled.", at: NSPoint(x: 96, y: 600), width: 560, fontSize: 46, height: 130)
            drawBody("After sleep, wake, or reconnect, identical displays can return in the wrong order or with the wrong main-display state.", at: NSPoint(x: 96, y: 470), width: 540)
            drawScreenshotCard(settings, frame: NSRect(x: 860, y: 180, width: 560, height: 620), angle: 4)
            drawScreenshotCard(menu, frame: NSRect(x: 720, y: 360, width: 290, height: 350), angle: -6)
        }
    }

    private func slideTwo(menu: NSImage, diagnostics: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawKicker("Recognition", at: NSPoint(x: 96, y: 748))
            drawHeadline("LayoutRecall recognizes the saved desk safely.", at: NSPoint(x: 96, y: 600), width: 580, fontSize: 46, height: 130)
            drawBody("The app shows the profile match, confidence, and diagnostics context before recovery so monitor moves never feel opaque or reckless.", at: NSPoint(x: 96, y: 470), width: 560)
            drawScreenshotCard(menu, frame: NSRect(x: 840, y: 360, width: 320, height: 380), angle: -4)
            drawScreenshotCard(diagnostics, frame: NSRect(x: 1040, y: 120, width: 470, height: 610), angle: 4)
        }
    }

    private func slideThree(profiles: NSImage, general: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawKicker("Control", at: NSPoint(x: 96, y: 748))
            drawHeadline("Recover fast or stay manual on purpose.", at: NSPoint(x: 96, y: 600), width: 580, fontSize: 46, height: 130)
            drawBody("Profiles, startup behavior, and one-click fallback actions stay visible in one place so repeat desks remain predictable even when automation stops short.", at: NSPoint(x: 96, y: 470), width: 560)
            drawScreenshotCard(profiles, frame: NSRect(x: 780, y: 250, width: 520, height: 520), angle: -4)
            drawScreenshotCard(general, frame: NSRect(x: 1080, y: 110, width: 380, height: 420), angle: 5)
        }
    }

    private func renderCanvas(size: NSSize, draw: (NSRect) -> Void) throws -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        defer { image.unlockFocus() }

        let rect = NSRect(origin: .zero, size: size)
        draw(rect)
        return image
    }

    private func drawBackground(in rect: NSRect) {
        let gradient = NSGradient(colors: [
            colors.backgroundTop,
            colors.backgroundBottom,
        ])!
        gradient.draw(in: rect, angle: -90)

        let stripeColor = colors.gridLine.withAlphaComponent(0.05)
        for index in stride(from: 0, to: Int(rect.width + rect.height), by: 84) {
            let path = NSBezierPath()
            path.move(to: NSPoint(x: CGFloat(index) - 240, y: 0))
            path.line(to: NSPoint(x: CGFloat(index), y: rect.height))
            stripeColor.setStroke()
            path.lineWidth = 1
            path.stroke()
        }

        let horizonColor = colors.gridLine.withAlphaComponent(0.035)
        for index in stride(from: 140, to: Int(rect.height), by: 120) {
            let path = NSBezierPath()
            path.move(to: NSPoint(x: 72, y: CGFloat(index)))
            path.line(to: NSPoint(x: rect.width - 72, y: CGFloat(index)))
            horizonColor.setStroke()
            path.lineWidth = 1
            path.stroke()
        }
    }

    private func drawOrb(x: CGFloat, y: CGFloat, radius: CGFloat, color: NSColor) {
        let rect = NSRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
        color.setFill()
        NSBezierPath(ovalIn: rect).fill()
    }

    private func drawKicker(_ text: String, at point: NSPoint) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: colors.mutedText,
        ]
        NSString(string: text).draw(at: point, withAttributes: attributes)
    }

    private func drawSectionLabel(_ text: String, at point: NSPoint) {
        let pillRect = NSRect(x: point.x, y: point.y, width: 220, height: 34)
        colors.accentPanel.setFill()
        NSBezierPath(roundedRect: pillRect, xRadius: 17, yRadius: 17).fill()
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14, weight: .bold),
            .foregroundColor: colors.accentText,
            .paragraphStyle: style,
        ]
        NSString(string: text.uppercased()).draw(in: pillRect.insetBy(dx: 8, dy: 8), withAttributes: attributes)
    }

    private func drawHeadline(_ text: String, at point: NSPoint, width: CGFloat, fontSize: CGFloat = 52, height: CGFloat = 220) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 3
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .bold),
            .foregroundColor: colors.primaryText,
            .paragraphStyle: paragraph,
        ]
        NSString(string: text).draw(in: NSRect(x: point.x, y: point.y, width: width, height: height), withAttributes: attributes)
    }

    private func drawBody(_ text: String, at point: NSPoint, width: CGFloat, fontSize: CGFloat = 24, height: CGFloat = 180) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 6
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: colors.secondaryText,
            .paragraphStyle: paragraph,
        ]
        NSString(string: text).draw(in: NSRect(x: point.x, y: point.y, width: width, height: height), withAttributes: attributes)
    }

    private func drawPills(_ items: [String], origin: NSPoint) {
        var x = origin.x
        for item in items {
            let text = NSString(string: item)
            let size = text.size(withAttributes: [.font: NSFont.systemFont(ofSize: 15, weight: .medium)])
            let pillRect = NSRect(x: x, y: origin.y, width: size.width + 34, height: 36)
            colors.cardFill.setFill()
            NSBezierPath(roundedRect: pillRect, xRadius: 18, yRadius: 18).fill()
            colors.cardStroke.setStroke()
            let outline = NSBezierPath(roundedRect: pillRect, xRadius: 18, yRadius: 18)
            outline.lineWidth = 1
            outline.stroke()
            text.draw(
                at: NSPoint(x: x + 17, y: origin.y + 10),
                withAttributes: [
                    .font: NSFont.systemFont(ofSize: 15, weight: .medium),
                    .foregroundColor: colors.primaryText,
                ]
            )
            x += pillRect.width + 12
        }
    }

    private func drawChecklist(_ items: [String], origin: NSPoint) {
        for (index, item) in items.enumerated() {
            let y = origin.y - CGFloat(index) * 54
            let bulletRect = NSRect(x: origin.x, y: y + 8, width: 22, height: 22)
            colors.mint.setFill()
            NSBezierPath(ovalIn: bulletRect).fill()
            NSString(string: item).draw(
                at: NSPoint(x: origin.x + 38, y: y),
                withAttributes: [
                    .font: NSFont.systemFont(ofSize: 22, weight: .medium),
                    .foregroundColor: colors.primaryText,
                ]
            )
        }
    }

    private func drawStep(_ step: String, title: String, body: String, at point: NSPoint, width: CGFloat) {
        let titleFontSize: CGFloat = 48
        let titleLineSpacing: CGFloat = 3
        let titleHeight = measureTextHeight(title, width: width, fontSize: titleFontSize, lineSpacing: titleLineSpacing)
        let bodyFontSize: CGFloat = 24
        let bodyHeight = measureTextHeight(body, width: width, fontSize: bodyFontSize, lineSpacing: 6, weight: .regular)
        let stepRect = NSRect(x: point.x, y: point.y + titleHeight + 20, width: 76, height: 76)
        colors.accentPanel.setFill()
        NSBezierPath(roundedRect: stepRect, xRadius: 24, yRadius: 24).fill()
        NSString(string: step).draw(
            in: stepRect.insetBy(dx: 0, dy: 16),
            withAttributes: [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 28, weight: .bold),
                .foregroundColor: colors.accentText,
                .paragraphStyle: centeredParagraph(),
            ]
        )
        drawHeadline(title, at: NSPoint(x: point.x, y: point.y), width: width, fontSize: titleFontSize, height: titleHeight)
        drawBody(body, at: NSPoint(x: point.x, y: point.y - bodyHeight - 24), width: width, fontSize: bodyFontSize, height: bodyHeight)
    }

    private func drawScreenshotCard(_ image: NSImage, frame: NSRect, angle: CGFloat) {
        NSGraphicsContext.current?.saveGraphicsState()
        if let context = NSGraphicsContext.current?.cgContext {
            context.translateBy(x: frame.midX, y: frame.midY)
            context.rotate(by: angle * .pi / 180)
            context.translateBy(x: -frame.midX, y: -frame.midY)
        }

        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.22)
        shadow.shadowBlurRadius = 34
        shadow.shadowOffset = NSSize(width: 0, height: -18)
        shadow.set()

        let glowRect = frame.insetBy(dx: -8, dy: -8)
        colors.cardGlow.withAlphaComponent(0.24).setFill()
        NSBezierPath(roundedRect: glowRect, xRadius: 34, yRadius: 34).fill()

        colors.cardFill.setFill()
        let cardPath = NSBezierPath(roundedRect: frame, xRadius: 30, yRadius: 30)
        cardPath.fill()

        colors.cardStroke.setStroke()
        cardPath.lineWidth = 1
        cardPath.stroke()

        let chromeRect = NSRect(x: frame.minX, y: frame.maxY - 52, width: frame.width, height: 52)
        colors.chromeFill.setFill()
        NSBezierPath(
            roundedRect: chromeRect,
            xRadius: 30,
            yRadius: 30
        ).fill()

        let divider = NSBezierPath()
        divider.move(to: NSPoint(x: frame.minX + 18, y: chromeRect.minY))
        divider.line(to: NSPoint(x: frame.maxX - 18, y: chromeRect.minY))
        colors.cardStroke.withAlphaComponent(0.9).setStroke()
        divider.lineWidth = 1
        divider.stroke()

        drawWindowDots(origin: NSPoint(x: frame.minX + 22, y: frame.maxY - 31))

        let imageRect = NSRect(
            x: frame.minX + 18,
            y: frame.minY + 18,
            width: frame.width - 36,
            height: frame.height - 70
        )
        let clipPath = NSBezierPath(roundedRect: imageRect, xRadius: 20, yRadius: 20)
        clipPath.addClip()
        image.draw(in: imageRect)
        NSGraphicsContext.current?.restoreGraphicsState()
    }

    private func drawWindowDots(origin: NSPoint) {
        let dotColors: [NSColor] = [colors.dotRed, colors.dotAmber, colors.dotGreen]
        for (index, color) in dotColors.enumerated() {
            let rect = NSRect(x: origin.x + CGFloat(index) * 16, y: origin.y, width: 10, height: 10)
            color.setFill()
            NSBezierPath(ovalIn: rect).fill()
        }
    }

    private func centeredParagraph() -> NSParagraphStyle {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return paragraph
    }

    private func measureTextHeight(_ text: String, width: CGFloat, fontSize: CGFloat, lineSpacing: CGFloat, weight: NSFont.Weight = .bold) -> CGFloat {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing
        let attributed = NSAttributedString(
            string: text,
            attributes: [
                .font: NSFont.systemFont(ofSize: fontSize, weight: weight),
                .paragraphStyle: paragraph,
            ]
        )
        let rect = attributed.boundingRect(
            with: NSSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading]
        )
        return ceil(rect.height)
    }
}

struct Palette {
    let backgroundTop = NSColor(calibratedRed: 0.05, green: 0.08, blue: 0.12, alpha: 1.0)
    let backgroundBottom = NSColor(calibratedRed: 0.10, green: 0.15, blue: 0.23, alpha: 1.0)
    let cardFill = NSColor(calibratedRed: 0.09, green: 0.13, blue: 0.20, alpha: 0.92)
    let cardStroke = NSColor(calibratedRed: 0.78, green: 0.84, blue: 0.93, alpha: 0.16)
    let cardGlow = NSColor(calibratedRed: 0.37, green: 0.86, blue: 0.80, alpha: 1.0)
    let chromeFill = NSColor(calibratedRed: 0.13, green: 0.18, blue: 0.27, alpha: 0.96)
    let accentPanel = NSColor(calibratedRed: 0.72, green: 0.95, blue: 0.90, alpha: 0.14)
    let accentText = NSColor(calibratedRed: 0.77, green: 0.98, blue: 0.91, alpha: 1.0)
    let primaryText = NSColor(calibratedRed: 0.96, green: 0.98, blue: 0.99, alpha: 1.0)
    let secondaryText = NSColor(calibratedRed: 0.80, green: 0.85, blue: 0.91, alpha: 1.0)
    let mutedText = NSColor(calibratedRed: 0.61, green: 0.72, blue: 0.82, alpha: 1.0)
    let gridLine = NSColor(calibratedRed: 0.73, green: 0.82, blue: 0.92, alpha: 1.0)
    let mint = NSColor(calibratedRed: 0.46, green: 0.93, blue: 0.81, alpha: 1.0)
    let amber = NSColor(calibratedRed: 1.00, green: 0.78, blue: 0.39, alpha: 1.0)
    let dotRed = NSColor(calibratedRed: 0.99, green: 0.38, blue: 0.33, alpha: 1.0)
    let dotAmber = NSColor(calibratedRed: 1.00, green: 0.74, blue: 0.28, alpha: 1.0)
    let dotGreen = NSColor(calibratedRed: 0.31, green: 0.84, blue: 0.44, alpha: 1.0)
}

extension NSImage {
    func savePNG(to url: URL) throws {
        guard let tiffData = tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let png = bitmap.representation(using: .png, properties: [:]) else {
            throw NSError(domain: "MarketingAssetBuilder", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Failed to encode PNG for \(url.lastPathComponent)"
            ])
        }
        try png.write(to: url, options: .atomic)
    }
}

let arguments = CommandLine.arguments
guard arguments.count == 3 else {
    fputs("usage: swift marketing_compositor.swift <raw-snapshot-dir> <output-dir>\n", stderr)
    exit(64)
}

let builder = MarketingAssetBuilder(
    rawDirectory: URL(fileURLWithPath: arguments[1], isDirectory: true),
    outputDirectory: URL(fileURLWithPath: arguments[2], isDirectory: true)
)

do {
    try builder.run()
} catch {
    fputs("marketing_compositor failed: \(error)\n", stderr)
    exit(1)
}
