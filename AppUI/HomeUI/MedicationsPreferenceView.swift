//
//  MedicationsPreferenceView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//


//
//  MedicationsPreferenceView.swift
//  AppUI
//
//  Medications preference management interface
//

import SwiftUI

struct MedicationsPreferenceView: View {
    @State private var selectedOption: String = "Yes" // Pre-selected for demo
    @State private var animateContent = false
    @State private var hasChanges = false
    @State private var originalOption: String = "Yes" // Track original state
    
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
                currentStatusSection
                Spacer()
                optionsSection
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
                    // Navigate back
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
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 12) {
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
                
                HStack {
                    Text("update your medication status")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Current Status Section
    private var currentStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Status")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            
            currentStatusItemView()
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 40)
    }
    
    private func currentStatusItemView() -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Taking medications")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Text(selectedOption == "Yes" ? "You indicated that you take medications" : "You indicated that you don't take medications")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
            }
            
            Spacer()
            
            Text(selectedOption)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(selectedOption == "Yes" ? Color(red: 0.2, green: 0.6, blue: 0.3) : Color(red: 0.6, green: 0.4, blue: 0.2))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedOption == "Yes" ? Color(red: 0.9, green: 0.98, blue: 0.9) : Color(red: 0.98, green: 0.95, blue: 0.9))
                )
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(currentStatusBackground)
    }
    
    private var currentStatusBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
            )
    }
    
    // MARK: - Options Section
    private var optionsSection: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Update Status")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
                
                Text("Do you take medications?")
                    .font(.system(size: 28, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(1.2), value: animateContent)
                    .padding(.horizontal, 30)
            }
            
            // Clean text options
            VStack(spacing: 40) {
                // Yes option
                Button(action: {
                    selectOption("Yes")
                }) {
                    Text("yes")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(selectedOption == "Yes" ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.5, green: 0.5, blue: 0.55))
                        .scaleEffect(selectedOption == "Yes" ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: selectedOption)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(1.4), value: animateContent)
                
                // No option
                Button(action: {
                    selectOption("No")
                }) {
                    Text("no")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(selectedOption == "No" ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.5, green: 0.5, blue: 0.55))
                        .scaleEffect(selectedOption == "No" ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: selectedOption)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(1.6), value: animateContent)
            }
        }
        .padding(.horizontal, 40)
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
                    Text("save changes")
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
    private func selectOption(_ option: String) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedOption = option
            checkForChanges()
        }
    }
    
    private func checkForChanges() {
        hasChanges = selectedOption != originalOption
    }
    
    private func saveChanges() {
        originalOption = selectedOption
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
    MedicationsPreferenceView()
}