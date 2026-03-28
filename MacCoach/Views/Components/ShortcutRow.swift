import SwiftUI

struct ShortcutRow: View {
    let shortcut: ShortcutEntry
    let language: String
    let isPinned: Bool
    let onTogglePin: () -> Void

    @State private var isExpanded = false

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

                    // Windows shortcut
                    Text(shortcut.windowsShortcut)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .frame(width: 90, alignment: .leading)

                    Image(systemName: "arrow.right")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)

                    // Mac shortcut
                    Text(shortcut.macShortcut)
                        .font(.caption.monospaced().weight(.semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

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

            // Expanded detail
            if isExpanded {
                Text(shortcut.description(for: language))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 6)
                    .padding(.leading, 24)
            }
        }
    }
}
