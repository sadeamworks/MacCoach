import SwiftUI

struct CheatSheetView: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    @State private var searchText = ""

    private let allShortcuts = ContentStore.shared.shortcuts
    private let categories: [(id: String, labelEN: String, labelAR: String, icon: String)] = [
        ("general", "General", "عام", "command"),
        ("text", "Text Editing", "تحرير النص", "textformat"),
        ("finder", "Finder", "Finder", "folder"),
        ("screenshots", "Screenshots", "سكرين شوت", "camera.viewfinder"),
        ("system", "System", "النظام", "gearshape")
    ]

    private var language: String { localeManager.selectedLanguage }

    private var filteredShortcuts: [ShortcutEntry] {
        guard !searchText.isEmpty else { return allShortcuts }
        let query = searchText.lowercased()
        return allShortcuts.filter { shortcut in
            shortcut.windowsShortcut.lowercased().contains(query) ||
            shortcut.macShortcut.lowercased().contains(query) ||
            shortcut.description(for: language).lowercased().contains(query) ||
            shortcut.searchTerms(for: language).contains { $0.lowercased().contains(query) }
        }
    }

    private var pinnedShortcuts: [ShortcutEntry] {
        filteredShortcuts.filter { progressStore.isShortcutPinned($0.id) }
    }

    private func shortcuts(for category: String) -> [ShortcutEntry] {
        filteredShortcuts.filter { $0.category == category && !progressStore.isShortcutPinned($0.id) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.caption)

                TextField(
                    localeManager.isArabic ? "ابحث عن اختصار..." : "Search shortcuts...",
                    text: $searchText
                )
                .textFieldStyle(.plain)
                .font(.subheadline)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color.primary.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider()

            // Shortcut list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    // Pinned section
                    if !pinnedShortcuts.isEmpty {
                        sectionHeader(
                            icon: "star.fill",
                            label: localeManager.isArabic ? "المفضلة" : "Favorites"
                        )

                        ForEach(pinnedShortcuts) { shortcut in
                            shortcutRow(for: shortcut)
                            Divider().padding(.leading, 32)
                        }
                    }

                    // Category sections
                    ForEach(categories, id: \.id) { category in
                        let items = shortcuts(for: category.id)
                        if !items.isEmpty {
                            sectionHeader(
                                icon: category.icon,
                                label: localeManager.isArabic ? category.labelAR : category.labelEN
                            )

                            ForEach(items) { shortcut in
                                shortcutRow(for: shortcut)
                                Divider().padding(.leading, 32)
                            }
                        }
                    }

                    // No results
                    if filteredShortcuts.isEmpty {
                        VStack(spacing: 8) {
                            Text(localeManager.isArabic ? "مفيش نتائج" : "No results")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if localeManager.isArabic {
                                Text("Try searching in English?")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                    .environment(\.layoutDirection, .leftToRight)
                            } else {
                                Text("جرب تبحث بالعربي؟")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                    .environment(\.layoutDirection, .rightToLeft)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    }
                }
                .padding(.bottom, 8)
            }
        }
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
    }

    private func sectionHeader(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
            Text(label)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 4)
    }

    private func shortcutRow(for shortcut: ShortcutEntry) -> some View {
        ShortcutRow(
            shortcut: shortcut,
            language: language,
            isPinned: progressStore.isShortcutPinned(shortcut.id),
            onTogglePin: {
                progressStore.togglePinnedShortcut(shortcut.id)
            }
        )
    }
}
