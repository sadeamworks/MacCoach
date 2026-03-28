import Foundation
import Observation

@Observable
class ProgressStore {
    private let defaults = UserDefaults.standard

    var hasCompletedWelcome: Bool {
        get { defaults.bool(forKey: "hasCompletedWelcome") }
        set { defaults.set(newValue, forKey: "hasCompletedWelcome") }
    }

    var isWindowsSwitcher: Bool {
        get { defaults.bool(forKey: "isWindowsSwitcher") }
        set { defaults.set(newValue, forKey: "isWindowsSwitcher") }
    }

    var completedLessons: [String] {
        get { defaults.stringArray(forKey: "completedLessons") ?? [] }
        set { defaults.set(newValue, forKey: "completedLessons") }
    }

    var lessonCardProgress: [String: Int] {
        get { defaults.dictionary(forKey: "lessonCardProgress") as? [String: Int] ?? [:] }
        set { defaults.set(newValue, forKey: "lessonCardProgress") }
    }

    var pinnedShortcuts: [String] {
        get { defaults.stringArray(forKey: "pinnedShortcuts") ?? [] }
        set { defaults.set(newValue, forKey: "pinnedShortcuts") }
    }

    func markLessonComplete(_ lessonId: String) {
        var completed = completedLessons
        if !completed.contains(lessonId) {
            completed.append(lessonId)
            completedLessons = completed
        }
    }

    func isLessonComplete(_ lessonId: String) -> Bool {
        completedLessons.contains(lessonId)
    }

    func saveCardProgress(lessonId: String, cardIndex: Int) {
        var progress = lessonCardProgress
        progress[lessonId] = cardIndex
        lessonCardProgress = progress
    }

    func cardProgress(for lessonId: String) -> Int {
        lessonCardProgress[lessonId] ?? 0
    }

    func togglePinnedShortcut(_ shortcutId: String) {
        var pinned = pinnedShortcuts
        if pinned.contains(shortcutId) {
            pinned.removeAll { $0 == shortcutId }
        } else {
            pinned.append(shortcutId)
        }
        pinnedShortcuts = pinned
    }

    func isShortcutPinned(_ shortcutId: String) -> Bool {
        pinnedShortcuts.contains(shortcutId)
    }
}
