//
//  DiaryUrgesView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//

//
//  DiaryUrgesView.swift
//  AppUI
//
//  Minimalist diary urges interface
//

import SwiftUI

struct DiaryUrgesView: View {
    @State private var animateContent = false
    @State private var selfHarmUrge: Double = 0
    @State private var suicideUrge: Double = 0
    @State private var quitTherapyUrge: Double = 0
    @State private var userUrge1: Double = 0
    @State private var userUrge2: Double = 0
    
    let fixedUrges = ["self-harm", "suicide", "quit therapy"]
    let userUrges = ["User Urge 1", "User Urge 2"]
    
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
                
                VStack(spacing: 16) {
                    UrgeSlider(
                        urgeName: "self-harm",
                        value: $selfHarmUrge,
                        animationDelay: 0.6
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
                    
                    UrgeSlider(
                        urgeName: "suicide",
                        value: $suicideUrge,
                        animationDelay: 0.7
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.7), value: animateContent)
                    
                    UrgeSlider(
                        urgeName: "quit therapy",
                        value: $quitTherapyUrge,
                        animationDelay: 0.8
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
                    
                    UrgeSlider(
                        urgeName: userUrges[0],
                        value: $userUrge1,
                        animationDelay: 0.9
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.9), value: animateContent)
                    
                    UrgeSlider(
                        urgeName: userUrges[1],
                        value: $userUrge2,
                        animationDelay: 1.0
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
                
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
                Text("urges")
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

struct UrgeSlider: View {
    let urgeName: String
    @Binding var value: Double
    let animationDelay: Double
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(urgeName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
                
                Text("\(Int(value))")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .frame(width: 18, alignment: .trailing)
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .frame(height: 5)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.8))
                    .frame(width: max(5, CGFloat(value / 10.0) * (UIScreen.main.bounds.width - 60)), height: 5)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 14, height: 14)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .offset(x: max(0, CGFloat(value / 10.0) * (UIScreen.main.bounds.width - 74)))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let newValue = Double(gesture.location.x / (UIScreen.main.bounds.width - 60)) * 10.0
                        value = max(0, min(10, newValue))
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
            )
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.06), lineWidth: 0.5)
        )
    }
}

#Preview {
    DiaryUrgesView()
}
