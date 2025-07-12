
//
//  MenuButton.swift
//  AppUI
//
//  Reusable menu button component
//  Provides consistent styling for hamburger menu navigation
//

import SwiftUI

struct MenuButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                .frame(width: 44, height: 44)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        HStack {
            MenuButton {
                print("Menu tapped")
            }
            Spacer()
        }
        
        HStack {
            MenuButton {
                print("Open menu")
            }
            Spacer()
            Text("Profile View")
                .font(.title2)
            Spacer()
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
