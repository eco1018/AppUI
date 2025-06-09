//
//  DiaryNote.swift
//  AppUI
//
//
//  DiaryNote.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//


//
//  DiaryNote.swift
//  AppUI
//
//  Minimalist diary note interface
//

import SwiftUI

struct DiaryNote: View {
    @State private var animateContent = false
    @State private var noteText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
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
                
                // Note input content
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        // Clean text input area
                        ZStack(alignment: .topLeading) {
                            if noteText.isEmpty {
                                Text("Reflect on your day, emotions, or any insights you'd like to capture...")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.65))
                                    .padding(.top, 16)
                                    .padding(.leading, 16)
                            }
                            
                            TextEditor(text: $noteText)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                                .focused($isTextFieldFocused)
                                .scrollContentBackground(.hidden)
                                .padding(16)
                                .frame(minHeight: 200)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                                .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isTextFieldFocused ? Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.2) : Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.06), lineWidth: isTextFieldFocused ? 1 : 0.5)
                        )
                    }
                    .padding(.horizontal, 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
                }
                .padding(.vertical, 40)
                
                Spacer()
                nextSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
        .onTapGesture {
            if !isTextFieldFocused {
                hideKeyboard()
            }
        }
    }
    
    // MARK: - Header Section
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
            
            // Title
            HStack {
                Text("note")
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
    
    // MARK: - Next Section
    private var nextSection: some View {
        VStack {
            // Next button - centered
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
    
    // MARK: - Helper Methods
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
    
    private func hideKeyboard() {
        isTextFieldFocused = false
    }
}

#Preview {
    DiaryNote()
}
