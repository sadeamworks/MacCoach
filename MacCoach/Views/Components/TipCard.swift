import SwiftUI

/// "Today's tip" card at the top of the dashboard, with an opt-in bell
/// for the daily notification. Keeps the app useful long after onboarding.
struct TipCard: View {
    @Environment(ProgressStore.self) private var progressStore
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        if let tip = DailyTipEngine.tip() {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.yellow)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 3) {
                    Text(localeManager.isArabic ? "نصيحة النهارده" : "Today's tip")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(tip.text(for: localeManager.selectedLanguage))
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(tip.keys)
                        .font(.caption.monospaced().weight(.semibold))
                        .foregroundStyle(Color.accentColor)
                        .environment(\.layoutDirection, .leftToRight)
                }

                Spacer(minLength: 0)

                Button {
                    toggleNotifications()
                } label: {
                    Image(systemName: progressStore.dailyTipNotificationsEnabled ? "bell.fill" : "bell.slash")
                        .font(.system(size: 12))
                        .foregroundStyle(progressStore.dailyTipNotificationsEnabled ? Color.accentColor : .secondary)
                }
                .buttonStyle(.plain)
                .help(localeManager.isArabic
                      ? "نصيحة يومية الساعة ١٠ الصبح"
                      : "Daily tip at 10 AM")
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.yellow.opacity(0.07))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.yellow.opacity(0.2), lineWidth: 1)
            )
        }
    }

    private func toggleNotifications() {
        progressStore.dailyTipNotificationsEnabled.toggle()
        if progressStore.dailyTipNotificationsEnabled {
            DailyTipEngine.scheduleNotifications(isArabic: localeManager.isArabic)
        } else {
            DailyTipEngine.cancelNotifications()
        }
    }
}
