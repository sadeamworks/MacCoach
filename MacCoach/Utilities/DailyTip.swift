import Foundation
import UserNotifications

/// One bite-sized tip per calendar day, derived deterministically from the
/// shortcut pool — no network, no storage, same tip all day.
struct DailyTip {
    let textEN: String
    let textAR: String
    let keys: String

    func text(for language: String) -> String {
        language == "ar" ? textAR : textEN
    }
}

enum DailyTipEngine {
    static var pool: [DailyTip] {
        ContentStore.shared.shortcuts.map { shortcut in
            DailyTip(
                textEN: shortcut.descriptionEN,
                textAR: shortcut.descriptionAR,
                keys: shortcut.macShortcut
            )
        }
    }

    /// Deterministic index for a given date (same tip all day, cycles the pool).
    static func tip(for date: Date = Date()) -> DailyTip? {
        let tips = pool
        guard !tips.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return tips[day % tips.count]
    }

    // MARK: - Notifications

    private static let notificationPrefix = "dailytip-"

    /// Schedules the next 14 daily tips at 10:00 local time.
    /// Re-run on every launch so the queue stays topped up.
    static func scheduleNotifications(isArabic: Bool) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(
                withIdentifiers: (0..<30).map { "\(notificationPrefix)\($0)" }
            )
            let calendar = Calendar.current
            for offset in 0..<14 {
                guard let date = calendar.date(byAdding: .day, value: offset, to: Date()),
                      let tip = tip(for: date) else { continue }

                var components = calendar.dateComponents([.year, .month, .day], from: date)
                components.hour = 10
                components.minute = 0
                guard let fireDate = calendar.date(from: components), fireDate > Date() else { continue }

                let content = UNMutableNotificationContent()
                content.title = isArabic ? "نصيحة الماك النهارده 💡" : "Today's Mac tip 💡"
                content.body = "\(isArabic ? tip.textAR : tip.textEN) — \(tip.keys)"
                content.sound = nil

                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate),
                    repeats: false
                )
                let request = UNNotificationRequest(
                    identifier: "\(notificationPrefix)\(offset)",
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    static func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: (0..<30).map { "\(notificationPrefix)\($0)" }
        )
    }
}
