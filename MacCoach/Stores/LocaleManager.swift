import Foundation
import Observation

@Observable
class LocaleManager {
    private let defaults = UserDefaults.standard

    var selectedLanguage: String {
        didSet {
            defaults.set(selectedLanguage, forKey: "selectedLanguage")
        }
    }

    var isArabic: Bool {
        selectedLanguage == "ar"
    }

    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
    }
}
