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
//  Minimalist medications preference management interface
//

import SwiftUI

struct MedicationsPreferenceView: View {
    @State private var selectedMedications: Set<Int> = [0] // Pre-selected medications for demo
    @State private var animateContent = false
    @State private var hasChanges = false
    @State private var originalMedications: Set<Int> = [0] // Track original state
    
    let medicationTitles = [
        "yes",
        "no"
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
                currentMedicationsSection
                Spacer()
                availableMedicationsSection
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
            
            // Title
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
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Current Medications Section
    private var currentMedicationsSection: some View {
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
                ForEach(Array(selectedMedications.sorted()), id: \.self) { medicationIndex in
                    Button(action: {
                        toggleMedication(index: medicationIndex)
                    }) {
                        HStack {
                            Text(medicationTitles[medicationIndex])
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
    
    // MARK: - Available Medications Section
    private var availableMedicationsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("All Options")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<medicationTitles.count, id: \.self) { index in
                    if !selectedMedications.contains(index) {
                        Button(action: {
                            toggleMedication(index: index)
                        }) {
                            HStack {
                                Text(medicationTitles[index])
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
    private func toggleMedication(index: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            // Clear all selections first (since only one can be selected)
            selectedMedications.removeAll()
            // Then add the new selection
            selectedMedications.insert(index)
            checkForChanges()
        }
    }
    
    private func checkForChanges() {
        hasChanges = selectedMedications != originalMedications
    }
    
    private func saveChanges() {
        originalMedications = selectedMedications
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
