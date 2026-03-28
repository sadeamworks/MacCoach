import SwiftUI

struct ShortcutRow: View {
    let shortcut: ShortcutEntry
    let language: String
    let isPinned: Bool
    let onTogglePin: () -> Void

    @State private var isExpanded = false

    private var isArabic: Bool { language == "ar" }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main row
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 8) {
                    // Pin button
                    Button {
                        onTogglePin()
                    } label: {
                        Image(systemName: isPinned ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundStyle(isPinned ? Color.yellow : Color.secondary)
                    }
                    .buttonStyle(.plain)

                    // Windows shortcut — always LTR
                    Text(shortcut.windowsShortcut)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .frame(width: 90, alignment: .leading)
                        .environment(\.layoutDirection, .leftToRight)

                    // Arrow stays pointing right (Windows → Mac conversion direction)
                    Image(systemName: "arrow.right")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)

                    // Mac shortcut — always LTR (keyboard keys)
                    Text(shortcut.macShortcut)
                        .font(.caption.monospaced().weight(.semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .environment(\.layoutDirection, .leftToRight)

                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            // Force LTR for the shortcut row layout — keys should always read left-to-right
            .environment(\.layoutDirection, .leftToRight)

            // Expanded detail — follows current language direction
            if isExpanded {
                Text(shortcut.description(for: language))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 6)
                    .padding(.leading, 24)
                    .frame(maxWidth: .infinity, alignment: isArabic ? .trailing : .leading)
                    .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
            }
        }
    }
}
