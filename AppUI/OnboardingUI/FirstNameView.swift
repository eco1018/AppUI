
//
//  FirstNameView.swift
//  AppUI
//
//  Simple first name input with clean design
//

import SwiftUI

struct FirstNameView: View {
    @State private var firstName: String = ""
    @State private var animateContent = false
    @State private var showContinueButton = false
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
                Spacer()
                nameInputContent
                Spacer()
                bottomSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
        .onChange(of: firstName) { _ in
            updateContinueButton()
        }
        .onTapGesture {
            hideKeyboard()
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
        }
    }
    
    // MARK: - Name Input Content (Centered)
    private var nameInputContent: some View {
        VStack(spacing: 60) {
            // Question text
            Text("What's your first name?")
                .font(.system(size: 42, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .tracking(-1)
                .multilineTextAlignment(.center)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
            
            // Clean text input
            TextField("", text: $firstName)
                .font(.system(size: 24, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .multilineTextAlignment(.center)
                .focused($isTextFieldFocused)
                .padding(.horizontal, 60)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            if showContinueButton {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    hideKeyboard()
                    // Handle continue action
                }) {
                    Text("next")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .tracking(-0.3)
                }
                .opacity(showContinueButton ? 1.0 : 0.0)
                .offset(y: showContinueButton ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: showContinueButton)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func updateContinueButton() {
        let trimmedName = firstName.trimmingCharacters(in: .whitespaces)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showContinueButton = !trimmedName.isEmpty
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
        
        // Auto-focus the text field after animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isTextFieldFocused = true
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isTextFieldFocused = false
    }
}

#Preview {
    FirstNameView()
}
