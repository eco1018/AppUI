
//
//
//  AuthCoordinator.swift
//  AppUI
//
//  Authentication flow coordinator
//

import SwiftUI

// MARK: - Auth Step Enum
enum AuthStep {
    case signIn
    case signUp
    case forgotPassword
}

// MARK: - Auth Coordinator View Model
@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentStep: AuthStep = .signIn
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Sign In Fields
    @Published var signInEmail = ""
    @Published var signInPassword = ""
    
    // Sign Up Fields
    @Published var signUpEmail = ""
    @Published var signUpPassword = ""
    @Published var signUpConfirmPassword = ""
    
    // Navigation
    var onAuthenticationComplete: (() -> Void)?
    
    init(onAuthenticationComplete: @escaping () -> Void) {
        self.onAuthenticationComplete = onAuthenticationComplete
    }
    
    // MARK: - Navigation Methods
    func showSignUp() {
        currentStep = .signUp
        clearError()
    }
    
    func showSignIn() {
        currentStep = .signIn
        clearError()
    }
    
    func showForgotPassword() {
        currentStep = .forgotPassword
        clearError()
    }
    
    // MARK: - Authentication Methods (Placeholder for now)
    func signIn() {
        guard !signInEmail.isEmpty, !signInPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        clearError()
        
        // Simulate authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // For now, always succeed
            self.onAuthenticationComplete?()
        }
    }
    
    func signUp() {
        guard !signUpEmail.isEmpty, !signUpPassword.isEmpty, !signUpConfirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard signUpPassword == signUpConfirmPassword else {
            errorMessage = "Passwords don't match"
            return
        }
        
        guard signUpPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        clearError()
        
        // Simulate account creation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // For now, always succeed
            self.onAuthenticationComplete?()
        }
    }
    
    func resetPassword() {
        guard !signInEmail.isEmpty else {
            errorMessage = "Please enter your email address"
            return
        }
        
        isLoading = true
        clearError()
        
        // Simulate password reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.currentStep = .signIn
            // Show success message or handle accordingly
        }
    }
    
    private func clearError() {
        errorMessage = nil
    }
}

// MARK: - Auth Coordinator View
struct AuthCoordinator: View {
    @StateObject private var authViewModel: AuthViewModel
    
    init(onAuthenticationComplete: @escaping () -> Void) {
        self._authViewModel = StateObject(wrappedValue: AuthViewModel(onAuthenticationComplete: onAuthenticationComplete))
    }
    
