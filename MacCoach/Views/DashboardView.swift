import SwiftUI

struct DashboardView: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    let onSelectLesson: (Lesson) -> Void

    private let lessons = ContentStore.shared.lessons

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Mac Coach")
                    .font(.headline)
                Spacer()
                LanguageToggle()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // Progress
            ProgressBar(
                completed: progressStore.completedLessons.count,
                total: lessons.count,
                language: localeManager.selectedLanguage
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            Divider()

            // Lesson list
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(lessons) { lesson in
                        LessonCard(
                            lesson: lesson,
                            language: localeManager.selectedLanguage,
                            isComplete: progressStore.isLessonComplete(lesson.id),
                            isInProgress: progressStore.cardProgress(for: lesson.id) > 0
                                && !progressStore.isLessonComplete(lesson.id),
                            onTap: {
                                onSelectLesson(lesson)
                            }
                        )
                    }
                }
                .padding(12)
            }
        }
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
    }
}
