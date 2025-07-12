
//
//  BackButton.swift
//  AppUI
//
//  Reusable back navigation button component
//  Provides consistent styling across all views
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        HStack {
            BackButton {
                print("Back tapped")
            }
            Spacer()
        }
        
        HStack {
            BackButton {
                print("Navigate back")
            }
            Spacer()
            Text("Sample View Header")
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
