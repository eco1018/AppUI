//
//
//  DiaryEmotions.swift
//  AppUI
//
//  Minimalist diary emotions interface
//

import SwiftUI

struct DiaryEmotions: View {
    @State private var animateContent = false
    @State private var sadness: Double = 0
    @State private var anxiety: Double = 0
    @State private var anger: Double = 0
    @State private var shame: Double = 0
    @State private var joy: Double = 0
    @State private var fear: Double = 0
    
    let emotions = [
        ("sadness", "sadness"),
        ("anxiety", "anxiety"),
        ("anger", "anger"),
        ("shame", "shame"),
        ("joy", "joy"),
        ("fear", "fear")
    ]
    
    var body: some View {
        ZStack {
            // Clean gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.99, blue: 1.0),
                    Color(red: 0.97, green: 0.97, blue: 0.99),
                    Color(red: 0.95, green: 0.95, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                // Emotions rating content - compact layout to fit all 6
                VStack(spacing: 20) {
                    ForEach(Array(emotions.enumerated()), id: \.offset) { index, emotion in
                        EmotionSlider(
                            emotionName: emotion.0,
                            value: getBinding(for: emotion.1),
                            animationDelay: 0.6 + Double(index) * 0.1
                        )
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.6 + Double(index) * 0.1), value: animateContent)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
                
                Spacer()
                nextSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
    private func getBinding(for emotion: String) -> Binding<Double> {
        switch emotion {
        case "sadness": return $sadness
        case "anxiety": return $anxiety
        case "anger": return $anger
        case "shame": return $shame
        case "joy": return $joy
        case "fear": return $fear
        default: return $sadness
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    // Navigate back
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Title
            HStack {
                Text("Emotions")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 60)
        }
    }
    
    // MARK: - Next Section
    private var nextSection: some View {
        VStack {
            // Next button - centered
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                // Handle next action
            }) {
                Text("next")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                    .tracking(-0.3)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

struct EmotionSlider: View {
    let emotionName: String
    @Binding var value: Double
    let animationDelay: Double
    
    var body: some View {
        VStack(spacing: 12) {
            // Emotion name and value
            HStack {
                Text(emotionName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
                
                Text("\(Int(value))")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .frame(width: 20, alignment: .trailing)
            }
            
            // Custom slider
            ZStack(alignment: .leading) {
                // Track background
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .frame(height: 6)
                
                // Active track
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.8))
                    .frame(width: max(6, CGFloat(value / 10.0) * (UIScreen.main.bounds.width - 60)), height: 6)
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                    .offset(x: max(0, CGFloat(value / 10.0) * (UIScreen.main.bounds.width - 76)))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let newValue = Double(gesture.location.x / (UIScreen.main.bounds.width - 60)) * 10.0
                        value = max(0, min(10, newValue))
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
            )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.06), lineWidth: 0.5)
        )
    }
}

#Preview {
    DiaryEmotions()
}
