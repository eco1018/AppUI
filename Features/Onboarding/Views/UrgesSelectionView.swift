//

//
//  UrgesSelectionView.swift
//  AppUI
//
//  Enhanced version with coordinator integration - Simplified
//

import SwiftUI

struct UrgesSelectionView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var showContinueButton = false
    
    let urges = [
        UrgeItem(title: "substance use", description: "the desire to use drugs or alcohol to cope with pain", timing: "track patterns • build awareness"),
        UrgeItem(title: "disordered eating", description: "the urge to restrict, binge, or purge food", timing: "mindful eating • body awareness"),
        UrgeItem(title: "shutting down", description: "an urge to shut down emotionally and avoid interaction", timing: "emotional regulation • connection tools"),
        UrgeItem(title: "breaking things", description: "the urge to destroy things when feeling triggered", timing: "anger management • impulse control"),
        UrgeItem(title: "alleviate", description: "reduce feelings of distress and emotional pain", timing: "coping strategies • healing"),
        UrgeItem(title: "anxiety", description: "overwhelming worry and fear responses", timing: "mindfulness • grounding"),
        UrgeItem(title: "awake", description: "difficulty with sleep and rest patterns", timing: "sleep hygiene • relaxation"),
        UrgeItem(title: "sleep", description: "challenges with healthy sleep cycles", timing: "routine • environment"),
        UrgeItem(title: "balance", description: "finding stability in daily life", timing: "wellness • harmony")
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
                scrollableContent
                bottomSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
        .onChange(of: onboardingViewModel.selectedUrges) { _ in
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
                    Text("Urges")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("choose 2 to track and heal")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
                
                // Selection indicators
                HStack(spacing: 8) {
                    ForEach(0..<2, id: \.self) { index in
                        let isSelected = index < onboardingViewModel.selectedUrges.count
                        let circleColor = isSelected ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.75, green: 0.75, blue: 0.77)
                        let scaleEffect: CGFloat = isSelected ? 1.3 : 1.0
                        
                        Circle()
                            .fill(circleColor)
                            .frame(width: 5, height: 5)
                            .scaleEffect(scaleEffect)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: onboardingViewModel.selectedUrges.count)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Simplified Scrollable Content
    private var scrollableContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(Array(urges.enumerated()), id: \.offset) { index, urge in
                    urgeItemView(urge: urge, index: index)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 40)
        }
    }
    
    private func urgeItemView(urge: UrgeItem, index: Int) -> some View {
        let isSelected = onboardingViewModel.selectedUrges.contains(index)
        
        return Button(action: {
            handleUrgeSelection(index: index)
        }) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(urge.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                        .multilineTextAlignment(.leading)
                    
                    Text(urge.description)
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
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.05), value: animateContent)
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
    private func handleUrgeSelection(index: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if onboardingViewModel.selectedUrges.contains(index) {
                onboardingViewModel.selectedUrges.remove(index)
            } else if onboardingViewModel.selectedUrges.count < 2 {
                onboardingViewModel.selectedUrges.insert(index)
            }
        }
    }
    
    private func updateContinueButton() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showContinueButton = onboardingViewModel.selectedUrges.count == 2
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Supporting Types
struct UrgeItem {
    let title: String
    let description: String
    let timing: String
}

#Preview {
    UrgesSelectionView()
        .environmentObject(OnboardingViewModel(onOnboardingComplete: {}))
}
