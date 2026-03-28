import Foundation

final class ContentStore: Sendable {
    static let shared = ContentStore()

    let lessons: [Lesson]
    let shortcuts: [ShortcutEntry]

    private init() {
        var loadedLessons: [Lesson] = []
        var loadedShortcuts: [ShortcutEntry] = []

        if let url = Bundle.main.url(forResource: "lessons", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            loadedLessons = (try? JSONDecoder().decode([Lesson].self, from: data)) ?? []
            loadedLessons.sort { $0.order < $1.order }
        }

        if let url = Bundle.main.url(forResource: "shortcuts", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            loadedShortcuts = (try? JSONDecoder().decode([ShortcutEntry].self, from: data)) ?? []
        }

        self.lessons = loadedLessons
        self.shortcuts = loadedShortcuts
    }
}