    var body: some View {
        ZStack {
            // Background matching your app style
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
            
            // Content based on current step
            switch authViewModel.currentStep {
            case .signIn:
                SignInView()
                    .environmentObject(authViewModel)
            case .signUp:
                SignUpView()
                    .environmentObject(authViewModel)
            case .forgotPassword:
                ForgotPasswordView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

// MARK: - Sign In View
struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var animateContent = false
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            signInForm
            Spacer()
            bottomSection
        }
        .onAppear {
            performAppearAnimations()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 40) {
            Text("Welcome")
                .font(.system(size: 42, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .tracking(-1)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
            
            Text("Sign in to continue")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.top, 80)
    }
    
    private var signInForm: some View {
        VStack(spacing: 32) {
            // Email Field
            VStack(spacing: 8) {
                TextField("Email", text: $authViewModel.signInEmail)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .focused($isEmailFocused)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(fieldBackground)
                    .overlay(fieldBorder(isFocused: isEmailFocused))
                    .onTapGesture {
                        isEmailFocused = true
                        isPasswordFocused = false
                    }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.6), value: animateContent)
            
            // Password Field
            VStack(spacing: 8) {
                SecureField("Password", text: $authViewModel.signInPassword)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .textContentType(.password)
                    .focused($isPasswordFocused)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(fieldBackground)
                    .overlay(fieldBorder(isFocused: isPasswordFocused))
                    .onTapGesture {
                        isPasswordFocused = true
                        isEmailFocused = false
                    }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
            
            // Error Message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.red)
                    .opacity(0.8)
            }
            
            // Sign In Button
            Button(action: {
                hideKeyboard()
                authViewModel.signIn()
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Text("Sign In")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                )
            }
            .disabled(authViewModel.isLoading)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(1.0), value: animateContent)
        }
        .padding(.horizontal, 30)
    }
    
    private var bottomSection: some View {
        VStack(spacing: 20) {
            // Forgot Password
            Button(action: {
                authViewModel.showForgotPassword()
            }) {
                Text("Forgot Password?")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(1.2), value: animateContent)
            
            // Sign Up Link
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                
                Button(action: {
                    authViewModel.showSignUp()
                }) {
                    Text("Sign Up")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(1.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
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
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isEmailFocused = false
        isPasswordFocused = false
    }
}

// MARK: - Sign Up View
struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var animateContent = false
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            signUpForm
            Spacer()
            bottomSection
        }
        .onAppear {
            performAppearAnimations()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 40) {
            Text("Create Account")
                .font(.system(size: 42, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .tracking(-1)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
            
            Text("Join us on your wellness journey")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.top, 80)
    }
    
    private var signUpForm: some View {
        VStack(spacing: 32) {
            // Email Field
            TextField("Email", text: $authViewModel.signUpEmail)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .focused($isEmailFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(fieldBackground)
                .overlay(fieldBorder(isFocused: isEmailFocused))
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: animateContent)
            
            // Password Field
            SecureField("Password", text: $authViewModel.signUpPassword)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .textContentType(.newPassword)
                .focused($isPasswordFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(fieldBackground)
                .overlay(fieldBorder(isFocused: isPasswordFocused))
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
            
            // Confirm Password Field
            SecureField("Confirm Password", text: $authViewModel.signUpConfirmPassword)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .textContentType(.newPassword)
                .focused($isConfirmPasswordFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(fieldBackground)
                .overlay(fieldBorder(isFocused: isConfirmPasswordFocused))
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(1.0), value: animateContent)
            
            // Error Message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.red)
                    .opacity(0.8)
            }
            
            // Sign Up Button
            Button(action: {
                hideKeyboard()
                authViewModel.signUp()
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Text("Create Account")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                )
            }
            .disabled(authViewModel.isLoading)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(1.2), value: animateContent)
        }
        .padding(.horizontal, 30)
    }
    
    private var bottomSection: some View {
        VStack(spacing: 20) {
            // Sign In Link
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                
                Button(action: {
                    authViewModel.showSignIn()
                }) {
                    Text("Sign In")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(1.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
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
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isEmailFocused = false
        isPasswordFocused = false
        isConfirmPasswordFocused = false
    }
}

// MARK: - Forgot Password View
struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var animateContent = false
    @FocusState private var isEmailFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            resetForm
            Spacer()
            bottomSection
        }
        .onAppear {
            performAppearAnimations()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 40) {
            Text("Reset Password")
                .font(.system(size: 42, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .tracking(-1)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
            
            Text("Enter your email to receive reset instructions")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                .multilineTextAlignment(.center)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.top, 80)
    }
    
    private var resetForm: some View {
        VStack(spacing: 32) {
            // Email Field
            TextField("Email", text: $authViewModel.signInEmail)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .focused($isEmailFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(fieldBackground)
                .overlay(fieldBorder(isFocused: isEmailFocused))
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: animateContent)
            
            // Error Message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.red)
                    .opacity(0.8)
            }
            
            // Reset Button
            Button(action: {
                hideKeyboard()
                authViewModel.resetPassword()
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Text("Send Reset Link")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                )
            }
            .disabled(authViewModel.isLoading)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
        }
        .padding(.horizontal, 30)
    }
    
    private var bottomSection: some View {
        VStack(spacing: 20) {
            // Back to Sign In
            Button(action: {
                authViewModel.showSignIn()
            }) {
                Text("Back to Sign In")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(1.0), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
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
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isEmailFocused = false
    }
}
