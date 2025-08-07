import SwiftUI

struct OnboardingView: View {
    @Binding var currentScreen: Screen
    @State private var currentPage = 0
    @State private var animateContent = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    private let onboardingData = [
        OnboardingSlide(
            title: "Welcome",
            subtitle: "Discover a world of peace and mindfulness",
            icon: "heart.fill"
        ),
        OnboardingSlide(
            title: "Write down your thoughts",
            subtitle: "Save important moments and thoughts",
            icon: "note.text"
        ),
        OnboardingSlide(
            title: "Find motivation",
            subtitle: "Inspirational Quotes for Every Day",
            icon: "sparkles"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Content
                VStack(spacing: 30) {
                    Image(systemName: onboardingData[currentPage].icon)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .scaleEffect(animateContent ? 1.0 : 0.5)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8), value: animateContent)
                    
                    VStack(spacing: 16) {
                        Text(onboardingData[currentPage].title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(onboardingData[currentPage].subtitle)
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .offset(y: animateContent ? 0 : 50)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateContent)
                }
                
                Spacer()
                
                // Page indicators
                HStack(spacing: 12) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage -= 1
                                animateContent = false
                            }
                        }
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                    }
                    
                    Spacer()
                    
                    Button(currentPage == onboardingData.count - 1 ? "Start" : "Next") {
                        if currentPage < onboardingData.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                                animateContent = false
                            }
                        } else {
                            hasCompletedOnboarding = true
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentScreen = .home
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.1))
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateContent = true
        }
        .onChange(of: currentPage) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateContent = true
            }
        }
    }
}

struct OnboardingSlide {
    let title: String
    let subtitle: String
    let icon: String
}

#Preview {
    OnboardingView(currentScreen: .constant(.onboarding))
} 
