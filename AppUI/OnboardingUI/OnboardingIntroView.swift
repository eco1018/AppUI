//

//
//  OnboardingIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct OnboardingIntroView: View {
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            // Clean background matching inspiration aesthetic
            Color(.systemGray6)
                .opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 60) {
                Spacer()
                
                // Enhanced elegant header with visual focus element
                VStack(spacing: 32) {
                    VStack(spacing: 24) {
                        Text("Welcome to Aura")
                            .font(.system(size: 28, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
                        
                        Text("A mindful approach to understanding yourself and building the skills that matter most.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                    }
                    
                    // Central START button - interactive
                    Button(action: {
                        // Navigation action goes here
                    }) {
                        ZStack {
                            // Outer subtle ring
                            Circle()
                                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                .frame(width: 160, height: 160)
                            
                            // Inner circle with START text
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 120, height: 120)
                                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
                                .overlay(
                                    Text("START")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.8))
                                        .tracking(1)
                                )
                        }
                    }
                    .scaleEffect(isVisible ? 1.0 : 0.8)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isVisible)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
        }
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    OnboardingIntroView()
}
