//
//
//  DiaryNote.swift
//  AppUI
//
//  Note entry for diary card with ViewModel integration
//

import SwiftUI

struct DiaryNote: View {
    @EnvironmentObject var diaryViewModel: DiaryCardViewModel
    @State private var animateContent = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Spacer()
            noteInputContent
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton {
                    diaryViewModel.goToPrevious()
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            // Title
            HStack {
                Text("Note")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            
            // Subtitle
            HStack {
                Text("Any additional thoughts about today?")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Note Input Content
    private var noteInputContent: some View {
        VStack(spacing: 20) {
            // Text input area
            TextField("Write your thoughts here...", text: $diaryViewModel.noteText, axis: .vertical)
                .font(.system(size: 18, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .focused($isTextFieldFocused)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isTextFieldFocused
                                        ? Color(red: 0.15, green: 0.15, blue: 0.2)
                                        : Color(red: 0.9, green: 0.9, blue: 0.92),
                                    lineWidth: isTextFieldFocused ? 1.5 : 1
                                )
                        )
                )
                .frame(minHeight: 120)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
                .animation(.easeInOut(duration: 0.2), value: isTextFieldFocused)
            
            // Character count (optional)
            if !diaryViewModel.noteText.isEmpty {
                HStack {
                    Spacer()
                    Text("\(diaryViewModel.noteText.count) characters")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                        .opacity(0.7)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
            }
        }
        .padding(.horizontal, 30)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            // Continue button (always available - note is optional)
            NextButton(title: "next") {
                hideKeyboard()
                diaryViewModel.goToNext()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isTextFieldFocused = false
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    DiaryNote()
        .environmentObject(DiaryCardViewModel())
}
