import SwiftUI
import StoreKit

struct SettingsView: View {
    @Binding var currentScreen: Screen
    @AppStorage("showDailyTips") private var showDailyTips: Bool = true
    @State private var animateItems = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentScreen = .home
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Settings items
                VStack(spacing: 20) {
                    // Privacy Policy
                    SettingsItemView(
                        icon: "hand.raised",
                        title: "Privacy Policy",
                        subtitle: "Find out how we protect your data",
                        showToggle: false
                    ) {
                        openPrivacyPolicy()
                    }
                    .offset(x: animateItems ? 0 : -300)
                    .opacity(animateItems ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateItems)
                    
                    // Rate Us
                    SettingsItemView(
                        icon: "star",
                        title: "Rate the app",
                        subtitle: "Please support us by leaving a review",
                        showToggle: false
                    ) {
                        rateUs()
                    }
                    .offset(x: animateItems ? 0 : -300)
                    .opacity(animateItems ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateItems)
                    
                    // About
                    SettingsItemView(
                        icon: "info.circle",
                        title: "About the application",
                        subtitle: "Learn more about Soma",
                        showToggle: false
                    ) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentScreen = .about
                        }
                    }
                    .offset(x: animateItems ? 0 : -300)
                    .opacity(animateItems ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateItems)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // App version
                VStack(spacing: 8) {
                    Text("Soma")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Text("Version 1.0.0")
                        .font(.system(size: 14))
                        .foregroundColor(.gray.opacity(0.7))
                }
                .offset(y: animateItems ? 0 : 50)
                .opacity(animateItems ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.5), value: animateItems)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateItems = true
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://telegra.ph/Privacy-Policy-for-Soma-08-07") {
            UIApplication.shared.open(url)
        }
    }
    
    func rateUs() {
        SKStoreReviewController.requestReview()
    }
}

struct SettingsItemView: View {
    let icon: String
    let title: String
    let subtitle: String
    let showToggle: Bool
    var toggleValue: Binding<Bool>?
    var action: (() -> Void)?
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if let action = action {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                    action()
                }
            }
        }) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if showToggle, let toggleValue = toggleValue {
                    Toggle("", isOn: toggleValue)
                        .toggleStyle(CustomToggleStyle())
                } else if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .disabled(showToggle)
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            RoundedRectangle(cornerRadius: 20)
                .fill(configuration.isOn ? Color.white : Color.gray.opacity(0.3))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.black)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
        }
    }
}

#Preview {
    SettingsView(currentScreen: .constant(.settings))
} 
