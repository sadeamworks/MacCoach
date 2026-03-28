import SwiftUI

struct PopoverContentView: View {
    @State private var progressStore = ProgressStore()
    @State private var localeManager = LocaleManager()

    var body: some View {
        contentView
            .environment(progressStore)
            .environment(localeManager)
            .frame(minWidth: 320, maxWidth: 320, minHeight: 400, maxHeight: 480)
    }

    @ViewBuilder
    private var contentView: some View {
        if !progressStore.hasCompletedWelcome {
            WelcomeView()
        } else {
            DashboardView()
        }
    }
}
