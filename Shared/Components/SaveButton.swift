
//
//  SaveButton.swift
//  AppUI
//
//  Reusable save button component for preference views
//  Provides consistent styling and haptic feedback for save actions
//

import SwiftUI

struct SaveButton: View {
    let title: String
    let action: () -> Void
    
    init(title: String = "save", action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            // Haptic feedback for better UX
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Execute the passed action
            action()
        }) {
            Text(title)
                .font(.system(size: 24, weight: .light))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                .tracking(-0.3)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        SaveButton(title: "save") {
            print("Save tapped")
        }
        
        SaveButton(title: "save changes") {
            print("Save changes tapped")
        }
        
        SaveButton() {  // Uses default "save" title
            print("Default save tapped")
        }
    }
    .padding()
    .background(
        LinearGradient(
            colors: [
                Color(red: 0.99, green: 0.99, blue: 1.0),
                Color(red: 0.97, green: 0.97, blue: 0.99),
                Color(red: 0.95, green: 0.95, blue: 0.98)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
