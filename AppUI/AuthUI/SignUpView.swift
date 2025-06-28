//
//
//
//  SignUpView.swift
//  AppUI
//
//  Updated with Firebase Authentication
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Binding var currentAuthView: AuthView
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatch: Bool = false
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    @State private var isConfirmPasswordFocused: Bool = false
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
                    .frame(width: 400, height: 400)
                    .offset(x: 150, y: -200)
                    .blur(radius: 50)

                Circle()
                    .fill(Color.blue.opacity(0.02))
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: 250)
                    .blur(radius: 40)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 80)

                        VStack(spacing: 32) {
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)

                                Image(systemName: "person.crop.circle")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 12) {
                                Text("Create Account")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundColor(.black)

                                Text("Join our community")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 60)

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

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))

                                SecureField("Create a secure password", text: $password)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 16)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(isPasswordFocused ? .black : .gray.opacity(0.3)),
                                        alignment: .bottom
                                    )
                                    .onTapGesture {
                                        withAnimation { isPasswordFocused = true }
                                    }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Confirm Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))

                                SecureField("Confirm your password", text: $confirmPassword)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 16)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(showPasswordMismatch ? .red : (isConfirmPasswordFocused ? .black : .gray.opacity(0.3))),
                                        alignment: .bottom
                                    )
                                    .onTapGesture {
                                        withAnimation { isConfirmPasswordFocused = true }
                                    }
                            }

                            if showPasswordMismatch {
                                Text("Passwords do not match")
                                    .font(.system(size: 13))
                                    .foregroundColor(.red)
                                    .padding(.top, -12)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)

                        VStack(spacing: 24) {
                            Button(action: {
                                handleSignUp()
                            }) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .foregroundColor(.white)
                                    } else {
                                        Text("Create Account")
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
                            .disabled(isLoading || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)

                            Button(action: {
                                currentAuthView = .signIn
                            }) {
                                HStack(spacing: 6) {
                                    Text("Already have an account?")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)

                                    Text("Sign In")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 60)

                        Spacer(minLength: 40)
                    }
                }
            }
        }
        .alert("Registration Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func handleSignUp() {
        // Reset error states
        showPasswordMismatch = false
        showError = false
        
        // Validate passwords match
        guard password == confirmPassword else {
            showPasswordMismatch = true
            return
        }
        
        // Validate form completion
        guard !email.isEmpty && !password.isEmpty else {
            return
        }
        
        // Validate password length (Firebase requirement)
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long"
            showError = true
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                } else if let user = result?.user {
                    // Account created successfully
                    appCoordinator.handleSuccessfulLogin(userId: user.uid)
                }
            }
        }
    }
}

#Preview {
    SignUpView(currentAuthView: .constant(.signUp))
        .environmentObject(AppCoordinator())
}
