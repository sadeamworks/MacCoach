import Foundation
import Observation

@Observable
class ProgressStore {
    private let defaults = UserDefaults.standard

    var hasCompletedWelcome: Bool {
        didSet { defaults.set(hasCompletedWelcome, forKey: "hasCompletedWelcome") }
    }

    var isWindowsSwitcher: Bool {
        didSet { defaults.set(isWindowsSwitcher, forKey: "isWindowsSwitcher") }
    }

    var completedLessons: [String] {
        didSet { defaults.set(completedLessons, forKey: "completedLessons") }
    }

    var lessonCardProgress: [String: Int] {
        didSet { defaults.set(lessonCardProgress, forKey: "lessonCardProgress") }
    }

    var pinnedShortcuts: [String] {
        didSet { defaults.set(pinnedShortcuts, forKey: "pinnedShortcuts") }
    }

    init() {
        let d = UserDefaults.standard
        self.hasCompletedWelcome = d.bool(forKey: "hasCompletedWelcome")
        self.isWindowsSwitcher = d.bool(forKey: "isWindowsSwitcher")
        self.completedLessons = d.stringArray(forKey: "completedLessons") ?? []
        self.lessonCardProgress = d.dictionary(forKey: "lessonCardProgress") as? [String: Int] ?? [:]
        self.pinnedShortcuts = d.stringArray(forKey: "pinnedShortcuts") ?? []
    }

    func markLessonComplete(_ lessonId: String) {
        if !completedLessons.contains(lessonId) {
            completedLessons.append(lessonId)
        }
    }

    func isLessonComplete(_ lessonId: String) -> Bool {
        completedLessons.contains(lessonId)
    }

    func saveCardProgress(lessonId: String, cardIndex: Int) {
        lessonCardProgress[lessonId] = cardIndex
    }

    func cardProgress(for lessonId: String) -> Int {
        lessonCardProgress[lessonId] ?? 0
    }

    func togglePinnedShortcut(_ shortcutId: String) {
        if pinnedShortcuts.contains(shortcutId) {
            pinnedShortcuts.removeAll { $0 == shortcutId }
        } else {
            pinnedShortcuts.append(shortcutId)
        }
    }

    func isShortcutPinned(_ shortcutId: String) -> Bool {
        pinnedShortcuts.contains(shortcutId)
    }
}
