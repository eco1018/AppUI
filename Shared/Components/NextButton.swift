
//
//
//  NextButton.swift
//  AppUI
//
//  Reusable button component for navigation actions
//  Provides consistent styling and UX feedback across the app
//

import SwiftUI

struct NextButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
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
                .foregroundColor(isPressed ? .white : Color(red: 0.2, green: 0.2, blue: 0.25))
                .tracking(-0.3)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(buttonBackground)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    // MARK: - Button Background Styling
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(isPressed ? Color.black : Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isPressed ? Color.black : Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        NextButton(title: "continue") {
            print("Continue tapped")
        }
        
        NextButton(title: "next") {
            print("Next tapped")
        }
        
        NextButton(title: "finish") {
            print("Finish tapped")
        }
        
        NextButton(title: "save") {
            print("Save tapped")
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
