//
//
//  UrgesPreferenceView.swift
//  AppUI
//
//  Urges preference management interface - Updated with ProfileViewModel navigation
//

import SwiftUI

struct UrgesPreferenceView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel  // Added
    @State private var selectedUrges: Set<Int> = [0, 3] // Pre-selected urges for demo
    @State private var animateContent = false
    @State private var hasChanges = false
    @State private var originalUrges: Set<Int> = [0, 3] // Track original state
    
    let urgeTitles = [
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
                currentUrgesSection
                Spacer()
                availableUrgesSection
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
                BackButton {
                    profileViewModel.goBack()
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
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Current Urges Section
    private var currentUrgesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Current")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(selectedUrges.sorted()), id: \.self) { urgeIndex in
                    Button(action: {
                        toggleUrge(index: urgeIndex)
                    }) {
                        HStack {
                            Text(urgeTitles[urgeIndex])
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                            
                            Spacer()
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        }
                        .padding(.horizontal, 30)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - Available Urges Section
    private var availableUrgesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("All Urges")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<urgeTitles.count, id: \.self) { index in
                    if !selectedUrges.contains(index) {
                        Button(action: {
                            toggleUrge(index: index)
                        }) {
                            HStack {
                                Text(urgeTitles[index])
                                    .font(.system(size: 20, weight: .ultraLight))
                                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                                
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(1.2), value: animateContent)
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            if hasChanges {
                SaveButton {
                    saveChanges()
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
    private func toggleUrge(index: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if selectedUrges.contains(index) {
                selectedUrges.remove(index)
            } else if selectedUrges.count < 2 {
                selectedUrges.insert(index)
            }
            checkForChanges()
        }
    }
    
    private func checkForChanges() {
        hasChanges = selectedUrges != originalUrges
    }
    
    private func saveChanges() {
        originalUrges = selectedUrges
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
    UrgesPreferenceView()
        .environmentObject(ProfileViewModel(onLogout: {}))
}
