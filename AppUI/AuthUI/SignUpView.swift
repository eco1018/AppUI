//
//  SignUpView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/8/25.


import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatch: Bool = false
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    @State private var isConfirmPasswordFocused: Bool = false

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
                                showPasswordMismatch = password != confirmPassword
                            }) {
                                Text("Create Account")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                            }

                            Button(action: {}) {
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
    }
}

#Preview {
    SignUpView()
}
