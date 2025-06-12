//
//
//  NamePreferenceView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//

import SwiftUI

struct NamePreferenceView: View {
    @State private var firstName: String = "Alex"
    @State private var lastName: String = "Johnson"
    @State private var animateContent = false
    @State private var hasChanges = false
    @State private var originalFirstName: String = "Alex"
    @State private var originalLastName: String = "Johnson"
    @FocusState private var isFirstNameFocused: Bool
    @FocusState private var isLastNameFocused: Bool

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
        .onChange(of: firstName) {
            checkForChanges()
        }
        .onChange(of: lastName) {
            checkForChanges()
        }
        .onTapGesture {
            hideKeyboard()
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

            VStack(alignment: .leading, spacing: 12) {
                Text("Name")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)

                Text("update your first and last name")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }

    private var currentNameSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Name")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
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
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
                )
        )
    }

    private var nameInputSection: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Update Name")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .padding(.horizontal, 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
            }

            VStack(spacing: 32) {
                nameField(label: "First Name", text: $firstName, isFocused: $isFirstNameFocused, delay: 1.2)
                nameField(label: "Last Name", text: $lastName, isFocused: $isLastNameFocused, delay: 1.4)
            }
        }
    }

    private func nameField(label: String, text: Binding<String>, isFocused: FocusState<Bool>.Binding, delay: Double) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(delay), value: animateContent)

            TextField("", text: text)
                .font(.system(size: 24, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .multilineTextAlignment(.center)
                .focused(isFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.98, green: 0.98, blue: 0.99)))
                .overlay(fieldBorder(isFocused: isFocused.wrappedValue))
                .onTapGesture {
                    isFirstNameFocused = label == "First Name"
                    isLastNameFocused = label == "Last Name"
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(delay + 0.1), value: animateContent)
                .padding(.horizontal, 30)
        }
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

    private func checkForChanges() {
        hasChanges = (firstName != originalFirstName || lastName != originalLastName) &&
            !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func saveChanges() {
        originalFirstName = firstName
        originalLastName = lastName
        hasChanges = false
        // Save to Firestore or local store
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
