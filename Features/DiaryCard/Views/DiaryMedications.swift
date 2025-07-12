//
//  DiaryMedications.swift
//  AppUI
//
//  Medications tracking for diary card
//

import SwiftUI

struct DiaryMedications: View {
    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
    @State private var animateContent = false
    @State private var showContinueButton = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            medicationsContent
            Spacer()
            bottomSection
        }
        .onAppear {
            performAppearAnimations()
            updateContinueButton()
        }
        .onChange(of: diaryViewModel.tookMedications) { _ in
            updateContinueButton()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton {
                    diaryViewModel.goToPrevious()
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            // Title
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
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            
            // Subtitle
            HStack {
                Text("Did you take your medications today?")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Medications Content
    private var medicationsContent: some View {
        VStack(spacing: 40) {
            // Yes option
            Button(action: {
                selectOption(true)
            }) {
                Text("yes")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(diaryViewModel.tookMedications ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.5, green: 0.5, blue: 0.55))
                    .scaleEffect(diaryViewModel.tookMedications ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: diaryViewModel.tookMedications)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            
            // No option
            Button(action: {
                selectOption(false)
            }) {
                Text("no")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(!diaryViewModel.tookMedications ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.5, green: 0.5, blue: 0.55))
                    .scaleEffect(!diaryViewModel.tookMedications ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: diaryViewModel.tookMedications)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            if showContinueButton {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    diaryViewModel.goToNext()
                }) {
                    Text("next")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .tracking(-0.3)
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
    private func selectOption(_ tookMeds: Bool) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            diaryViewModel.tookMedications = tookMeds
        }
    }
    
    private func updateContinueButton() {
        // For simplicity, always show continue button since it's a yes/no choice
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showContinueButton = true
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    DiaryMedications()
        .environmentObject(DiaryCardViewModel())
}
