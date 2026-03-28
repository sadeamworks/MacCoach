import SwiftUI

struct LessonView: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    let lesson: Lesson
    let onBack: () -> Void

    @State private var currentCardIndex: Int = 0

    private var language: String { localeManager.selectedLanguage }
    private var isLastCard: Bool { currentCardIndex >= lesson.cards.count - 1 }
    private var isFirstCard: Bool { currentCardIndex <= 0 }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    saveProgress()
                    onBack()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: localeManager.isArabic ? "chevron.right" : "chevron.left")
                        Text(localeManager.isArabic ? "رجوع" : "Back")
                    }
                    .font(.subheadline)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.accentColor)

                Spacer()

                Text("\(currentCardIndex + 1) / \(lesson.cards.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .environment(\.layoutDirection, .leftToRight)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // Lesson title
            HStack {
                Image(systemName: lesson.icon)
                    .foregroundStyle(Color.accentColor)
                Text(lesson.title(for: language))
                    .font(.headline)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            Divider()

            // Card content
            if lesson.cards.indices.contains(currentCardIndex) {
                CardView(
                    card: lesson.cards[currentCardIndex],
                    language: language
                )
                .id(currentCardIndex)
                .transition(.asymmetric(
                    insertion: .move(edge: localeManager.isArabic ? .leading : .trailing).combined(with: .opacity),
                    removal: .move(edge: localeManager.isArabic ? .trailing : .leading).combined(with: .opacity)
                ))
            }

            Spacer(minLength: 0)

            // Navigation buttons
            Divider()

            HStack {
                if !isFirstCard {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            currentCardIndex -= 1
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: localeManager.isArabic ? "chevron.right" : "chevron.left")
                            Text(localeManager.isArabic ? "السابق" : "Previous")
                        }
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()

                if isLastCard {
                    Button {
                        progressStore.markLessonComplete(lesson.id)
                        onBack()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle")
                            Text(localeManager.isArabic ? "تم!" : "Complete!")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            currentCardIndex += 1
                            saveProgress()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(localeManager.isArabic ? "التالي" : "Next")
                            Image(systemName: localeManager.isArabic ? "chevron.left" : "chevron.right")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(12)
        }
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
        .onAppear {
            currentCardIndex = progressStore.cardProgress(for: lesson.id)
            if currentCardIndex >= lesson.cards.count {
                currentCardIndex = 0
            }
        }
    }

    private func saveProgress() {
        progressStore.saveCardProgress(lessonId: lesson.id, cardIndex: currentCardIndex)
    }
}
