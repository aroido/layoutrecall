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

        try demoFrameSettings(settings: settings)
            .savePNG(to: outputDirectory.appendingPathComponent("demo-frame-01.png"))
        try demoFrameMenu(menu: menu)
            .savePNG(to: outputDirectory.appendingPathComponent("demo-frame-02.png"))
        try demoFrameDiagnostics(diagnostics: diagnostics)
            .savePNG(to: outputDirectory.appendingPathComponent("demo-frame-03.png"))
        try demoFrameProfiles(profiles: profiles)
            .savePNG(to: outputDirectory.appendingPathComponent("demo-frame-04.png"))

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
            drawOrb(x: 1290, y: 120, radius: 220, color: colors.mint.withAlphaComponent(0.12))
            drawOrb(x: 1440, y: 760, radius: 160, color: colors.amber.withAlphaComponent(0.12))

            drawHeadline("Restore the monitor layout macOS keeps scrambling.", at: NSPoint(x: 96, y: 640), width: 600, fontSize: 54, height: 250)
            drawBody(
                "Save one known-good desk, then bring it back after sleep, wake, or reconnect only when the current display set is a confident match.",
                at: NSPoint(x: 96, y: 420),
                width: 460,
                fontSize: 25,
                height: 150
            )
            drawPills([
                "MacBook + dock desks",
                "Restore only when confident",
                "Manual fallback stays visible"
            ], origin: NSPoint(x: 96, y: 292))

            drawScreenshotCard(
                settings,
                frame: NSRect(x: 720, y: 178, width: 792, height: 582),
                angle: 0.8,
                glowAlpha: 0.0,
                shadowAlpha: 0.14,
                showsChrome: false,
                contentInset: 14
            )
            drawScreenshotCard(
                menu,
                frame: NSRect(x: 1084, y: 504, width: 258, height: 458),
                angle: -1.2,
                glowAlpha: 0.08,
                shadowAlpha: 0.16,
                showsChrome: false,
                contentInset: 10
            )
        }
    }

    private func featureTrust(menu: NSImage, diagnostics: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawHeadline("Know when LayoutRecall acted — and when it stayed manual.", at: NSPoint(x: 96, y: 590), width: 470, fontSize: 42, height: 210)
            drawBody(
                "Confidence, dependency state, and restore evidence stay close to the action so monitor moves never feel like a blind automation guess.",
                at: NSPoint(x: 96, y: 380),
                width: 410,
                fontSize: 21,
                height: 150
            )
            drawChecklist([
                "Matched profile and confidence",
                "Dependency state before recovery",
                "Diagnostics evidence after every attempt"
            ], origin: NSPoint(x: 96, y: 176))

            drawScreenshotCard(
                diagnostics,
                frame: NSRect(x: 620, y: 96, width: 890, height: 656),
                angle: 0.5,
                glowAlpha: 0.0,
                shadowAlpha: 0.14,
                showsChrome: false,
                contentInset: 14
            )
            drawScreenshotCard(
                menu,
                frame: NSRect(x: 1100, y: 390, width: 236, height: 420),
                angle: -1.0,
                glowAlpha: 0.08,
                shadowAlpha: 0.15,
                showsChrome: false,
                contentInset: 10
            )
        }
    }

    private func featureProfiles(profiles: NSImage, general: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawHeadline("Keep saved layouts and manual recovery close at hand.", at: NSPoint(x: 96, y: 590), width: 470, fontSize: 42, height: 210)
            drawBody(
                "Profiles, startup behavior, and direct recovery actions stay in one workflow so repeat desks remain predictable without hunting across the app.",
                at: NSPoint(x: 96, y: 380),
                width: 408,
                fontSize: 21,
                height: 150
            )
            drawChecklist([
                "Multiple saved desk profiles",
                "Fix Now and Apply Layout fallbacks",
                "Startup controls for repeat reconnects"
            ], origin: NSPoint(x: 96, y: 176))

            drawScreenshotCard(
                profiles,
                frame: NSRect(x: 610, y: 86, width: 900, height: 676),
                angle: 0.5,
                glowAlpha: 0.0,
                shadowAlpha: 0.14,
                showsChrome: false,
                contentInset: 14
            )
            drawScreenshotCard(
                general,
                frame: NSRect(x: 1120, y: 492, width: 264, height: 202),
                angle: -0.8,
                glowAlpha: 0.08,
                shadowAlpha: 0.14,
                showsChrome: false,
                contentInset: 10
            )
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

            drawScreenshotCard(
                settings,
                frame: NSRect(x: 650, y: 88, width: 468, height: 344),
                angle: 0.8,
                glowAlpha: 0.0,
                shadowAlpha: 0.14,
                showsChrome: false,
                contentInset: 12
            )
            drawScreenshotCard(
                menu,
                frame: NSRect(x: 936, y: 222, width: 186, height: 330),
                angle: -1.2,
                glowAlpha: 0.08,
                shadowAlpha: 0.16,
                showsChrome: false,
                contentInset: 10
            )
        }
    }

    private func slideOne(menu: NSImage, settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawHeadline("Review the saved desk state before you act.", at: NSPoint(x: 96, y: 618), width: 470, fontSize: 48, height: 160)
            drawBody("The restore view keeps the current layout and saved target side by side so the app earns trust before anything moves.", at: NSPoint(x: 96, y: 498), width: 410, fontSize: 22, height: 130)
            drawScreenshotCard(settings, frame: NSRect(x: 620, y: 86, width: 890, height: 656), angle: 0.4, glowAlpha: 0.0, shadowAlpha: 0.14, showsChrome: false, contentInset: 14)
            drawScreenshotCard(menu, frame: NSRect(x: 1070, y: 450, width: 248, height: 438), angle: -1.0, glowAlpha: 0.08, shadowAlpha: 0.14, showsChrome: false, contentInset: 10)
        }
    }

    private func slideTwo(menu: NSImage, diagnostics: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawHeadline("Restore stays visible from the menu bar.", at: NSPoint(x: 96, y: 618), width: 470, fontSize: 48, height: 160)
            drawBody("The menu keeps the matched profile, restore toggle, and direct actions close by when the desk comes back in a familiar state.", at: NSPoint(x: 96, y: 498), width: 410, fontSize: 22, height: 130)
            drawScreenshotCard(menu, frame: NSRect(x: 770, y: 76, width: 520, height: 748), angle: -0.6, glowAlpha: 0.0, shadowAlpha: 0.16, showsChrome: false, contentInset: 14)
            drawScreenshotCard(diagnostics, frame: NSRect(x: 1104, y: 404, width: 332, height: 254), angle: 0.8, glowAlpha: 0.06, shadowAlpha: 0.14, showsChrome: false, contentInset: 10)
        }
    }

    private func slideThree(profiles: NSImage, general: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawHeadline("Profiles keep repeat desks predictable.", at: NSPoint(x: 96, y: 618), width: 470, fontSize: 48, height: 160)
            drawBody("Save more than one setup, keep Apply Layout close, and keep startup behavior in the same workflow when your desk changes often.", at: NSPoint(x: 96, y: 498), width: 410, fontSize: 22, height: 130)
            drawScreenshotCard(profiles, frame: NSRect(x: 650, y: 86, width: 860, height: 670), angle: 0.4, glowAlpha: 0.0, shadowAlpha: 0.14, showsChrome: false, contentInset: 14)
            drawScreenshotCard(general, frame: NSRect(x: 1142, y: 476, width: 242, height: 184), angle: -0.8, glowAlpha: 0.06, shadowAlpha: 0.14, showsChrome: false, contentInset: 10)
        }
    }

    private func demoFrameSettings(settings: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1320, y: 126, radius: 170, color: colors.mint.withAlphaComponent(0.08))
            drawScreenshotCard(settings, frame: NSRect(x: 74, y: 58, width: 1452, height: 782), angle: 0, glowAlpha: 0.0, shadowAlpha: 0.12, showsChrome: false, contentInset: 18)
        }
    }

    private func demoFrameMenu(menu: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1220, y: 124, radius: 180, color: colors.amber.withAlphaComponent(0.08))
            drawScreenshotCard(menu, frame: NSRect(x: 514, y: 44, width: 572, height: 812), angle: 0, glowAlpha: 0.04, shadowAlpha: 0.16, showsChrome: false, contentInset: 16)
        }
    }

    private func demoFrameDiagnostics(diagnostics: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1330, y: 726, radius: 170, color: colors.mint.withAlphaComponent(0.08))
            drawScreenshotCard(diagnostics, frame: NSRect(x: 74, y: 58, width: 1452, height: 782), angle: 0, glowAlpha: 0.0, shadowAlpha: 0.12, showsChrome: false, contentInset: 18)
        }
    }

    private func demoFrameProfiles(profiles: NSImage) throws -> NSImage {
        try renderCanvas(size: NSSize(width: 1600, height: 900)) { rect in
            drawBackground(in: rect)
            drawOrb(x: 1260, y: 132, radius: 170, color: colors.amber.withAlphaComponent(0.08))
            drawScreenshotCard(profiles, frame: NSRect(x: 74, y: 58, width: 1452, height: 782), angle: 0, glowAlpha: 0.0, shadowAlpha: 0.12, showsChrome: false, contentInset: 18)
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

    private func drawScreenshotCard(
        _ image: NSImage,
        frame: NSRect,
        angle: CGFloat,
        glowAlpha: CGFloat = 0.0,
        shadowAlpha: CGFloat = 0.14,
        showsChrome: Bool = false,
        contentInset: CGFloat = 14
    ) {
        NSGraphicsContext.current?.saveGraphicsState()
        if let context = NSGraphicsContext.current?.cgContext {
            context.translateBy(x: frame.midX, y: frame.midY)
            context.rotate(by: angle * .pi / 180)
            context.translateBy(x: -frame.midX, y: -frame.midY)
        }

        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(shadowAlpha)
        shadow.shadowBlurRadius = 22
        shadow.shadowOffset = NSSize(width: 0, height: -10)
        shadow.set()

        if glowAlpha > 0 {
            let glowRect = frame.insetBy(dx: -6, dy: -6)
            colors.cardGlow.withAlphaComponent(glowAlpha).setFill()
            NSBezierPath(roundedRect: glowRect, xRadius: 30, yRadius: 30).fill()
        }

        colors.cardFill.setFill()
        let cardPath = NSBezierPath(roundedRect: frame, xRadius: 24, yRadius: 24)
        cardPath.fill()

        colors.cardStroke.setStroke()
        cardPath.lineWidth = 1
        cardPath.stroke()

        var imageRect = frame.insetBy(dx: contentInset, dy: contentInset)
        if showsChrome {
            let chromeRect = NSRect(x: frame.minX, y: frame.maxY - 46, width: frame.width, height: 46)
            colors.chromeFill.setFill()
            NSBezierPath(
                roundedRect: chromeRect,
                xRadius: 24,
                yRadius: 24
            ).fill()

            let divider = NSBezierPath()
            divider.move(to: NSPoint(x: frame.minX + 16, y: chromeRect.minY))
            divider.line(to: NSPoint(x: frame.maxX - 16, y: chromeRect.minY))
            colors.cardStroke.withAlphaComponent(0.9).setStroke()
            divider.lineWidth = 1
            divider.stroke()

            drawWindowDots(origin: NSPoint(x: frame.minX + 18, y: frame.maxY - 28))
            imageRect = NSRect(
                x: frame.minX + contentInset,
                y: frame.minY + contentInset,
                width: frame.width - (contentInset * 2),
                height: frame.height - (contentInset * 2) - 34
            )
        }
        let clipPath = NSBezierPath(roundedRect: imageRect, xRadius: 16, yRadius: 16)
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
