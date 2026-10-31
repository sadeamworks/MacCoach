import SwiftUI

/// "Send Switcher Coach to a friend" — the word-of-mouth affordance.
struct ShareAppButton: View {
    @Environment(LocaleManager.self) private var localeManager

    enum Style {
        case iconOnly
        case prominent
    }

    let style: Style

    var body: some View {
        ShareLink(
            item: AppLinks.appStoreURL,
            message: Text(AppLinks.shareMessage(isArabic: localeManager.isArabic))
        ) {
            switch style {
            case .iconOnly:
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            case .prominent:
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text(localeManager.isArabic
                         ? "صاحبك واخد ماك جديد؟ ابعتهوله"
                         : "Know someone getting a Mac? Send it")
                }
                .font(.caption.weight(.semibold))
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(style == .prominent ? Color.accentColor : Color.secondary)
        .help(localeManager.isArabic ? "شارك Switcher Coach" : "Share Switcher Coach")
    }
}
