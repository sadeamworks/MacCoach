import SwiftUI

struct LanguageToggle: View {
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        @Bindable var locale = localeManager

        Picker("", selection: $locale.selectedLanguage) {
            Text("EN").tag("en")
            Text("ع").tag("ar")
        }
        .pickerStyle(.segmented)
        .frame(width: 80)
    }
}
