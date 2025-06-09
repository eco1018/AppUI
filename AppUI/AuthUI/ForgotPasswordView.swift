//
//  ForgotPasswordView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/8/25.


//
import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isEmailFocused: Bool = false

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
                                // Dummy reset password action
                            }) {
                                Text("Send Reset Link")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                            }

                            Button(action: {
                                // Dummy return to sign in action
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

                        Spacer(minLength: 40)
                    }
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
