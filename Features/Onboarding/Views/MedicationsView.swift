//
//
//  MedicationsView.swift
//  AppUI
//
//  Simple yes/no medication selection
//

import SwiftUI

struct MedicationsView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var showContinueButton = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            medicationSelectionContent
            Spacer()
            bottomSection
        }
        .onAppear {
            performAppearAnimations()
        }
        .onChange(of: onboardingViewModel.selectedMedication) { _ in
            updateContinueButton()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                // Replace hardcoded button with:
                BackButton {
                    onboardingViewModel.goToPrevious()
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Medications")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("do you take medications?")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Medication Selection Content (Centered)
    private var medicationSelectionContent: some View {
        VStack(spacing: 40) {
            // Clean text options
            VStack(spacing: 40) {
                // Yes option
                Button(action: {
                    selectOption("yes")
                }) {
                    Text("yes")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(onboardingViewModel.selectedMedication == "yes" ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.5, green: 0.5, blue: 0.55))
                        .scaleEffect(onboardingViewModel.selectedMedication == "yes" ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: onboardingViewModel.selectedMedication)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                
                // No option
                Button(action: {
                    selectOption("no")
                }) {
                    Text("no")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(onboardingViewModel.selectedMedication == "no" ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.5, green: 0.5, blue: 0.55))
                        .scaleEffect(onboardingViewModel.selectedMedication == "no" ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: onboardingViewModel.selectedMedication)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            }
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            if showContinueButton {
                NextButton(title: "continue") {
                    onboardingViewModel.goToNext()
                }
                .opacity(showContinueButton ? 1.0 : 0.0)
                .offset(y: showContinueButton ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: showContinueButton)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func selectOption(_ option: String) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            onboardingViewModel.selectedMedication = option
        }
    }
    
    private func updateContinueButton() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showContinueButton = !onboardingViewModel.selectedMedication.isEmpty
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    MedicationsView()
        .environmentObject(OnboardingViewModel(onOnboardingComplete: {}))
}
