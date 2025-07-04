//
//  NamePreferenceView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//


//
//  NamePreferenceView.swift
//  AppUI
//
//  Name preference management interface
//

import SwiftUI

struct NamePreferenceView: View {
    @State private var firstName: String = "Alex" // Pre-filled for demo
    @State private var lastName: String = "Johnson" // Pre-filled for demo
    @State private var animateContent = false
    @State private var hasChanges = false
    @State private var originalFirstName: String = "Alex" // Track original state
    @State private var originalLastName: String = "Johnson" // Track original state
    @FocusState private var isFirstNameFocused: Bool
    @FocusState private var isLastNameFocused: Bool
    
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
                currentNameSection
                Spacer()
                nameInputSection
                Spacer()
                bottomSection
            }
        }
        .onAppear {
            performAppearAnimations()
        }
        .onChange(of: firstName) { _ in
            checkForChanges()
        }
        .onChange(of: lastName) { _ in
            checkForChanges()
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
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Name")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("update your first and last name")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Current Name Section
    private var currentNameSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Name")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            
            currentNameItemView()
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 40)
    }
    
    private func currentNameItemView() -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Full Name")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Text("Your current name on file")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
            }
            
            Spacer()
            
            Text("\(originalFirstName) \(originalLastName)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(currentNameBackground)
    }
    
    private var currentNameBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
            )
    }
    
    // MARK: - Name Input Section
    private var nameInputSection: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Update Name")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
            }
            
            // Name input fields
            VStack(spacing: 32) {
                // First Name
                VStack(spacing: 8) {
                    Text("First Name")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(1.2), value: animateContent)
                    
                    TextField("", text: $firstName)
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .multilineTextAlignment(.center)
                        .focused($isFirstNameFocused)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(fieldBackground)
                        .overlay(fieldBorder(isFocused: isFirstNameFocused))
                        .onTapGesture {
                            isFirstNameFocused = true
                            isLastNameFocused = false
                        }
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(1.3), value: animateContent)
                        .padding(.horizontal, 30)
                }
                
                // Last Name
                VStack(spacing: 8) {
                    Text("Last Name")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(1.4), value: animateContent)
                    
                    TextField("", text: $lastName)
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .multilineTextAlignment(.center)
                        .focused($isLastNameFocused)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(fieldBackground)
                        .overlay(fieldBorder(isFocused: isLastNameFocused))
                        .onTapGesture {
                            isLastNameFocused = true
                            isFirstNameFocused = false
                        }
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(1.5), value: animateContent)
                        .padding(.horizontal, 30)
                }
            }
        }
    }
    
    // MARK: - Helper Views
    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
    }
    
    private func fieldBorder(isFocused: Bool) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                isFocused 
                    ? Color(red: 0.15, green: 0.15, blue: 0.2)
                    : Color(red: 0.9, green: 0.9, blue: 0.92),
                lineWidth: isFocused ? 1.5 : 1
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            if hasChanges && !firstName.trimmingCharacters(in: .whitespaces).isEmpty && !lastName.trimmingCharacters(in: .whitespaces).isEmpty {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    hideKeyboard()
                    saveChanges()
                }) {
                    Text("save changes")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .tracking(-0.3)
                }
                .opacity(hasChanges ? 1.0 : 0.0)
                .offset(y: hasChanges ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: hasChanges)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func checkForChanges() {
        hasChanges = (firstName != originalFirstName || lastName != originalLastName) &&
                    !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
                    !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func saveChanges() {
        originalFirstName = firstName
        originalLastName = lastName
        hasChanges = false
        // Save to persistent storage here
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isFirstNameFocused = false
        isLastNameFocused = false
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    NamePreferenceView()
}