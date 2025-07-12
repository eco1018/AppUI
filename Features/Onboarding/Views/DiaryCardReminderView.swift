//
//
//  DiaryCardReminderView.swift
//  AppUI
//
//  Daily reminder time selection with coordinator integration
//

import SwiftUI

struct DiaryCardReminderView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var showContinueButton = true
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            reminderTimeContent
            Spacer()
            bottomSection
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    onboardingViewModel.goToPrevious()
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
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Reminder")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("when should we remind you?")
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
    
    // MARK: - Reminder Time Content (Centered)
    private var reminderTimeContent: some View {
        VStack(spacing: 40) {
            // Minimalistic scrollable time display - easy to interact with
            ZStack {
                // Just the large time - clean and minimal
                Text(timeFormatter.string(from: onboardingViewModel.reminderTime))
                    .font(.system(size: 64, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-2)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
                
                // Large, easy-to-interact-with invisible picker
                DatePicker("", selection: $onboardingViewModel.reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .opacity(0)
                    .scaleEffect(1.5) // Larger for easier interaction
                    .allowsHitTesting(true)
                    .frame(width: 300, height: 200) // Large interaction area
                    .onChange(of: onboardingViewModel.reminderTime) { _ in
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
            }
            .frame(height: 120) // Consistent frame for the time display area
            
            // Subtle scroll hint
            Text("scroll to change")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.65))
                .opacity(animateContent ? 0.5 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
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
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.8)
                .animation(.easeOut(duration: 0.6).delay(1.0), value: animateContent)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Properties
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    DiaryCardReminderView()
        .environmentObject(OnboardingViewModel(onOnboardingComplete: {}))
}
