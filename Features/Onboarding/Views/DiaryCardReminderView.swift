
//
//  DiaryCardReminderView.swift
//  AppUI
//
//  Daily reminder time selection - Simplified
//

import SwiftUI

struct DiaryCardReminderView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var animateContent = false
    
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
    
    // MARK: - Simplified Reminder Time Content
    private var reminderTimeContent: some View {
        VStack(spacing: 40) {
            // Time display card
            VStack(spacing: 20) {
                Text(timeFormatter.string(from: onboardingViewModel.reminderTime))
                    .font(.system(size: 48, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                
                Text("Daily reminder time")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 40)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
                    )
            )
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.6), value: animateContent)
            
            // Time picker
            DatePicker("Select time", selection: $onboardingViewModel.reminderTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .onChange(of: onboardingViewModel.reminderTime) { _ in
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
        }
        .padding(.horizontal, 30)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            NextButton(title: "continue") {
                onboardingViewModel.goToNext()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
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
