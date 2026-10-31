import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let promptEN: String
    let promptAR: String
    let options: [String]      // mac shortcut strings, shown as-is
    let correctIndex: Int

    func prompt(for language: String) -> String {
        language == "ar" ? promptAR : promptEN
    }
}

/// Builds a 10-question multiple-choice quiz from the shortcut pool.
/// Wrong answers are drawn from the same category when possible, so the
/// choices stay plausible.
enum QuizEngine {
    static let questionCount = 10

    static func makeQuiz() -> [QuizQuestion] {
        let all = ContentStore.shared.shortcuts.filter { !$0.macShortcut.isEmpty }
        guard all.count >= 4 else { return [] }

        let subjects = Array(all.shuffled().prefix(questionCount))
        var quiz: [QuizQuestion] = []
        for subject in subjects {
            if let question = makeQuestion(for: subject, from: all) {
                quiz.append(question)
            }
        }
        return quiz
    }

    private static func makeQuestion(for subject: ShortcutEntry, from all: [ShortcutEntry]) -> QuizQuestion? {
        let sameCategory = all.filter {
            $0.category == subject.category && $0.id != subject.id && $0.macShortcut != subject.macShortcut
        }
        let others = all.filter { $0.id != subject.id && $0.macShortcut != subject.macShortcut }
        var distractorPool = sameCategory.count >= 3 ? sameCategory : others

        distractorPool.shuffle()
        var options: [String] = []
        for candidate in distractorPool where options.count < 3 {
            if !options.contains(candidate.macShortcut) {
                options.append(candidate.macShortcut)
            }
        }
        guard options.count == 3 else { return nil }

        let correctIndex = Int.random(in: 0...3)
        options.insert(subject.macShortcut, at: correctIndex)

        return QuizQuestion(
            promptEN: subject.descriptionEN,
            promptAR: subject.descriptionAR,
            options: options,
            correctIndex: correctIndex
        )
    }

    static func scoreTitle(percent: Int, isArabic: Bool) -> String {
        switch percent {
        case 90...:
            return isArabic ? "انت كده ماك يوزر أصلي! 🏆" : "Certified Mac user! 🏆"
        case 70..<90:
            return isArabic ? "قربت توصل! 🚀" : "Almost there! 🚀"
        case 40..<70:
            return isArabic ? "ماشي في السكة الصح 💪" : "On the right track 💪"
        default:
            return isArabic ? "الدروس هي طريقك — يلا بينا 📚" : "The lessons are your friend 📚"
        }
    }

    static func shareMessage(percent: Int, isArabic: Bool) -> String {
        isArabic
            ? "جبت \(percent)٪ في اختبار الجاهزية للماك على Switcher Coach 🎉 قد إيه انت جاهز؟"
            : "I scored \(percent)% Mac-ready on Switcher Coach 🎉 How ready are you?"
    }
}
