import Foundation

struct ShortcutEntry: Codable, Identifiable {
    let id: String
    let category: String
    let windowsShortcut: String
    let macShortcut: String
    let descriptionEN: String
    let descriptionAR: String
    let searchTermsEN: [String]
    let searchTermsAR: [String]

    func description(for language: String) -> String {
        language == "ar" ? descriptionAR : descriptionEN
    }

    func searchTerms(for language: String) -> [String] {
        language == "ar" ? searchTermsAR : searchTermsEN
    }
}
