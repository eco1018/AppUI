//
//  SubmitButton.swift
//  AppUI
//
//  Reusable submit button component for completion/action flows
//  Features loading states, icons, and consistent capsule styling
//

import SwiftUI

struct SubmitButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            // Haptic feedback for better UX
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Execute the passed action
            action()
        }) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(Color(red: 0.2, green: 0.2, blue: 0.25))
                } else {
                    Text(title)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(buttonBackground)
        }
        .disabled(isLoading)
    }
    
    // MARK: - Button Background Styling
    private var buttonBackground: some View {
        Capsule()
            .fill(Color(red: 0.96, green: 0.96, blue: 0.97))
            .overlay(
                Capsule()
                    .stroke(Color(red: 0.82, green: 0.82, blue: 0.85), lineWidth: 1.2)
            )
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        SubmitButton(title: "begin", isLoading: false) {
            print("Begin tapped")
        }
        
        SubmitButton(title: "finish", isLoading: false) {
            print("Finish tapped")
        }
        
        SubmitButton(title: "submit", isLoading: true) {
            print("Loading...")
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