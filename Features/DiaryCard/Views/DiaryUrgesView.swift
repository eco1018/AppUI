//
//
//  DiaryUrgesView.swift
//  AppUI
//
//  Urges tracking for diary card with ViewModel integration
//

import SwiftUI

struct DiaryUrgesView: View {
    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
    @State private var animateContent = false
    
    // Available urges (matching your onboarding flow)
    let availableUrges = [
        "substance use",
        "disordered eating",
        "shutting down",
        "breaking things",
        "alleviate",
        "anxiety",
        "awake",
        "sleep",
        "balance"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            urgesContent
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
                    diaryViewModel.goToPrevious()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            // Title
            HStack {
                Text("Urges")
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
                Text("Which urges did you experience today?")
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
    
    // MARK: - Urges Content
    private var urgesContent: some View {
        VStack(spacing: 30) {
            // Urges grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(Array(availableUrges.enumerated()), id: \.offset) { index, urge in
                    urgeButton(urge: urge, index: index)
                }
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
        }
    }
    
    private func urgeButton(urge: String, index: Int) -> some View {
        let isSelected = diaryViewModel.selectedUrges.contains(urge)
        
        return Button(action: {
            toggleUrge(urge)
        }) {
            Text(urge)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(isSelected ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.98, green: 0.98, blue: 0.99))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
                        )
                )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.8), value: animateContent)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            // Always show continue button for urges (can be none)
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
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func toggleUrge(_ urge: String) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if diaryViewModel.selectedUrges.contains(urge) {
                diaryViewModel.selectedUrges.remove(urge)
            } else {
                diaryViewModel.selectedUrges.insert(urge)
            }
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    DiaryUrgesView()
        .environmentObject(DiaryCardViewModel())
}
