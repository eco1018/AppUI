//
//
//  ActionsSelectionView.swift
//  AppUI
//
//  Actions selection with coordinator integration - Simplified
//

import SwiftUI

struct ActionsSelectionView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var showContinueButton = false
    
    let actions = [
        ActionItem(title: "substance use", description: "using alcohol or drugs to cope with pain or numb emotions", timing: ""),
        ActionItem(title: "disordered eating", description: "restricting, bingeing, or purging food as a way to deal with emotions or regain control", timing: ""),
        ActionItem(title: "lashing out at others", description: "yelling, threatening, or saying things you don't mean when you're upset", timing: ""),
        ActionItem(title: "withdrawing from people", description: "isolating or cutting off others when you're hurting or overwhelmed", timing: ""),
        ActionItem(title: "skipping therapy or DBT practice", description: "avoiding appointments or not using skills when you meant to", timing: ""),
        ActionItem(title: "risky sexual behavior", description: "engaging in sexual behavior that feels impulsive, unsafe, or unaligned with your values", timing: ""),
        ActionItem(title: "overspending or impulsive shopping", description: "spending money in ways that feel compulsive or bring guilt", timing: ""),
        ActionItem(title: "self-neglect", description: "going long periods without hygiene, eating, sleeping, or caring for your body", timing: ""),
        ActionItem(title: "avoiding responsibilities", description: "ignoring school, work, or other obligations due to overwhelm or avoidance", timing: ""),
        ActionItem(title: "breaking rules or the law", description: "engaging in illegal, high-risk, or impulsive behaviors", timing: "")
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
        .onChange(of: onboardingViewModel.selectedActions) { _ in
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
                    Text("Actions")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Choose 3 actions to track")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
                
                // Selection indicators
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        let isSelected = index < onboardingViewModel.selectedActions.count
                        let circleColor = isSelected ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.75, green: 0.75, blue: 0.77)
                        let scaleEffect: CGFloat = isSelected ? 1.3 : 1.0
                        
                        Circle()
                            .fill(circleColor)
                            .frame(width: 5, height: 5)
                            .scaleEffect(scaleEffect)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: onboardingViewModel.selectedActions.count)
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
                ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                    actionItemView(action: action, index: index)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 40)
        }
    }
    
    private func actionItemView(action: ActionItem, index: Int) -> some View {
        let isSelected = onboardingViewModel.selectedActions.contains(index)
        
        return Button(action: {
            handleActionSelection(index: index)
        }) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(action.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                        .multilineTextAlignment(.leading)
                    
                    Text(action.description)
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
    private func handleActionSelection(index: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if onboardingViewModel.selectedActions.contains(index) {
                onboardingViewModel.selectedActions.remove(index)
            } else if onboardingViewModel.selectedActions.count < 3 {
                onboardingViewModel.selectedActions.insert(index)
            }
        }
    }
    
    private func updateContinueButton() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showContinueButton = onboardingViewModel.selectedActions.count == 3
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Supporting Types
struct ActionItem {
    let title: String
    let description: String
    let timing: String
}

#Preview {
    ActionsSelectionView()
        .environmentObject(OnboardingViewModel(onOnboardingComplete: {}))
}
