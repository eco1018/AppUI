//
//
//
//
//
//
//  DiaryEmotions.swift
//  AppUI
//
//  Emotions tracking for diary card with 0-10 rating scale
//

import SwiftUI

struct DiaryEmotions: View {
    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
    @State private var animateContent = false
    
    // Core emotions to be rated 0-10
    let emotions = ["happy", "sad", "angry", "anxious", "calm", "hopeful"]
    
    // Emotion ratings (0-10) - you'll need to add this to DiaryCardViewModel
    @State private var emotionRatings: [String: Double] = [
        "happy": 0,
        "sad": 0,
        "angry": 0,
        "anxious": 0,
        "calm": 0,
        "hopeful": 0
    ]
    
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
                Text("Rate how you're feeling today (0-10)")
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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                ForEach(Array(emotions.enumerated()), id: \.offset) { index, emotion in
                    emotionRatingView(emotion: emotion, index: index)
                }
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
        }
    }
    
    private func emotionRatingView(emotion: String, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Emotion name and current rating
            HStack {
                Text(emotion)
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
                
                Text("\(Int(emotionRatings[emotion] ?? 0))")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .frame(width: 40, alignment: .trailing)
            }
            
            // Visual progress indicator
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.9, green: 0.9, blue: 0.92))
                        .frame(height: 6)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .frame(width: geometry.size.width * CGFloat(emotionRatings[emotion] ?? 0) / 10.0, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: emotionRatings[emotion])
                }
            }
            .frame(height: 6)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let newValue = min(max(0, value.location.x / UIScreen.main.bounds.width * 10), 10)
                        emotionRatings[emotion] = round(newValue)
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(emotionCardBackground)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.8), value: animateContent)
    }
    
    private var emotionCardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.92, green: 0.92, blue: 0.94), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            NextButton(title: "next") {
                // Save ratings to view model
                saveEmotionRatings()
                diaryViewModel.goToNext()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(1.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func saveEmotionRatings() {
        // Convert ratings to your preferred format for the view model
        // For now, saving emotions with ratings > 0 to the existing selectedEmotions set
        diaryViewModel.selectedEmotions.removeAll()
        for (emotion, rating) in emotionRatings {
            if rating > 0 {
                diaryViewModel.selectedEmotions.insert("\(emotion):\(Int(rating))")
            }
        }
        
        // TODO: Consider updating DiaryCardViewModel to use [String: Int] for emotion ratings
        // instead of Set<String> for better data structure
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
