

//
//
//  OnboardingSuccessView.swift
//  AppUI
//
//  Simple completion success view with coordinator integration
//

import SwiftUI

struct OnboardingSuccessView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var showContinueButton = false
    
    var body: some View {
        ZStack {
            // Simple background matching app style
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
            Spacer()  // Left spacer
            if showContinueButton {
                SubmitButton(title: "home", isLoading: onboardingViewModel.isLoading) {
                    onboardingViewModel.completeOnboarding()
                }
                .scaleEffect(showContinueButton ? 1.0 : 0.8)
                .opacity(showContinueButton ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContinueButton)
            }
            Spacer()  // Right spacer (ADD THIS)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
        
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
        .environmentObject(OnboardingViewModel(onOnboardingComplete: {}))
}
