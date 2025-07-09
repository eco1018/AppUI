//
//
//  AgePreferenceView.swift
//  AppUI
//
//  Age preference management interface
//

import SwiftUI

struct AgePreferenceView: View {
    @State private var age: Double = 25.0
    @State private var animateContent = false
    @State private var hasChanges = false
    @State private var originalAge: Double = 25.0
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    let minAge: Double = 13
    let maxAge: Double = 80
    
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
                Spacer()
                ageSelectionContent
                Spacer()
                bottomSection
            }
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
                    profileViewModel.showSettings()
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
            
            // Title
            HStack {
                Text("age")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Age Selection Content
    private var ageSelectionContent: some View {
        VStack(spacing: 40) {
            // Current age display
            VStack(spacing: 8) {
                Text("\(Int(age))")
                    .font(.system(size: 64, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .opacity(animateContent ? 1.0 : 0.0)
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                
                Text("years old")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .opacity(animateContent ? 0.8 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            }
            
            // Simple slider
            VStack(spacing: 20) {
                Slider(value: $age, in: minAge...maxAge, step: 1)
                    .tint(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
                    .onChange(of: age) { _ in
                        checkForChanges()
                    }
                
                HStack {
                    Text("\(Int(minAge))")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                    
                    Spacer()
                    
                    Text("\(Int(maxAge))")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                }
                .opacity(animateContent ? 0.6 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            if hasChanges {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    saveChanges()
                }) {
                    Text("save")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .tracking(-0.3)
                }
                .opacity(hasChanges ? 1.0 : 0.0)
                .offset(y: hasChanges ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: hasChanges)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func checkForChanges() {
        hasChanges = age != originalAge
    }
    
    private func saveChanges() {
        originalAge = age
        hasChanges = false
        // Save to persistent storage here
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    AgePreferenceView()
        .environmentObject(ProfileViewModel(onLogout: {}))
}
