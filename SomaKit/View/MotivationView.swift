import SwiftUI

struct MotivationView: View {
    @Binding var currentScreen: Screen
    @State private var currentQuoteIndex = 0
    @State private var animateQuote = false
    @State private var animateBackground = false
    
    private let quotes = [
        "Peace comes from within. Don't look for it outside.",
        "Every day is a new opportunity to become better.",
        "Breathe deeply and allow yourself to be.",
        "In silence you will find answers to all questions.",
        "Gratitude is the key to happiness.",
        "Accept yourself as you are.",
        "Small steps lead to big changes.",
        "Trust the process of life.",
        "Self-love is the basis of everything.",
        "All power is in the present moment."
    ]
    
    var body: some View {
        ZStack {
            // Animated background
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Floating circles
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.03))
                        .frame(width: CGFloat.random(in: 100...300))
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -400...400)
                        )
                        .scaleEffect(animateBackground ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: 4)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                            value: animateBackground
                        )
                }
            }
            
            VStack(spacing: 40) {
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
                    
                    Text("Meditations")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        changeQuote()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                
                Spacer()
                
                // Quote card
                VStack(spacing: 30) {
                    // Quote icon
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.3))
                        .scaleEffect(animateQuote ? 1.0 : 0.5)
                        .opacity(animateQuote ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8), value: animateQuote)
                    
                    // Quote text
                    Text(quotes[currentQuoteIndex])
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .offset(y: animateQuote ? 0 : 30)
                        .opacity(animateQuote ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateQuote)
                    
                    // Decorative line
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 2)
                        .scaleEffect(animateQuote ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateQuote)
                }
                .padding(40)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Navigation dots
                HStack(spacing: 12) {
                    ForEach(0..<quotes.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentQuoteIndex ? Color.white : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentQuoteIndex ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentQuoteIndex)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateQuote = true
            animateBackground = true
        }
    }
    
    private func changeQuote() {
        withAnimation(.easeInOut(duration: 0.5)) {
            animateQuote = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
            animateQuote = true
        }
    }
}

#Preview {
    MotivationView(currentScreen: .constant(.motivation))
} 
