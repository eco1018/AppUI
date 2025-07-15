//
//
//  DiaryUrgesView.swift
//  AppUI
//
//  Urges tracking for diary card with 0-10 rating scale
//

import SwiftUI

struct DiaryUrgesView: View {
    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
    @State private var animateContent = false
    
    // Available urges to be rated 0-10
    let urges = [
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
    
    // Urge ratings (0-10) - you'll need to add this to DiaryCardViewModel
    @State private var urgeRatings: [String: Double] = [
        "substance use": 0,
        "disordered eating": 0,
        "shutting down": 0,
        "breaking things": 0,
        "alleviate": 0,
        "anxiety": 0,
        "awake": 0,
        "sleep": 0,
        "balance": 0
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
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
                Text("Rate your urges today (0-10)")
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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 40) {
                ForEach(Array(urges.enumerated()), id: \.offset) { index, urge in
                    urgeRatingView(urge: urge, index: index)
                }
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
        }
    }
    
    private func urgeRatingView(urge: String, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Urge name and current rating
            HStack {
                Text(urge)
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
                
                Text("\(Int(urgeRatings[urge] ?? 0))")
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
                        .frame(width: geometry.size.width * CGFloat(urgeRatings[urge] ?? 0) / 10.0, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: urgeRatings[urge])
                }
            }
            .frame(height: 6)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let newValue = min(max(0, value.location.x / UIScreen.main.bounds.width * 10), 10)
                        urgeRatings[urge] = round(newValue)
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
            )
        }
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.8), value: animateContent)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            NextButton(title: "next") {
                // Save ratings to view model
                saveUrgeRatings()
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
    private func saveUrgeRatings() {
        // Convert ratings to your preferred format for the view model
        // For now, saving urges with ratings > 0 to the existing selectedUrges set
        diaryViewModel.selectedUrges.removeAll()
        for (urge, rating) in urgeRatings {
            if rating > 0 {
                diaryViewModel.selectedUrges.insert("\(urge):\(Int(rating))")
            }
        }
        
        // TODO: Consider updating DiaryCardViewModel to use [String: Int] for urge ratings
        // instead of Set<String> for better data structure
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
