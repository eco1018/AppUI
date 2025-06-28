//
//
//
//
//  ForgotPasswordView.swift
//  AppUI
//
//  Updated with Firebase Authentication
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @Binding var currentAuthView: AuthView
    @State private var email: String = ""
    @State private var isEmailFocused: Bool = false
    @State private var showSuccessMessage: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()

                Circle()
                    .fill(Color.gray.opacity(0.03))
                    .frame(width: 320, height: 320)
                    .offset(x: 100, y: -150)
                    .blur(radius: 40)

                Circle()
                    .fill(Color.orange.opacity(0.02))
                    .frame(width: 250, height: 250)
                    .offset(x: -90, y: 200)
                    .blur(radius: 30)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 120)

                        VStack(spacing: 32) {
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)

                                Image(systemName: "lock.rotation")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 16) {
                                Text("Reset Password")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundColor(.black)

                                Text("We'll send you a link to reset your password")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.bottom, 60)

                        if !showSuccessMessage {
                            VStack(spacing: 32) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Email")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.black.opacity(0.7))

                                    TextField("Enter your email address", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 16)
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(isEmailFocused ? .black : .gray.opacity(0.3)),
                                            alignment: .bottom
                                        )
                                        .onTapGesture {
                                            withAnimation { isEmailFocused = true }
                                        }
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 50)

                            VStack(spacing: 24) {
                                Button(action: {
                                    handleResetPassword()
                                }) {
                                    HStack {
                                        if isLoading {
                                            ProgressView()
                                                .scaleEffect(0.8)
                                                .foregroundColor(.white)
                                        } else {
                                            Text("Send Reset Link")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                                }
                                .disabled(isLoading || email.isEmpty)

                                Button(action: {
                                    currentAuthView = .signIn
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.left")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.black)

                                        Text("Return to Sign In")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 80)
                        } else {
                            VStack(spacing: 32) {
                                VStack(spacing: 16) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 48, weight: .regular))
                                        .foregroundColor(.green)
                                    
                                    Text("Reset Link Sent!")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text("Check your email for instructions to reset your password.")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Button(action: {
                                    currentAuthView = .signIn
                                }) {
                                    Text("Back to Sign In")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(Color.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 26))
                                        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 80)
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
        }
        .alert("Password Reset Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func handleResetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address"
            showError = true
            return
        }
        
        isLoading = true
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                } else {
                    // Success - show success message
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSuccessMessage = true
                    }
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView(currentAuthView: .constant(.forgotPassword))
}
