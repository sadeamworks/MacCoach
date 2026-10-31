import Foundation
import Observation

@Observable
class ProgressStore {
    private let defaults = UserDefaults.standard

    var hasCompletedWelcome: Bool {
        didSet { defaults.set(hasCompletedWelcome, forKey: "hasCompletedWelcome") }
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

    var hasRequestedReview: Bool {
        didSet { defaults.set(hasRequestedReview, forKey: "hasRequestedReview") }
    }

    var bestQuizScore: Int {
        didSet { defaults.set(bestQuizScore, forKey: "bestQuizScore") }
    }

    var dailyTipNotificationsEnabled: Bool {
        didSet { defaults.set(dailyTipNotificationsEnabled, forKey: "dailyTipNotificationsEnabled") }
    }

    init() {
        let d = UserDefaults.standard
        self.hasCompletedWelcome = d.bool(forKey: "hasCompletedWelcome")
        self.completedLessons = d.stringArray(forKey: "completedLessons") ?? []
        self.lessonCardProgress = d.dictionary(forKey: "lessonCardProgress") as? [String: Int] ?? [:]
        self.pinnedShortcuts = d.stringArray(forKey: "pinnedShortcuts") ?? []
        self.hasRequestedReview = d.bool(forKey: "hasRequestedReview")
        self.bestQuizScore = d.integer(forKey: "bestQuizScore")
        self.dailyTipNotificationsEnabled = d.bool(forKey: "dailyTipNotificationsEnabled")
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
