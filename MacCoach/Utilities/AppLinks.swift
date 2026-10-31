import Foundation

enum AppLinks {
    /// Mac App Store product page for Switcher Coach.
    static let appStoreURL = URL(string: "https://apps.apple.com/app/id6761324146")!
    static let landingURL = URL(string: "https://switchercoach.sadeam.space")!

    static func shareMessage(isArabic: Bool) -> String {
        isArabic
            ? "لسه واخد ماك جديد؟ Switcher Coach هيخليك تتعود عليه في دقايق — دروس تفاعلية وورقة اختصارات من ويندوز للماك، بالعربي."
            : "Just got a Mac? Switcher Coach gets you comfortable in minutes — interactive lessons and a Windows→Mac cheat sheet."
    }
}
