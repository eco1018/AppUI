//
//  DiaryMainView.swift
//  AppUI
//
//  Main diary card dashboard view
//

import SwiftUI

struct DiaryMainView: View {
    @State private var animateContent = false
    
    let onStartDiary: () -> Void
    
    var body: some View {
        ZStack {
            // Enhanced background with organic gradient
            LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.99, blue: 1.0),
                    Color(red: 0.98, green: 0.98, blue: 0.995),
                    Color(red: 0.97, green: 0.97, blue: 0.99),
                    Color(red: 0.95, green: 0.95, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle ambient elements
            ambientElements
            
            VStack(spacing: 0) {
                headerSection
                Spacer()
                startButton
                    .padding(.bottom, 50)
            }
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
    // MARK: - Ambient Visual Elements
    private var ambientElements: some View {
        ZStack {
            // Soft floating orbs
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.05),
                            Color.blue.opacity(0.02),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .offset(x: -120, y: -300)
                .opacity(animateContent ? 0.6 : 0.0)
                .animation(.easeOut(duration: 1.5).delay(0.8), value: animateContent)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.04),
                            Color.purple.opacity(0.01),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .offset(x: 140, y: -200)
                .opacity(animateContent ? 0.5 : 0.0)
                .animation(.easeOut(duration: 1.2).delay(1.0), value: animateContent)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.cyan.opacity(0.03),
                            Color.cyan.opacity(0.01),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .offset(x: 100, y: 400)
                .opacity(animateContent ? 0.4 : 0.0)
                .animation(.easeOut(duration: 1.0).delay(1.2), value: animateContent)
        }
    }
    
    // MARK: - Enhanced Header Section
    private var headerSection: some View {
        VStack(spacing: 24) {
            // Main title with enhanced typography
            Text("Daily Diary Card")
                .font(.system(size: 44, weight: .ultraLight))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.12, blue: 0.18),
                            Color(red: 0.18, green: 0.18, blue: 0.22)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .tracking(-1.5)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateContent)
            
            // Enhanced subtitle
            Text("Track your emotions, goals, and progress")
                .font(.system(size: 17, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.35, green: 0.35, blue: 0.4),
                            Color(red: 0.45, green: 0.45, blue: 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.4), value: animateContent)
        }
        .padding(.top, 80)
        .padding(.horizontal, 40)
    }
    
    // MARK: - Enhanced Start Button
    private var startButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            onStartDiary()
        }) {
            HStack(spacing: 12) {
                Text("Start Today's Entry")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(startButtonBackground)
        }
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateContent)
        .padding(.horizontal, 32)
    }
    
    // MARK: - Enhanced Button Background Styling
    private var startButtonBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
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
            
            RoundedRectangle(cornerRadius: 16)
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
    
    // MARK: - Helper Methods
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Preview
#Preview {
    DiaryMainView {
        print("Start diary tapped")
    }
}
