import Testing
import Foundation
@testable import MacCoach

@Test func lessonModelDecoding() async throws {
    let json = """
    [{
        "id": "test",
        "titleEN": "Test Lesson",
        "titleAR": "درس تجريبي",
        "hookEN": "A test hook",
        "hookAR": "خطاف تجريبي",
        "icon": "star",
        "order": 1,
        "cards": []
    }]
    """.data(using: .utf8)!

    let lessons = try JSONDecoder().decode([Lesson].self, from: json)
    #expect(lessons.count == 1)
    #expect(lessons[0].title(for: "en") == "Test Lesson")
    #expect(lessons[0].title(for: "ar") == "درس تجريبي")
}

@Test func shortcutModelDecoding() async throws {
    let json = """
    [{
        "id": "copy",
        "category": "general",
        "windowsShortcut": "Ctrl+C",
        "macShortcut": "Cmd+C",
        "descriptionEN": "Copy",
        "descriptionAR": "نسخ",
        "searchTermsEN": ["copy"],
        "searchTermsAR": ["نسخ"]
    }]
    """.data(using: .utf8)!

    let shortcuts = try JSONDecoder().decode([ShortcutEntry].self, from: json)
    #expect(shortcuts.count == 1)
    #expect(shortcuts[0].description(for: "ar") == "نسخ")
}

@Test func quizScoreTitlesCoverAllRanges() {
    for percent in [0, 39, 40, 69, 70, 89, 90, 100] {
        #expect(!QuizEngine.scoreTitle(percent: percent, isArabic: false).isEmpty)
        #expect(!QuizEngine.scoreTitle(percent: percent, isArabic: true).isEmpty)
    }
}

@Test func quizShareMessageContainsScore() {
    #expect(QuizEngine.shareMessage(percent: 80, isArabic: false).contains("80"))
    #expect(QuizEngine.shareMessage(percent: 80, isArabic: true).contains("80"))
}
