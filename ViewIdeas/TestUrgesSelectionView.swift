//
//  TestUrgesSelectionView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 7/14/25.
//
//
//  DiaryMedications.swift
//  AppUI
//
//  Medications tracking for diary card with card UI
//

//import SwiftUI
//
//struct DiaryMedications: View {
//    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
//    @State private var animateContent = false
//    @State private var showContinueButton = false
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            headerSection
//            Spacer()
//            medicationSelectionContent
//            Spacer()
//            bottomSection
//        }
//        .onAppear {
//            performAppearAnimations()
//        }
//        .onChange(of: diaryViewModel.tookMedications) { _ in
//            updateContinueButton()
//        }
//    }
//    
//    // MARK: - Header Section
//    private var headerSection: some View {
//        VStack(spacing: 0) {
//            HStack {
//                BackButton {
//                    diaryViewModel.goToPrevious()
//                }
//                
//                Spacer()
//            }
//            .padding(.horizontal, 30)
//            .padding(.top, 20)
//            .padding(.bottom, 40)
//            
//            // Title and subtitle
//            VStack(alignment: .leading, spacing: 12) {
//                HStack {
//                    Text("Medications")
//                        .font(.system(size: 42, weight: .ultraLight))
//                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
//                        .tracking(-1)
//                        .opacity(animateContent ? 1.0 : 0.0)
//                        .offset(y: animateContent ? 0 : 30)
//                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
//                    
//                    Spacer()
//                }
//                
//                HStack {
//                    Text("did you take your medications today?")
//                        .font(.system(size: 16, weight: .light))
//                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
//                        .opacity(animateContent ? 1.0 : 0.0)
//                        .offset(y: animateContent ? 0 : 20)
//                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
//                    
//                    Spacer()
//                }
//            }
//            .padding(.horizontal, 30)
//            .padding(.bottom, 40)
//        }
//    }
//    
//    // MARK: - Medication Selection Content (Centered)
//    private var medicationSelectionContent: some View {
//        VStack(spacing: 16) {
//            // Yes option
//            Button(action: {
//                selectOption(true)
//            }) {
//                HStack {
//                    Text("yes")
//                        .font(.system(size: 24, weight: .light))
//                        .foregroundColor(diaryViewModel.tookMedications ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
//                    
//                    Spacer()
//                    
//                    if diaryViewModel.tookMedications {
//                        Image(systemName: "checkmark.circle.fill")
//                            .font(.system(size: 20))
//                            .foregroundColor(.white)
//                    } else {
//                        Circle()
//                            .stroke(Color(red: 0.8, green: 0.8, blue: 0.85), lineWidth: 1)
//                            .frame(width: 20, height: 20)
//                    }
//                }
//                .padding(20)
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(diaryViewModel.tookMedications ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.98, green: 0.98, blue: 0.99))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: diaryViewModel.tookMedications ? 0 : 1)
//                        )
//                )
//            }
//            .buttonStyle(PlainButtonStyle())
//            .scaleEffect(diaryViewModel.tookMedications ? 1.02 : 1.0)
//            .animation(.easeInOut(duration: 0.2), value: diaryViewModel.tookMedications)
//            .opacity(animateContent ? 1.0 : 0.0)
//            .offset(y: animateContent ? 0 : 20)
//            .animation(.easeOut(duration: 0.6).delay(0.6), value: animateContent)
//            
//            // No option
//            Button(action: {
//                selectOption(false)
//            }) {
//                HStack {
//                    Text("no")
//                        .font(.system(size: 24, weight: .light))
//                        .foregroundColor(!diaryViewModel.tookMedications ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
//                    
//                    Spacer()
//                    
//                    if !diaryViewModel.tookMedications {
//                        Image(systemName: "checkmark.circle.fill")
//                            .font(.system(size: 20))
//                            .foregroundColor(.white)
//                    } else {
//                        Circle()
//                            .stroke(Color(red: 0.8, green: 0.8, blue: 0.85), lineWidth: 1)
//                            .frame(width: 20, height: 20)
//                    }
//                }
//                .padding(20)
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(!diaryViewModel.tookMedications ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.98, green: 0.98, blue: 0.99))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: !diaryViewModel.tookMedications ? 0 : 1)
//                        )
//                )
//            }
//            .buttonStyle(PlainButtonStyle())
//            .scaleEffect(!diaryViewModel.tookMedications ? 1.02 : 1.0)
//            .animation(.easeInOut(duration: 0.2), value: diaryViewModel.tookMedications)
//            .opacity(animateContent ? 1.0 : 0.0)
//            .offset(y: animateContent ? 0 : 20)
//            .animation(.easeOut(duration: 0.6).delay(0.7), value: animateContent)
//        }
//        .padding(.horizontal, 30)
//    }
//    
//    // MARK: - Bottom Section
//    private var bottomSection: some View {
//        VStack {
//            if showContinueButton {
//                NextButton(title: "next") {
//                    diaryViewModel.goToNext()
//                }
//                .opacity(showContinueButton ? 1.0 : 0.0)
//                .offset(y: showContinueButton ? 0 : 30)
//                .animation(.easeOut(duration: 0.8), value: showContinueButton)
//            }
//        }
//        .padding(.horizontal, 30)
//        .padding(.bottom, 60)
//    }
//    
//    // MARK: - Helper Methods
//    private func selectOption(_ tookMeds: Bool) {
//        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//        impactFeedback.impactOccurred()
//        
//        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//            diaryViewModel.tookMedications = tookMeds
//        }
//    }
//    
//    private func updateContinueButton() {
//        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
//            showContinueButton = true // Always show since it's a boolean choice
//        }
//    }
//    
//    private func performAppearAnimations() {
//        withAnimation(.easeOut(duration: 0.6)) {
//            animateContent = true
//        }
//    }
//}
//
//#Preview {
//    DiaryMedications()
//        .environmentObject(DiaryCardViewModel())
//}
//
