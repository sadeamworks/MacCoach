import AppKit

/// Renders the full shortcut cheat sheet as a branded, paginated A4 PDF.
/// This is the app's shareable artifact — the footer carries the App Store link.
enum CheatSheetPDF {
    struct Category {
        let id: String
        let label: String
    }

    // A4 in points
    private static let pageWidth: CGFloat = 595
    private static let pageHeight: CGFloat = 842
    private static let margin: CGFloat = 44
    private static let footerHeight: CGFloat = 40

    // Brand palette (navy / teal)
    private static let navy = NSColor(calibratedRed: 0x0d / 255, green: 0x1f / 255, blue: 0x35 / 255, alpha: 1)
    private static let teal = NSColor(calibratedRed: 0x04 / 255, green: 0xae / 255, blue: 0xab / 255, alpha: 1)
    private static let rowLine = NSColor(calibratedWhite: 0.85, alpha: 1)

    static func generate(shortcuts: [ShortcutEntry], categories: [Category], isArabic: Bool) -> Data? {
        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData) else { return nil }
        var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        guard let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else { return nil }

        let title = isArabic ? "ورقة اختصارات ويندوز ← ماك" : "Windows → Mac Cheat Sheet"
        let columnWindows = isArabic ? "على ويندوز" : "On Windows"
        let columnMac = isArabic ? "على الماك" : "On Mac"

        var pageNumber = 0
        var cursorY: CGFloat = 0

        func beginPage() {
            if pageNumber > 0 { endPage() }
            pageNumber += 1
            ctx.beginPDFPage(nil)
            let ns = NSGraphicsContext(cgContext: ctx, flipped: false)
            NSGraphicsContext.current = ns
            drawHeader()
            drawFooter()
            cursorY = pageHeight - margin - 66
        }

        func endPage() {
            NSGraphicsContext.current = nil
            ctx.endPDFPage()
        }

        func drawHeader() {
            let brand = "Switcher Coach"
            let brandAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor: navy
            ]
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: teal
            ]
            let brandString = NSAttributedString(string: brand, attributes: brandAttrs)
            let titleString = NSAttributedString(string: title, attributes: titleAttrs)
            let topY = pageHeight - margin - 20

            if isArabic {
                let brandSize = brandString.size()
                brandString.draw(at: NSPoint(x: pageWidth - margin - brandSize.width, y: topY))
                let titleSize = titleString.size()
                titleString.draw(at: NSPoint(x: pageWidth - margin - titleSize.width, y: topY - 18))
            } else {
                brandString.draw(at: NSPoint(x: margin, y: topY))
                titleString.draw(at: NSPoint(x: margin, y: topY - 18))
            }

            // Accent rule under the header
            teal.setFill()
            NSRect(x: margin, y: topY - 28, width: pageWidth - margin * 2, height: 2).fill()
        }

        func drawFooter() {
            let text = isArabic
                ? "Switcher Coach — دليلك من ويندوز للماك  •  switchercoach.sadeam.space  •  apps.apple.com/app/id6761324146"
                : "Switcher Coach — your Windows→Mac guide  •  switchercoach.sadeam.space  •  apps.apple.com/app/id6761324146"
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 8, weight: .regular),
                .foregroundColor: NSColor(calibratedWhite: 0.45, alpha: 1)
            ]
            let footer = NSAttributedString(string: text, attributes: attrs)
            let size = footer.size()
            footer.draw(at: NSPoint(x: (pageWidth - size.width) / 2, y: 22))

            let pageAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 8),
                .foregroundColor: NSColor(calibratedWhite: 0.6, alpha: 1)
            ]
            let pageString = NSAttributedString(string: "\(pageNumber)", attributes: pageAttrs)
            pageString.draw(at: NSPoint(x: pageWidth - margin, y: 22))
        }

        func ensureRoom(_ needed: CGFloat) {
            if cursorY - needed < margin + footerHeight {
                beginPage()
            }
        }

        func drawCategoryHeader(_ label: String) {
            ensureRoom(44)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 13, weight: .bold),
                .foregroundColor: navy
            ]
            let string = NSAttributedString(string: label, attributes: attrs)
            let size = string.size()
            let x = isArabic ? pageWidth - margin - size.width : margin
            string.draw(at: NSPoint(x: x, y: cursorY - size.height))
            cursorY -= size.height + 4

            // Column captions
            let capAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 8, weight: .semibold),
                .foregroundColor: NSColor(calibratedWhite: 0.5, alpha: 1)
            ]
            let win = NSAttributedString(string: columnWindows.uppercased(), attributes: capAttrs)
            let mac = NSAttributedString(string: columnMac.uppercased(), attributes: capAttrs)
            if isArabic {
                win.draw(at: NSPoint(x: 195, y: cursorY - 10))
                mac.draw(at: NSPoint(x: margin, y: cursorY - 10))
            } else {
                win.draw(at: NSPoint(x: 280, y: cursorY - 10))
                mac.draw(at: NSPoint(x: 410, y: cursorY - 10))
            }
            cursorY -= 16
        }

        func drawRow(_ shortcut: ShortcutEntry) {
            let rowHeight: CGFloat = 26
            ensureRoom(rowHeight)

            let descParagraph = NSMutableParagraphStyle()
            descParagraph.alignment = isArabic ? .right : .left
            descParagraph.baseWritingDirection = isArabic ? .rightToLeft : .leftToRight
            descParagraph.lineBreakMode = .byTruncatingTail
            let descAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 9.5),
                .foregroundColor: NSColor(calibratedWhite: 0.15, alpha: 1),
                .paragraphStyle: descParagraph
            ]
            let keyParagraph = NSMutableParagraphStyle()
            keyParagraph.lineBreakMode = .byTruncatingTail
            let winAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedSystemFont(ofSize: 9, weight: .regular),
                .foregroundColor: NSColor(calibratedWhite: 0.45, alpha: 1),
                .paragraphStyle: keyParagraph
            ]
            let macAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedSystemFont(ofSize: 9, weight: .semibold),
                .foregroundColor: teal,
                .paragraphStyle: keyParagraph
            ]

            let desc = NSAttributedString(string: shortcut.description(for: isArabic ? "ar" : "en"), attributes: descAttrs)
            let win = NSAttributedString(string: shortcut.windowsShortcut, attributes: winAttrs)
            let mac = NSAttributedString(string: shortcut.macShortcut, attributes: macAttrs)

            let textY = cursorY - 17
            if isArabic {
                // RTL: description on the right, then Windows, then Mac on the left
                desc.draw(in: NSRect(x: 330, y: textY - 4, width: pageWidth - margin - 330, height: 22))
                win.draw(in: NSRect(x: 195, y: textY, width: 125, height: 12))
                mac.draw(in: NSRect(x: margin, y: textY, width: 145, height: 12))
            } else {
                desc.draw(in: NSRect(x: margin, y: textY - 4, width: 226, height: 22))
                win.draw(in: NSRect(x: 280, y: textY, width: 120, height: 12))
                mac.draw(in: NSRect(x: 410, y: textY, width: 141, height: 12))
            }

            rowLine.setFill()
            NSRect(x: margin, y: cursorY - rowHeight + 3, width: pageWidth - margin * 2, height: 0.5).fill()
            cursorY -= rowHeight
        }

        beginPage()
        for category in categories {
            let items = shortcuts.filter { $0.category == category.id }
            guard !items.isEmpty else { continue }
            cursorY -= 8
            drawCategoryHeader(category.label)
            for item in items {
                drawRow(item)
            }
        }
        endPage()
        ctx.closePDF()
        return data as Data
    }
}
