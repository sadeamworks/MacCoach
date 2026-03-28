import SwiftUI

struct CardIllustration: View {
    let cardId: String

    var body: some View {
        illustration
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .padding(.vertical, 4)
            .environment(\.layoutDirection, .leftToRight)
    }

    @ViewBuilder
    private var illustration: some View {
        switch cardId {

        // MARK: - Window Management

        case "wm-1": // Green button maximize
            HStack(spacing: 6) {
                Circle().fill(.red).frame(width: 12, height: 12)
                Circle().fill(.yellow).frame(width: 12, height: 12)
                ZStack {
                    Circle().fill(.green).frame(width: 12, height: 12)
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 6, weight: .bold))
                        .foregroundStyle(.white)
                }
                Image(systemName: "plus")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                KeyCap(label: "Option", icon: "option")
                Image(systemName: "equal")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Image(systemName: "macwindow")
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            }

        case "wm-2": // Window snapping
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.accentColor.opacity(0.3))
                    .frame(width: 36, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.accentColor, lineWidth: 1.5)
                    )
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 36, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.secondary.opacity(0.4), lineWidth: 1)
                    )
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
            )

        case "wm-3": // Cmd+Tab app switching
            HStack(spacing: 8) {
                appIcon(symbol: "safari", color: .blue)
                appIcon(symbol: "envelope.fill", color: .accentColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.accentColor, lineWidth: 2)
                    )
                appIcon(symbol: "music.note", color: .pink)
                appIcon(symbol: "terminal", color: .primary)
            }

        case "wm-4": // Mission Control
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 44, height: 30)
                    .offset(x: -16, y: 6)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 44, height: 30)
                    .offset(x: 16, y: 6)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 44, height: 30)
                    .offset(x: 0, y: -8)
                Image(systemName: "rectangle.3.group")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .offset(y: -24)
            }

        // MARK: - Keyboard Shortcuts

        case "kb-1": // Cmd = Ctrl
            HStack(spacing: 6) {
                KeyCap(label: "Ctrl", icon: nil)
                    .opacity(0.5)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                KeyCap(label: "Cmd", icon: "command")
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.accentColor, lineWidth: 1.5)
                    )
            }

        case "kb-2": // Force Quit
            HStack(spacing: 4) {
                KeyCap(label: nil, icon: "command")
                Image(systemName: "plus").font(.system(size: 8)).foregroundStyle(.secondary)
                KeyCap(label: nil, icon: "option")
                Image(systemName: "plus").font(.system(size: 8)).foregroundStyle(.secondary)
                KeyCap(label: "Esc", icon: nil)
                Image(systemName: "arrow.right").font(.caption).foregroundStyle(.secondary)
                Image(systemName: "xmark.app.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
            }

        case "kb-3": // Screenshots
            HStack(spacing: 12) {
                VStack(spacing: 2) {
                    Image(systemName: "rectangle.dashed")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                    Text("⌘⇧4").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                }
                VStack(spacing: 2) {
                    Image(systemName: "rectangle.inset.filled")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                    Text("⌘⇧3").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                }
                VStack(spacing: 2) {
                    Image(systemName: "menubar.rectangle")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                    Text("⌘⇧5").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                }
            }

        case "kb-4": // Delete key
            HStack(spacing: 8) {
                VStack(spacing: 2) {
                    Image(systemName: "delete.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                    Text("Delete").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                Text("/").foregroundStyle(.quaternary)
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        Image(systemName: "fn")
                            .font(.caption)
                        Image(systemName: "delete.right")
                            .font(.title3)
                    }
                    .foregroundStyle(Color.accentColor)
                    Text("Fn+Delete").font(.system(size: 9)).foregroundStyle(.secondary)
                }
            }

        case "kb-5": // Find & Replace
            HStack(spacing: 6) {
                KeyCap(label: nil, icon: "command")
                KeyCap(label: "F", icon: nil)
                Image(systemName: "arrow.right").font(.caption).foregroundStyle(.secondary)
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                Divider().frame(height: 20)
                KeyCap(label: nil, icon: "command")
                KeyCap(label: "H", icon: nil)
                Image(systemName: "arrow.right").font(.caption).foregroundStyle(.secondary)
                Image(systemName: "eye.slash")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

        // MARK: - Finder

        case "finder-1": // Column view
            HStack(spacing: 1) {
                finderColumn(items: ["Documents", "Photos", "Downloads"], highlight: "Downloads")
                finderColumn(items: ["Trip.jpg", "Cat.png", "Art.pdf"], highlight: nil)
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.primary.opacity(0.03))
                    .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Color.secondary.opacity(0.2)))
            )

        case "finder-2": // Cut-paste is different
            HStack(spacing: 6) {
                KeyCap(label: nil, icon: "command")
                KeyCap(label: "C", icon: nil)
                Image(systemName: "arrow.right").font(.caption).foregroundStyle(.secondary)
                KeyCap(label: nil, icon: "command")
                KeyCap(label: nil, icon: "option")
                KeyCap(label: "V", icon: nil)
                Image(systemName: "equal").font(.caption2).foregroundStyle(.secondary)
                Image(systemName: "arrow.right.doc.on.clipboard")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
            }

        case "finder-3": // Quick Look
            HStack(spacing: 10) {
                Image(systemName: "doc.richtext")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Image(systemName: "plus")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primary.opacity(0.08))
                        .frame(width: 36, height: 28)
                    Text("Space")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "eye")
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            }

        case "finder-4": // Go to folder
            HStack(spacing: 4) {
                KeyCap(label: nil, icon: "command")
                KeyCap(label: nil, icon: "shift")
                KeyCap(label: "G", icon: nil)
                Image(systemName: "arrow.right").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 2) {
                    Image(systemName: "folder")
                        .font(.caption)
                    Text("~/Downloads")
                        .font(.system(size: 10, design: .monospaced))
                }
                .foregroundStyle(Color.accentColor)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor.opacity(0.08))
                )
            }

        // MARK: - Trackpad Gestures

        case "tp-1": // Two-finger right click
            HStack(spacing: 12) {
                trackpadView {
                    VStack(spacing: 3) {
                        Circle().fill(Color.accentColor).frame(width: 6, height: 6)
                        Circle().fill(Color.accentColor).frame(width: 6, height: 6)
                    }
                }
                Image(systemName: "equal").font(.caption2).foregroundStyle(.secondary)
                Image(systemName: "contextualmenu.and.cursorarrow")
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            }

        case "tp-2": // Two-finger scroll
            HStack(spacing: 12) {
                trackpadView {
                    VStack(spacing: 3) {
                        Circle().fill(Color.accentColor).frame(width: 6, height: 6)
                        Circle().fill(Color.accentColor).frame(width: 6, height: 6)
                    }
                    .offset(y: -4)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                        .offset(y: 8)
                }
                Image(systemName: "equal").font(.caption2).foregroundStyle(.secondary)
                Image(systemName: "scroll")
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            }

        case "tp-3": // Pinch to zoom
            HStack(spacing: 12) {
                trackpadView {
                    HStack(spacing: 10) {
                        Circle().fill(Color.accentColor).frame(width: 6, height: 6)
                        Circle().fill(Color.accentColor).frame(width: 6, height: 6)
                    }
                    Image(systemName: "arrow.left.and.right")
                        .font(.system(size: 8))
                        .foregroundStyle(Color.accentColor.opacity(0.5))
                }
                Image(systemName: "equal").font(.caption2).foregroundStyle(.secondary)
                Image(systemName: "plus.magnifyingglass")
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            }

        case "tp-4": // Three-finger gestures
            HStack(spacing: 12) {
                trackpadView {
                    HStack(spacing: 3) {
                        Circle().fill(Color.accentColor).frame(width: 5, height: 5)
                        Circle().fill(Color.accentColor).frame(width: 5, height: 5)
                        Circle().fill(Color.accentColor).frame(width: 5, height: 5)
                    }
                    Image(systemName: "arrow.up")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                        .offset(y: 6)
                }
                Image(systemName: "equal").font(.caption2).foregroundStyle(.secondary)
                Image(systemName: "rectangle.3.group")
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            }

        // MARK: - Apps & Dock

        case "dock-1": // Red X doesn't quit
            HStack(spacing: 8) {
                ZStack {
                    Circle().fill(.red).frame(width: 14, height: 14)
                    Image(systemName: "xmark")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundStyle(.white)
                }
                Image(systemName: "not.equal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "power")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Divider().frame(height: 24)
                KeyCap(label: nil, icon: "command")
                KeyCap(label: "Q", icon: nil)
                Image(systemName: "equal")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Image(systemName: "power")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
            }

        case "dock-2": // DMG install
            HStack(spacing: 6) {
                Image(systemName: "opticaldiscdrive")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "app.badge")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "folder")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                Text("Apps")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }

        case "dock-3": // Pin to Dock
            HStack(spacing: 2) {
                dockIcon(symbol: "safari", active: true)
                dockIcon(symbol: "envelope.fill", active: true)
                dockIcon(symbol: "music.note", active: false)
                ZStack {
                    dockIcon(symbol: "puzzlepiece.fill", active: false)
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.accentColor)
                        .offset(x: 10, y: -10)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primary.opacity(0.04))
            )

        case "dock-4": // App switcher
            HStack(spacing: 6) {
                KeyCap(label: nil, icon: "command")
                KeyCap(label: "Tab", icon: nil)
                Image(systemName: "arrow.right").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    appIcon(symbol: "safari", color: .blue)
                    appIcon(symbol: "envelope.fill", color: .accentColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(Color.accentColor, lineWidth: 2)
                        )
                    appIcon(symbol: "terminal", color: .primary)
                }
            }

        // MARK: - Spotlight

        case "spot-1": // Cmd+Space
            HStack(spacing: 6) {
                KeyCap(label: nil, icon: "command")
                KeyCap(label: "Space", icon: nil)
                Image(systemName: "arrow.right").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Spotlight")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.secondary.opacity(0.2)))
                )
            }

        case "spot-2": // Settings search
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Wi-Fi")
                        .font(.system(size: 11))
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.primary.opacity(0.05))
                )
                HStack(spacing: 6) {
                    Image(systemName: "wifi")
                        .font(.caption)
                        .foregroundStyle(Color.accentColor)
                    Text("Wi-Fi Settings")
                        .font(.system(size: 10))
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "gearshape")
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor.opacity(0.08))
                )
            }
            .frame(width: 180)

        case "spot-3": // File search
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("report.pdf")
                        .font(.system(size: 11))
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.primary.opacity(0.05))
                )
                HStack(spacing: 6) {
                    Image(systemName: "doc.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Text("Q4 Report.pdf")
                        .font(.system(size: 10))
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("Documents")
                        .font(.system(size: 9))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .frame(width: 180)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.primary.opacity(0.03))
                    .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Color.secondary.opacity(0.15)))
            )

        default:
            EmptyView()
        }
    }

    // MARK: - Reusable Components

    private func appIcon(symbol: String, color: Color) -> some View {
        Image(systemName: symbol)
            .font(.caption)
            .foregroundStyle(color)
            .frame(width: 28, height: 28)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(color.opacity(0.1))
            )
    }

    private func dockIcon(symbol: String, active: Bool) -> some View {
        VStack(spacing: 2) {
            Image(systemName: symbol)
                .font(.caption)
                .foregroundStyle(.primary)
                .frame(width: 24, height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.primary.opacity(0.08))
                )
            if active {
                Circle()
                    .fill(Color.primary.opacity(0.4))
                    .frame(width: 3, height: 3)
            }
        }
    }

    private func trackpadView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            content()
        }
        .frame(width: 52, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.secondary.opacity(0.25), lineWidth: 1)
                )
        )
    }

    private func finderColumn(items: [String], highlight: String?) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 3) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 7))
                        .foregroundStyle(item == highlight ? .white : Color.accentColor)
                    Text(item)
                        .font(.system(size: 8))
                        .foregroundStyle(item == highlight ? .white : .primary)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    if item == highlight {
                        RoundedRectangle(cornerRadius: 2).fill(Color.accentColor)
                    }
                }
            }
        }
        .frame(width: 76)
    }
}

private struct KeyCap: View {
    let label: String?
    let icon: String?

    var body: some View {
        Group {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10))
            }
            if let label {
                Text(label)
                    .font(.system(size: 9, weight: .medium))
            }
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.primary.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color.primary.opacity(0.15), lineWidth: 0.5)
                )
        )
    }
}
