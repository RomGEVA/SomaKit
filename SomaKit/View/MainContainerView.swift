import SwiftUI

enum Screen {
    case onboarding
    case home
    case notes
    case motivation
    case settings
    case about
    case breathing
}

struct MainContainerView: View {
    @State private var currentScreen: Screen = .onboarding
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            switch currentScreen {
            case .onboarding:
                OnboardingView(currentScreen: $currentScreen)
            case .home:
                HomeView(currentScreen: $currentScreen)
            case .notes:
                NotesView(currentScreen: $currentScreen)
            case .motivation:
                MotivationView(currentScreen: $currentScreen)
            case .settings:
                SettingsView(currentScreen: $currentScreen)
            case .about:
                AboutView(currentScreen: $currentScreen)
            case .breathing:
                BreathingView(currentScreen: $currentScreen)
            }
        }
        .onAppear {
            if hasCompletedOnboarding {
                currentScreen = .home
            }
        }
    }
}

#Preview {
    MainContainerView()
} 