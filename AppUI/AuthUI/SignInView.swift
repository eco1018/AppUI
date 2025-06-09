////
//
////  SignInView.swift
////  aura
////
////  Created by Ella A. Sadduq on 3/30/25.
////
//
//import SwiftUI
//
//struct SignInView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var isVisible = false
//    @FocusState private var isEmailFocused: Bool
//    @FocusState private var isPasswordFocused: Bool
//    
//    var body: some View {
//        ZStack {
//            // Clean background matching inspiration aesthetic
//            Color(.systemGray6)
//                .opacity(0.3)
//                .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                // Header section
//                VStack(spacing: 32) {
//                    Spacer()
//                        .frame(height: 80)
//                    
//                    // Central focus element
//                    ZStack {
//                        Circle()
//                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
//                            .frame(width: 100, height: 100)
//                        
//                        Circle()
//                            .fill(Color.white.opacity(0.9))
//                            .frame(width: 70, height: 70)
//                            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
//                            .overlay(
//                                Image(systemName: "person.circle")
//                                    .font(.system(size: 24, weight: .ultraLight))
//                                    .foregroundColor(.primary.opacity(0.7))
//                            )
//                    }
//                    .scaleEffect(isVisible ? 1.0 : 0.8)
//                    .opacity(isVisible ? 1.0 : 0.0)
//                    .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
//                    
//                    VStack(spacing: 16) {
//                        Text("Welcome Back")
//                            .font(.system(size: 28, weight: .light, design: .default))
//                            .foregroundColor(.primary.opacity(0.9))
//                            .multilineTextAlignment(.center)
//                            .opacity(isVisible ? 1.0 : 0.0)
//                            .animation(.easeOut(duration: 0.5).delay(0.4), value: isVisible)
//                        
//                        Text("Sign in to continue your journey")
//                            .font(.system(size: 16, weight: .regular))
//                            .foregroundColor(.secondary.opacity(0.7))
//                            .multilineTextAlignment(.center)
//                            .opacity(isVisible ? 1.0 : 0.0)
//                            .animation(.easeOut(duration: 0.5).delay(0.6), value: isVisible)
//                    }
//                }
//                .padding(.horizontal, 32)
//                
//                // Input fields section
//                VStack(spacing: 24) {
//                    // Email field
//                    VStack(spacing: 8) {
//                        HStack {
//                            Text("Email")
//                                .font(.system(size: 14, weight: .medium))
//                                .foregroundColor(.secondary.opacity(0.8))
//                            Spacer()
//                        }
//                        
//                        TextField("your@email.com", text: $email)
//                            .font(.system(size: 16, weight: .regular))
//                            .foregroundColor(.primary.opacity(0.9))
//                            .focused($isEmailFocused)
//                            .textInputAutocapitalization(.never)
//                            .keyboardType(.emailAddress)
//                            .padding(16)
//                            .background(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(Color.white.opacity(0.9))
//                                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
//                            )
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(isEmailFocused ? Color.primary.opacity(0.2) : Color.primary.opacity(0.06), lineWidth: isEmailFocused ? 1 : 0.5)
//                            )
//                    }
//                    
//                    // Password field
//                    VStack(spacing: 8) {
//                        HStack {
//                            Text("Password")
//                                .font(.system(size: 14, weight: .medium))
//                                .foregroundColor(.secondary.opacity(0.8))
//                            Spacer()
//                        }
//                        
//                        SecureField("Password", text: $password)
//                            .font(.system(size: 16, weight: .regular))
//                            .foregroundColor(.primary.opacity(0.9))
//                            .focused($isPasswordFocused)
//                            .padding(16)
//                            .background(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(Color.white.opacity(0.9))
//                                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
//                            )
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(isPasswordFocused ? Color.primary.opacity(0.2) : Color.primary.opacity(0.06), lineWidth: isPasswordFocused ? 1 : 0.5)
//                            )
//                    }
//                }
//                .padding(.horizontal, 24)
//                .padding(.top, 50)
//                .opacity(isVisible ? 1.0 : 0.0)
//                .animation(.easeOut(duration: 0.5).delay(0.8), value: isVisible)
//                
//                Spacer()
//                
//                // Sign in button
//                VStack(spacing: 16) {
//                    Button(action: {
//                        // Sign in action goes here
//                    }) {
//                        HStack(spacing: 12) {
//                            Text("Sign In")
//                                .font(.system(size: 18, weight: .medium))
//                                .foregroundColor(.primary.opacity(0.9))
//                            
//                            Image(systemName: "arrow.right")
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(.primary.opacity(0.7))
//                        }
//                        .padding(20)
//                        .frame(maxWidth: .infinity)
//                        .background(
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(Color.white.opacity(0.9))
//                                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
//                                .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
//                        )
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 16)
//                                .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
//                        )
//                    }
//                    .disabled(email.isEmpty || password.isEmpty)
//                    .opacity(email.isEmpty || password.isEmpty ? 0.4 : 1.0)
//                    
//                    // Forgot password link
//                    Button(action: {
//                        // Forgot password action goes here
//                    }) {
//                        Text("Forgot your password?")
//                            .font(.system(size: 14, weight: .regular))
//                            .foregroundColor(.secondary.opacity(0.6))
//                    }
//                }
//                .padding(.horizontal, 24)
//                .padding(.bottom, 40)
//                .opacity(isVisible ? 1.0 : 0.0)
//                .animation(.easeOut(duration: 0.5).delay(1.0), value: isVisible)
//            }
//        }
//        .onAppear {
//            isVisible = true
//        }
//        .onTapGesture {
//            hideKeyboard()
//        }
//    }
//    
//    private func hideKeyboard() {
//        isEmailFocused = false
//        isPasswordFocused = false
//    }
//}
//
//#Preview {
//    SignInView()
//}

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()

                Circle()
                    .fill(Color.gray.opacity(0.03))
                    .frame(width: 350, height: 350)
                    .offset(x: -120, y: -180)
                    .blur(radius: 45)

                Circle()
                    .fill(Color.blue.opacity(0.02))
                    .frame(width: 280, height: 280)
                    .offset(x: 140, y: 220)
                    .blur(radius: 35)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 100)

                        VStack(spacing: 32) {
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)

                                Image(systemName: "person.circle")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }

                            Text("Welcome Back")
                                .font(.system(size: 28, weight: .light))
                                .foregroundColor(.black)
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

                                SecureField("Enter your password", text: $password)
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
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)

                        VStack(spacing: 32) {
                            Button(action: {
                                // Dummy sign in action
                            }) {
                                Text("Sign In")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                            }

                            VStack(spacing: 20) {
                                Button(action: {
                                    // Dummy forgot password action
                                }) {
                                    Text("Forgot Password?")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                }

                                Button(action: {
                                    // Dummy sign up navigation
                                }) {
                                    HStack(spacing: 6) {
                                        Text("Don't have an account?")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)

                                        Text("Sign Up")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.black)
                                    }
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
    }
}

#Preview {
    SignInView()
}
