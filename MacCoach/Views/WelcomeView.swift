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

            Text(localeManager.isArabic
                 ? "دروس سريعة واختصارات هتخليك مرتاح في دقايق."
                 : "Quick lessons and shortcuts to get you comfortable in minutes.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            LanguageToggle()

            Button {
                progressStore.hasCompletedWelcome = true
            } label: {
                Text(localeManager.isArabic ? "يلا نبدأ!" : "Get Started")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Spacer()
        }
        .padding(24)
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
    }
}
