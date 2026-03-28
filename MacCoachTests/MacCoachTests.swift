import Testing

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
