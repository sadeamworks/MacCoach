import Foundation

struct Lesson: Codable, Identifiable {
    let id: String
    let titleEN: String
    let titleAR: String
    let hookEN: String
    let hookAR: String
    let icon: String
    let order: Int
    let cards: [Card]

    func title(for language: String) -> String {
        language == "ar" ? titleAR : titleEN
    }

    func hook(for language: String) -> String {
        language == "ar" ? hookAR : hookEN
    }
}

struct Card: Codable, Identifiable {
    let id: String
    let windowsLabelEN: String
    let windowsLabelAR: String
    let macLabelEN: String
    let macLabelAR: String
    let explanationEN: String
    let explanationAR: String
    let imageName: String?
    let tryItPromptEN: String?
    let tryItPromptAR: String?

    func windowsLabel(for language: String) -> String {
        language == "ar" ? windowsLabelAR : windowsLabelEN
    }

    func macLabel(for language: String) -> String {
        language == "ar" ? macLabelAR : macLabelEN
    }

    func explanation(for language: String) -> String {
        language == "ar" ? explanationAR : explanationEN
    }

    func tryItPrompt(for language: String) -> String? {
        language == "ar" ? tryItPromptAR : tryItPromptEN
    }
}
