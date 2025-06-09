
//  OnboardingSuccessView.swift
//  AppUI
//
//  Simple completion success view
//

import SwiftUI

struct OnboardingSuccessView: View {
    @State private var animateContent = false
    @State private var showContinueButton = false
    @State private var progressValue: Double = 0
    
    var body: some View {
        ZStack {
            // Simple white background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                successContent
                Spacer()
                bottomSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
    // MARK: - Success Content (Centered)
    private var successContent: some View {
        VStack(spacing: 60) {
            // Success checkmark
            ZStack {
                Circle()
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 2)
                    .frame(width: 80, height: 80)
                    .scaleEffect(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateContent)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                    .scaleEffect(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.8), value: animateContent)
            }
            
            // Success message
            Text("all set")
                .font(.system(size: 48, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        HStack {
            Spacer()
            if showContinueButton {
                continueButton
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    private var continueButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            // Handle continue to main app
        }) {
            HStack(spacing: 10) {
                Text("complete")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(continueButtonBackground)
        }
        .scaleEffect(showContinueButton ? 1.0 : 0.8)
        .opacity(showContinueButton ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContinueButton)
    }
    
    private var continueButtonBackground: some View {
        Capsule()
            .fill(Color(red: 0.96, green: 0.96, blue: 0.97))
            .overlay(
                Capsule()
                    .stroke(Color(red: 0.82, green: 0.82, blue: 0.85), lineWidth: 1.2)
            )
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
    }
    
    // MARK: - Helper Methods
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
        
        // Complete the progress circle (removed since no progress indicator)
        // withAnimation(.easeInOut(duration: 2.0).delay(0.5)) {
        //     progressValue = 1.0
        // }
        
        // Show continue button after all animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showContinueButton = true
            }
        }
    }
}

#Preview {
    OnboardingSuccessView()
}
