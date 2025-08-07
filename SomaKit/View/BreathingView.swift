import SwiftUI

enum BreathingPhase: String {
    case inhale = "Inhale"
    case hold = "Delay"
    case exhale = "Exhalation"
    case none = ""
}

struct BreathingView: View {
    @Binding var currentScreen: Screen
    
    @State private var phase: BreathingPhase = .none
    @State private var scale: CGFloat = 0.5
    @State private var isActive = false
    @State private var animateContent = false
    
    let duration: Double = 4.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Animated background
            ZStack {
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.04))
                        .frame(width: CGFloat.random(in: 50...200))
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -400...400)
                        )
                }
            }
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        stopExercise()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentScreen = .home
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Breath")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                .padding(.bottom, 40)
                .offset(y: animateContent ? 0 : -50)
                .opacity(animateContent ? 1.0 : 0.0)
                
                Spacer()
                
                // Breathing Animation
                VStack(spacing: 50) {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 10)
                            .frame(width: 250, height: 250)
                        
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 250, height: 250)
                        
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 100, height: 100)
                            .scaleEffect(scale)
                        
                        Text(phase.rawValue)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black)
                            .opacity(isActive ? 1.0 : 0.0)
                    }
                    
                    Text(isActive ? "Follow the instructions on the screen" : "Click to start the exercise")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .offset(y: animateContent ? 0 : 50)
                .opacity(animateContent ? 1.0 : 0.0)
                
                Spacer()
                
                // Control Button
                Button(action: {
                    if isActive {
                        stopExercise()
                    } else {
                        startExercise()
                    }
                }) {
                    Text(isActive ? "Finish" : "Start")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                }
                .offset(y: animateContent ? 0 : 50)
                .opacity(animateContent ? 1.0 : 0.0)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateContent = true
            }
        }
        .onDisappear {
            stopExercise()
        }
    }
    
    private func startExercise() {
        isActive = true
        animateBreathing()
    }
    
    private func stopExercise() {
        isActive = false
        withAnimation {
            phase = .none
            scale = 0.5
        }
    }
    
    private func animateBreathing() {
        guard isActive else { return }
        
        // Inhale
        withAnimation(.easeInOut(duration: duration)) {
            phase = .inhale
            scale = 2.5
        }
        
        // Hold 1
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard isActive else { return }
            withAnimation(.easeInOut(duration: duration)) {
                phase = .hold
            }
            
            // Exhale
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                guard isActive else { return }
                withAnimation(.easeInOut(duration: duration)) {
                    phase = .exhale
                    scale = 0.5
                }
                
                // Hold 2
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    guard isActive else { return }
                    withAnimation(.easeInOut(duration: duration)) {
                        phase = .hold
                    }
                    
                    // Repeat
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        animateBreathing()
                    }
                }
            }
        }
    }
}

#Preview {
    BreathingView(currentScreen: .constant(.breathing))
} 
