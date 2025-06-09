//
//  DiaryGoals.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//

//
//  DiaryGoals.swift
//  AppUI
//
//  Minimalist diary goals interface
//

import SwiftUI

struct DiaryGoals: View {
    @State private var animateContent = false
    @State private var userGoal1: Bool? = nil
    @State private var userGoal2: Bool? = nil
    @State private var userGoal3: Bool? = nil
    
    let userGoals = ["User Goal 1", "User Goal 2", "User Goal 3"]
    
    var body: some View {
        ZStack {
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
                
                VStack(spacing: 20) {
                    GoalYesNoRow(
                        goalName: userGoals[0],
                        selectedValue: $userGoal1,
                        animationDelay: 0.6
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
                    
                    GoalYesNoRow(
                        goalName: userGoals[1],
                        selectedValue: $userGoal2,
                        animationDelay: 0.7
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.7), value: animateContent)
                    
                    GoalYesNoRow(
                        goalName: userGoals[2],
                        selectedValue: $userGoal3,
                        animationDelay: 0.8
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 50)
                
                Spacer()
                nextSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
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
            
            HStack {
                Text("Goals")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 60)
        }
    }
    
    private var nextSection: some View {
        VStack {
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                // Handle next action
            }) {
                Text("next")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                    .tracking(-0.3)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

struct GoalYesNoRow: View {
    let goalName: String
    @Binding var selectedValue: Bool?
    let animationDelay: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Text(goalName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    selectedValue = true
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    Text("yes")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedValue == true ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.2))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedValue == true ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color.white)
                                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.1), lineWidth: 0.5)
                        )
                }
                
                Button(action: {
                    selectedValue = false
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    Text("no")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedValue == false ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.2))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedValue == false ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color.white)
                                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.1), lineWidth: 0.5)
                        )
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.06), lineWidth: 0.5)
        )
    }
}

#Preview {
    DiaryGoals()
}
