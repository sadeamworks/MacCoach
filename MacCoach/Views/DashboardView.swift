import SwiftUI

struct DashboardView: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    let onSelectLesson: (Lesson) -> Void
    let onSelectQuiz: () -> Void

    private let lessons = ContentStore.shared.lessons

    private var essentials: [Lesson] { lessons.filter { $0.order <= 6 } }
    private var levelUp: [Lesson] { lessons.filter { $0.order > 6 } }

    private var allLessonsComplete: Bool {
        !lessons.isEmpty && lessons.allSatisfy { progressStore.isLessonComplete($0.id) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Switcher Coach")
                    .font(.headline)
                Spacer()
                ShareAppButton(style: .iconOnly)
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
                    TipCard()

                    // Completion banner
                    if allLessonsComplete {
                        VStack(spacing: 8) {
                            Image(systemName: "party.popper.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.accentColor)
                            Text(localeManager.isArabic ? "مبروك! انت كده ماك يوزر!" : "You're a Mac user now!")
                                .font(.subheadline.weight(.semibold))
                            Text(localeManager.isArabic ? "خلصت كل الدروس. ارجع لأي درس وقت ما تحب." : "All lessons complete. Revisit any lesson anytime.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            ShareAppButton(style: .prominent)
                                .padding(.top, 2)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor.opacity(0.08))
                        )
                    }

                    quizCard

                    sectionHeader(localeManager.isArabic ? "الأساسيات" : "The essentials")
                    ForEach(essentials) { lesson in
                        lessonCard(lesson)
                    }

                    if !levelUp.isEmpty {
                        sectionHeader(localeManager.isArabic ? "المستوى التاني" : "Level up")
                        ForEach(levelUp) { lesson in
                            lessonCard(lesson)
                        }
                    }
                }
                .padding(12)
            }
        }
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
    }

    private func sectionHeader(_ label: String) -> some View {
        HStack {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.top, 6)
        .padding(.horizontal, 2)
    }

    private func lessonCard(_ lesson: Lesson) -> some View {
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

    private var quizCard: some View {
        Button(action: onSelectQuiz) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.accentColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text(localeManager.isArabic ? "قد إيه انت جاهز للماك؟" : "How Mac-ready are you?")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(localeManager.isArabic ? "١٠ أسئلة سريعة — وشارك نتيجتك" : "10 quick questions — share your score")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if progressStore.bestQuizScore > 0 {
                    Text("\(progressStore.bestQuizScore)%")
                        .font(.caption.weight(.bold).monospacedDigit())
                        .foregroundStyle(Color.accentColor)
                        .environment(\.layoutDirection, .leftToRight)
                } else {
                    Image(systemName: localeManager.isArabic ? "chevron.left" : "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.accentColor.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
