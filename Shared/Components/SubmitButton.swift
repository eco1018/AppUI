//
//  SubmitButton.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 7/12/25.
//
//  Reusable submit button component for completion/action flows
//  Features loading states, icons, and consistent styling
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
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.9)
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(buttonBackground)
        }
        .disabled(isLoading)
    }
    
    // MARK: - Enhanced Button Background Styling
    private var buttonBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.12, blue: 0.18),
                            Color(red: 0.18, green: 0.18, blue: 0.24),
                            Color(red: 0.15, green: 0.15, blue: 0.21)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.05),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
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
