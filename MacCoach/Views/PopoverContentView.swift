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

enum MainTab {
    case lessons
    case cheatSheet
}

struct PopoverContentView: View {
    @State private var progressStore = ProgressStore()
    @State private var localeManager = LocaleManager()
    @State private var currentScreen: NavigationDestination = .welcome
    @State private var selectedTab: MainTab = .lessons

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
            VStack(spacing: 0) {
                // Tab content
                Group {
                    switch selectedTab {
                    case .lessons:
                        DashboardView(onSelectLesson: { lesson in
                            if !lesson.cards.isEmpty {
                                currentScreen = .lesson(lesson)
                            }
                        })
                    case .cheatSheet:
                        CheatSheetView()
                    }
                }

                // Tab bar
                Divider()
                tabBar
            }
        case .lesson(let lesson):
            LessonView(lesson: lesson, onBack: {
                currentScreen = .dashboard
            })
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton(
                icon: "book",
                label: localeManager.isArabic ? "الدروس" : "Lessons",
                tab: .lessons
            )
            tabButton(
                icon: "list.bullet.rectangle",
                label: localeManager.isArabic ? "الاختصارات" : "Shortcuts",
                tab: .cheatSheet
            )
        }
        .padding(.vertical, 4)
        .environment(\.layoutDirection, localeManager.isArabic ? .rightToLeft : .leftToRight)
    }

    private func tabButton(icon: String, label: String, tab: MainTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.caption2)
            }
            .foregroundStyle(selectedTab == tab ? Color.accentColor : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
