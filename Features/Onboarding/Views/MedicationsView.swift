//
//
//
//  MedicationsView.swift
//  AppUI
//
//  Simple yes/no medication selection with card UI
//

import SwiftUI

struct MedicationsView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var showContinueButton = false
    
    let options = [
        MedicationOption(title: "yes", description: "I take medications regularly"),
        MedicationOption(title: "no", description: "I don't currently take any medications")
    ]
    
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
    
    // MARK: - Medication Selection Content
    private var medicationSelectionContent: some View {
        VStack(spacing: 16) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                medicationOptionView(option: option, index: index)
            }
        }
        .padding(.horizontal, 30)
    }
    
    private func medicationOptionView(option: MedicationOption, index: Int) -> some View {
        let isSelected = onboardingViewModel.selectedMedication == option.title
        
        return Button(action: {
            selectOption(option.title)
        }) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                        .multilineTextAlignment(.leading)
                    
                    Text(option.description)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(isSelected ? Color.white.opacity(0.8) : Color(red: 0.5, green: 0.5, blue: 0.55))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                } else {
                    Circle()
                        .stroke(Color(red: 0.8, green: 0.8, blue: 0.85), lineWidth: 1)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.98, green: 0.98, blue: 0.99))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: isSelected ? 0 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.6), value: animateContent)
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
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            onboardingViewModel.selectedMedication = option
        }
    }
    
    private func updateContinueButton() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showContinueButton = !onboardingViewModel.selectedMedication.isEmpty
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Supporting Types
struct MedicationOption {
    let title: String
    let description: String
}

#Preview {
    MedicationsView()
        .environmentObject(OnboardingViewModel(onOnboardingComplete: {}))
}
