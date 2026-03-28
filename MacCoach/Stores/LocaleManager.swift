import Foundation
import Observation

@Observable
class LocaleManager {
    private let defaults = UserDefaults.standard

    var selectedLanguage: String {
        get { defaults.string(forKey: "selectedLanguage") ?? "en" }
        set { defaults.set(newValue, forKey: "selectedLanguage") }
    }

    var isArabic: Bool {
        selectedLanguage == "ar"
    }
}
