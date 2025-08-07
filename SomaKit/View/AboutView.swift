import SwiftUI

struct AboutView: View {
    @Binding var currentScreen: Screen
    @State private var animateContent = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentScreen = .settings
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("About the application")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 60)
                    
                    // App icon and name
                    VStack(spacing: 20) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .scaleEffect(animateContent ? 1.0 : 0.5)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8), value: animateContent)
                        
                        Text("Soma")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .offset(y: animateContent ? 0 : 30)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateContent)
                        
                        Text("Version 1.0.0")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .offset(y: animateContent ? 0 : 30)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateContent)
                    }
                    
                    // Description
                    VStack(spacing: 20) {
                        Text("The idea of ​​the application")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .offset(y: animateContent ? 0 : 30)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateContent)
                        
                        Text("Soma is an app for those seeking peace and mindfulness in the modern world. We have created a space for reflection, meditation and personal growth.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .offset(y: animateContent ? 0 : 30)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.5), value: animateContent)
                    }
                    
                    // Features
                    VStack(spacing: 15) {
                        FeatureRow(icon: "note.text", text: "Write down your thoughts and reflections")
                        FeatureRow(icon: "sparkles", text: "Find inspiration in motivational quotes")
                        FeatureRow(icon: "heart", text: "Develop mindfulness and calmness")
                    }
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.6), value: animateContent)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                )
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    AboutView(currentScreen: .constant(.about))
} 
