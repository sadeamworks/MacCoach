import SwiftUI

enum NavigationDestination: Equatable {
    case welcome
    case dashboard
    case lesson(Lesson)

    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        switch (lhs, rhs) {
        case (.welcome, .welcome), (.dashboard, .dashboard):
            return true
        case (.lesson(let a), .lesson(let b)):
            return a.id == b.id
        default:
            return false
        }
    }
}

struct PopoverContentView: View {
    @State private var progressStore = ProgressStore()
    @State private var localeManager = LocaleManager()
    @State private var currentScreen: NavigationDestination = .welcome

    var body: some View {
        contentView
            .environment(progressStore)
            .environment(localeManager)
            .frame(minWidth: 320, maxWidth: 320, minHeight: 400, maxHeight: 480)
            .onAppear {
                currentScreen = progressStore.hasCompletedWelcome ? .dashboard : .welcome
            }
            .onChange(of: progressStore.hasCompletedWelcome) { _, newValue in
                if newValue {
                    currentScreen = .dashboard
                }
            }
    }

    @ViewBuilder
    private var contentView: some View {
        switch currentScreen {
        case .welcome:
            WelcomeView()
        case .dashboard:
            DashboardView(onSelectLesson: { lesson in
                if !lesson.cards.isEmpty {
                    currentScreen = .lesson(lesson)
                }
            })
        case .lesson(let lesson):
            LessonView(lesson: lesson, onBack: {
                currentScreen = .dashboard
            })
        }
    }
}
