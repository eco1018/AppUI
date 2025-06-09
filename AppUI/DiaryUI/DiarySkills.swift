//
//  DiarySkills.swift
//  AppUI
//
//
//  DiarySkills.swift
//  AppUI
//
//  Minimalist diary skills interface
//

import SwiftUI

struct DiarySkills: View {
    @State private var animateContent = false
    @State private var mindfulness: Double = 0
    @State private var distressTolerance: Double = 0
    @State private var emotionRegulation: Double = 0
    @State private var interpersonalEffectiveness: Double = 0
    
    let skills = [
        ("mindfulness", "mindfulness"),
        ("distress tolerance", "distressTolerance"),
        ("emotion regulation", "emotionRegulation"),
        ("interpersonal effectiveness", "interpersonalEffectiveness")
    ]
    
    var body: some View {
        ZStack {
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
                
                VStack(spacing: 24) {
                    ForEach(Array(skills.enumerated()), id: \.offset) { index, skill in
                        SkillSlider(
                            skillName: skill.0,
                            value: getBinding(for: skill.1),
                            animationDelay: 0.6 + Double(index) * 0.1
                        )
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.6 + Double(index) * 0.1), value: animateContent)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 40)
                
                Spacer()
                nextSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
    private func getBinding(for skill: String) -> Binding<Double> {
        switch skill {
        case "mindfulness": return $mindfulness
        case "distressTolerance": return $distressTolerance
        case "emotionRegulation": return $emotionRegulation
        case "interpersonalEffectiveness": return $interpersonalEffectiveness
        default: return $mindfulness
        }
    }
    
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
            
            HStack {
                Text("Skills")
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
    
    private var nextSection: some View {
        VStack {
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
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

struct SkillSlider: View {
    let skillName: String
    @Binding var value: Double
    let animationDelay: Double
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(skillName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
                
                Text("\(Int(value))")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .frame(width: 20, alignment: .trailing)
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.8))
                    .frame(width: max(6, CGFloat(value / 10.0) * (UIScreen.main.bounds.width - 60)), height: 6)
                
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
        .padding(.vertical, 14)
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
    DiarySkills()
}
