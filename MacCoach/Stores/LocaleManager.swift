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
        // Use saved preference if available, otherwise detect system language
        if let saved = UserDefaults.standard.string(forKey: "selectedLanguage") {
            self.selectedLanguage = saved
        } else {
            // Detect system language: default to Arabic if Mac is set to Arabic, else English
            let systemLang = Locale.current.language.languageCode?.identifier ?? "en"
            self.selectedLanguage = (systemLang == "ar") ? "ar" : "en"
        }
    }
}
