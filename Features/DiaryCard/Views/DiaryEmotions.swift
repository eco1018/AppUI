//
//
//  DiaryEmotions.swift
//  AppUI
//
//  Emotions tracking for diary card
//

import SwiftUI

struct DiaryEmotions: View {
    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
    @State private var animateContent = false
    
    // Sample emotions - you can expand this list
    let emotions = ["happy", "sad", "angry", "anxious", "calm", "frustrated", "hopeful", "overwhelmed", "grateful", "lonely"]
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            emotionsContent
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
                Text("Emotions")
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
                Text("How are you feeling today?")
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
    
    // MARK: - Emotions Content
    private var emotionsContent: some View {
        VStack(spacing: 30) {
            // Emotions grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(Array(emotions.enumerated()), id: \.offset) { index, emotion in
                    emotionButton(emotion: emotion, index: index)
                }
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
        }
    }
    
    private func emotionButton(emotion: String, index: Int) -> some View {
        let isSelected = diaryViewModel.selectedEmotions.contains(emotion)
        
        return Button(action: {
            toggleEmotion(emotion)
        }) {
            Text(emotion)
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
            if !diaryViewModel.selectedEmotions.isEmpty {
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
                .opacity(!diaryViewModel.selectedEmotions.isEmpty ? 1.0 : 0.0)
                .offset(y: !diaryViewModel.selectedEmotions.isEmpty ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: diaryViewModel.selectedEmotions.isEmpty)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func toggleEmotion(_ emotion: String) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if diaryViewModel.selectedEmotions.contains(emotion) {
                diaryViewModel.selectedEmotions.remove(emotion)
            } else {
                diaryViewModel.selectedEmotions.insert(emotion)
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
    DiaryEmotions()
        .environmentObject(DiaryCardViewModel())
}
