import SwiftUI

struct DashboardView: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(localeManager.isArabic ? "Mac Coach" : "Mac Coach")
                    .font(.headline)
                Spacer()
                LanguageToggle()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // Progress bar placeholder
            ProgressBar(completed: 0, total: 6)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

            Divider()

            // Lesson list placeholder
            ScrollView {
                VStack(spacing: 8) {
                    Text(localeManager.isArabic ? "الدروس قريبا..." : "Lessons coming soon...")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 200)
                }
                .padding(16)
            }
        }
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
    }
}
