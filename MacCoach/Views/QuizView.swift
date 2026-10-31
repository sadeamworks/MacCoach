import SwiftUI

/// "How Mac-ready are you?" — 10 questions from the shortcut pool,
/// ending in a shareable score.
struct QuizView: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    let onBack: () -> Void

    private enum Phase {
        case question
        case finished
    }

    @State private var questions: [QuizQuestion] = []
    @State private var currentIndex = 0
    @State private var correctCount = 0
    @State private var selectedOption: Int? = nil
    @State private var phase: Phase = .question

    private var isArabic: Bool { localeManager.isArabic }
    private var percent: Int {
        guard !questions.isEmpty else { return 0 }
        return Int((Double(correctCount) / Double(questions.count) * 100).rounded())
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            switch phase {
            case .question:
                if questions.indices.contains(currentIndex) {
                    questionView(questions[currentIndex])
                }
            case .finished:
                scoreView
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        .onAppear {
            if questions.isEmpty {
                questions = QuizEngine.makeQuiz()
                if questions.isEmpty { onBack() }
            }
        }
    }

    private var header: some View {
        HStack {
            Button(action: onBack) {
                HStack(spacing: 4) {
                    Image(systemName: isArabic ? "chevron.right" : "chevron.left")
                    Text(isArabic ? "رجوع" : "Back")
                }
                .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color.accentColor)

            Spacer()

            if phase == .question {
                Text("\(currentIndex + 1) / \(questions.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .environment(\.layoutDirection, .leftToRight)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func questionView(_ question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(isArabic ? "إزاي تعملها على الماك؟" : "How do you do it on the Mac?")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(question.prompt(for: localeManager.selectedLanguage))
                .font(.subheadline.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 8) {
                ForEach(question.options.indices, id: \.self) { index in
                    optionButton(question: question, index: index)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(16)
    }

    private func optionButton(question: QuizQuestion, index: Int) -> some View {
        let isSelected = selectedOption == index
        let isCorrect = index == question.correctIndex
        let revealed = selectedOption != nil

        return Button {
            guard selectedOption == nil else { return }
            selectedOption = index
            if isCorrect { correctCount += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                advance()
            }
        } label: {
            HStack {
                Text(question.options[index])
                    .font(.callout.monospaced())
                    .environment(\.layoutDirection, .leftToRight)
                Spacer()
                if revealed && isCorrect {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                } else if revealed && isSelected {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor(revealed: revealed, isCorrect: isCorrect, isSelected: isSelected))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func backgroundColor(revealed: Bool, isCorrect: Bool, isSelected: Bool) -> Color {
        guard revealed else { return Color.primary.opacity(0.04) }
        if isCorrect { return Color.green.opacity(0.15) }
        if isSelected { return Color.red.opacity(0.12) }
        return Color.primary.opacity(0.04)
    }

    private func advance() {
        selectedOption = nil
        if currentIndex + 1 < questions.count {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex += 1
            }
        } else {
            if percent > progressStore.bestQuizScore {
                progressStore.bestQuizScore = percent
            }
            withAnimation(.easeInOut(duration: 0.25)) {
                phase = .finished
            }
        }
    }

    private var scoreView: some View {
        VStack(spacing: 12) {
            Spacer()

            Text("\(percent)%")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(Color.accentColor)
                .environment(\.layoutDirection, .leftToRight)

            Text(QuizEngine.scoreTitle(percent: percent, isArabic: isArabic))
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(isArabic
                 ? "جاوبت صح على \(correctCount) من \(questions.count)"
                 : "\(correctCount) of \(questions.count) correct")
                .font(.caption)
                .foregroundStyle(.secondary)

            if progressStore.bestQuizScore > 0 {
                Text(isArabic
                     ? "أعلى نتيجة: \(progressStore.bestQuizScore)٪"
                     : "Best score: \(progressStore.bestQuizScore)%")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            ShareLink(
                item: AppLinks.appStoreURL,
                message: Text(QuizEngine.shareMessage(percent: percent, isArabic: isArabic))
            ) {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text(isArabic ? "شارك نتيجتك" : "Share your score")
                }
                .font(.caption.weight(.semibold))
            }
            .buttonStyle(.borderedProminent)

            Button {
                questions = QuizEngine.makeQuiz()
                currentIndex = 0
                correctCount = 0
                selectedOption = nil
                phase = .question
            } label: {
                Text(isArabic ? "جرب تاني" : "Try again")
                    .font(.caption)
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
    }
}
