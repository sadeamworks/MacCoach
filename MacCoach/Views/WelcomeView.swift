import SwiftUI

struct WelcomeView: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "graduationcap.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.accentColor)

            Text(localeManager.isArabic ? "مرحبا بك في الماك!" : "Welcome to your new Mac!")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            LanguageToggle()

            VStack(spacing: 12) {
                Button {
                    progressStore.isWindowsSwitcher = true
                    progressStore.hasCompletedWelcome = true
                } label: {
                    Text(localeManager.isArabic ? "أيوه، ساعدني!" : "Yes, help me!")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button {
                    progressStore.isWindowsSwitcher = false
                    progressStore.hasCompletedWelcome = true
                } label: {
                    Text(localeManager.isArabic ? "لا، بتصفح بس" : "No, just exploring")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }

            Spacer()
        }
        .padding(24)
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
    }
}
