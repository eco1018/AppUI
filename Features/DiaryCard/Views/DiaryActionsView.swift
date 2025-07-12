//
//
//  DiaryActionsView.swift
//  AppUI
//
//  Actions tracking for diary card with ViewModel integration
//

import SwiftUI

struct DiaryActionsView: View {
    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
    @State private var animateContent = false
    
    // Available actions (matching your onboarding flow)
    let availableActions = [
        "substance use",
        "disordered eating",
        "lashing out at others",
        "withdrawing from people",
        "skipping therapy or DBT practice",
        "risky sexual behavior",
        "overspending or impulsive shopping",
        "self-neglect",
        "avoiding responsibilities",
        "breaking rules or the law"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            actionsContent
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
                    diaryViewModel.goToPrevious()
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            // Title
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
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            
            // Subtitle
            HStack {
                Text("Did you engage in any of these actions today?")
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
    
    // MARK: - Actions Content
    private var actionsContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(Array(availableActions.enumerated()), id: \.offset) { index, action in
                    actionButton(action: action, index: index)
                }
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
        }
    }
    
    private func actionButton(action: String, index: Int) -> some View {
        let isPerformed = diaryViewModel.performedActions.contains(action)
        
        return Button(action: {
            toggleAction(action)
        }) {
            HStack {
                Text(action)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(isPerformed ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPerformed ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.98, green: 0.98, blue: 0.99))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isPerformed ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPerformed)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.8), value: animateContent)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            // Always show continue button for actions (can be none)
            NextButton(title: "next") {
                diaryViewModel.goToNext()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func toggleAction(_ action: String) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if diaryViewModel.performedActions.contains(action) {
                diaryViewModel.performedActions.remove(action)
            } else {
                diaryViewModel.performedActions.insert(action)
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
    DiaryActionsView()
        .environmentObject(DiaryCardViewModel())
}
