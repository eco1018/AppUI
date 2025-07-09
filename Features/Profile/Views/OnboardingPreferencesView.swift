//
//
//  OnboardingPreferencesView.swift
//  AppUI
//
//  Preferences management interface - Updated with ProfileViewModel navigation
//

import SwiftUI

struct OnboardingPreferencesView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel  // Added
    @State private var animateContent = false
    
    let preferenceItems = [
        PreferenceItem(title: "Name", subtitle: "Update your first and last name", action: { vm in vm.showNamePreference() }),
        PreferenceItem(title: "Age", subtitle: "Change your age", action: { vm in vm.showAgePreference() }),
        PreferenceItem(title: "Medications", subtitle: "Update medication status", action: { vm in vm.showMedicationsPreference() }),
        PreferenceItem(title: "Urges", subtitle: "Modify tracked urges (2 selected)", action: { vm in vm.showUrgesPreference() }),
        PreferenceItem(title: "Goals", subtitle: "Update your goals (2 selected)", action: { vm in vm.showGoalsPreference() }),
        PreferenceItem(title: "Actions", subtitle: "Change tracked actions (3 selected)", action: { vm in vm.showActionsPreference() }),
        PreferenceItem(title: "Reminder", subtitle: "Adjust notification time", action: { vm in vm.showReminderPreference() })
    ]
    
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
                scrollableContent
            }
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    profileViewModel.showSettings() // Updated navigation
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
                    Text("Preferences")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("manage your onboarding selections")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Scrollable Content
    private var scrollableContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(preferenceItems.enumerated()), id: \.offset) { index, item in
                    preferenceItemView(item: item, index: index)
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private func preferenceItemView(item: PreferenceItem, index: Int) -> some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            item.action(profileViewModel) // Updated to use ProfileViewModel
        }) {
            HStack(spacing: 20) {
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.title)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(item.subtitle)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                        
                        Spacer()
                    }
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.65))
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .background(preferenceItemBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.08 + 0.6), value: animateContent)
    }
    
    private var preferenceItemBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.92, green: 0.92, blue: 0.94), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Helper Methods
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Supporting Types
struct PreferenceItem {
    let title: String
    let subtitle: String
    let action: (ProfileViewModel) -> Void  // Updated to accept ProfileViewModel
}

#Preview {
    OnboardingPreferencesView()
        .environmentObject(ProfileViewModel(onLogout: {}))
}
