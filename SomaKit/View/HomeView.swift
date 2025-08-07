import SwiftUI

struct HomeView: View {
    @Binding var currentScreen: Screen
    @State private var animateCards = false
    
    private let menuItems = [
        MenuItem(title: "Reflections", subtitle: "Write down your thoughts", icon: "note.text", screen: .notes),
        MenuItem(title: "Breath", subtitle: "Calm your mind", icon: "wind", screen: .breathing),
        MenuItem(title: "Meditations", subtitle: "Find inspiration", icon: "sparkles", screen: .motivation),
        MenuItem(title: "Settings", subtitle: "Personalize the app", icon: "gearshape", screen: .settings),
        MenuItem(title: "About the application", subtitle: "Find out more", icon: "info.circle", screen: .about)
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Soma")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("A world of peace and awareness")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 60)
                    .offset(y: animateCards ? 0 : -50)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8), value: animateCards)
                    
                    Spacer(minLength: 30)
                    
                    // Menu cards
                    VStack(spacing: 20) {
                        ForEach(Array(menuItems.enumerated()), id: \.offset) { index, item in
                            MenuCardView(item: item) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentScreen = item.screen
                                }
                            }
                            .offset(x: animateCards ? 0 : 300)
                            .opacity(animateCards ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1), value: animateCards)
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
        .onAppear {
            animateCards = true
        }
    }
}

struct MenuItem {
    let title: String
    let subtitle: String
    let icon: String
    let screen: Screen
}

struct MenuCardView: View {
    let item: MenuItem
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            HStack(spacing: 20) {
                Image(systemName: item.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(item.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
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
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

#Preview {
    HomeView(currentScreen: .constant(.home))
} 
