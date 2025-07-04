//
//  HomeView.swift
//  AppUI
//
//
//  HomeView.swift
//  AppUI
//
//  Minimalist main dashboard
//

import SwiftUI

struct HomeView: View {
    @State private var userName: String = "Ella" // This would come from user data
    @State private var animateContent = false
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
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
                Spacer()
                Spacer()
                Spacer() // More spacers to push content lower
                mainContent
                Spacer()
              
                ZStack {
                    settingsButton
                }
            }
        }
        .onAppear {
            performAppearAnimations()
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 30) {
            // Time and greeting
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(timeFormatter.string(from: currentTime))
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                    
                    Spacer()
                }
                
                Text("hello, \(userName.lowercased())")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        .padding(.top, 60)
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: 60) {
            // Coach
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                // Navigate to DBT Coach
            }) {
                Text("coach")
                    .font(.system(size: 32, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-0.5)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
            
            // Card
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                // Navigate to Diary Card
            }) {
                Text("card")
                    .font(.system(size: 32, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-0.5)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
        }
        .padding(.horizontal, 30)
    }
    
    // MARK: - Settings Button (Bottom Left)
    private var settingsButton: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    // Navigate to Settings
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .frame(width: 44, height: 44)
                }
                .opacity(animateContent ? 0.8 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
    
    // MARK: - Bottom Spacing
    private var bottomSpacing: some View {
        VStack {
            // Removed "aura" text
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - Helper Properties
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Navigation Button Component
struct NavigationButton: View {
    let title: String
    let subtitle: String
    let delay: Double
    let action: () -> Void
    
    @State private var animateContent = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.65))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                    .shadow(color: Color.black.opacity(0.02), radius: 1, x: 0, y: 1)
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 30)
        .animation(.easeOut(duration: 0.8).delay(delay), value: animateContent)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
