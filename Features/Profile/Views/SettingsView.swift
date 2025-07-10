////
////  SettingsView.swift
////  AppUI
////
////  SettingsView.swift
////  AppUI
////
////  Minimalist settings interface
////
//
//import SwiftUI
//
//struct SettingsView: View {
//    @State private var animateContent = false
//    
//    var body: some View {
//        ZStack {
//            // Clean gradient background
//            LinearGradient(
//                colors: [
//                    Color(red: 0.99, green: 0.99, blue: 1.0),
//                    Color(red: 0.97, green: 0.97, blue: 0.99),
//                    Color(red: 0.95, green: 0.95, blue: 0.98)
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                headerSection
//                Spacer()
//                settingsContent
//                Spacer()
//            }
//        }
//        .onAppear {
//            performAppearAnimations()
//        }
//    }
//    
//    // MARK: - Header Section
//    private var headerSection: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Button(action: {
//                    // Navigate back
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 18, weight: .light))
//                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
//                }
//                
//                Spacer()
//            }
//            .padding(.horizontal, 30)
//            .padding(.top, 60)
//            .padding(.bottom, 40)
//            
//            // Title
//            HStack {
//                Text("settings")
//                    .font(.system(size: 42, weight: .ultraLight))
//                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
//                    .tracking(-1)
//                    .opacity(animateContent ? 1.0 : 0.0)
//                    .offset(y: animateContent ? 0 : 30)
//                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
//                
//                Spacer()
//            }
//            .padding(.horizontal, 30)
//            .padding(.bottom, 60)
//        }
//    }
//    
//    // MARK: - Settings Content
//    private var settingsContent: some View {
//        VStack(alignment: .leading, spacing: 50) {
//            // Notifications
//            Button(action: {
//                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//                impactFeedback.impactOccurred()
//                // Navigate to Notifications Settings
//            }) {
//                HStack {
//                    Text("notifications")
//                        .font(.system(size: 24, weight: .light))
//                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//                        .tracking(-0.3)
//                    
//                    Spacer()
//                }
//            }
//            .opacity(animateContent ? 1.0 : 0.0)
//            .offset(y: animateContent ? 0 : 30)
//            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
//            
//            // Privacy
//            Button(action: {
//                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//                impactFeedback.impactOccurred()
//                // Navigate to Privacy Settings
//            }) {
//                HStack {
//                    Text("privacy")
//                        .font(.system(size: 24, weight: .light))
//                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//                        .tracking(-0.3)
//                    
//                    Spacer()
//                }
//            }
//            .opacity(animateContent ? 1.0 : 0.0)
//            .offset(y: animateContent ? 0 : 30)
//            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
//            
//            // Appearance
//            Button(action: {
//                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//                impactFeedback.impactOccurred()
//                // Navigate to Appearance Settings
//            }) {
//                HStack {
//                    Text("appearance")
//                        .font(.system(size: 24, weight: .light))
//                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//                        .tracking(-0.3)
//                    
//                    Spacer()
//                }
//            }
//            .opacity(animateContent ? 1.0 : 0.0)
//            .offset(y: animateContent ? 0 : 30)
//            .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
//            
//            // Support
//            Button(action: {
//                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//                impactFeedback.impactOccurred()
//                // Navigate to Support
//            }) {
//                HStack {
//                    Text("support")
//                        .font(.system(size: 24, weight: .light))
//                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//                        .tracking(-0.3)
//                    
//                    Spacer()
//                }
//            }
//            .opacity(animateContent ? 1.0 : 0.0)
//            .offset(y: animateContent ? 0 : 30)
//            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.horizontal, 30)
//    }
//    
//    // MARK: - Helper Methods
//    private func performAppearAnimations() {
//        withAnimation(.easeOut(duration: 0.6)) {
//            animateContent = true
//        }
//    }
//}
//
//
//  SettingsView.swift
//  AppUI
//
//  Settings view for managing user preferences
//

import SwiftUI

struct SettingsView: View {
    @State private var animateContent = false
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    let settingsItems = [
        SettingsItem(title: "Name", subtitle: "Update your first and last name"),
        SettingsItem(title: "Age", subtitle: "Change your age"),
        SettingsItem(title: "Medications", subtitle: "Update medication status"),
        SettingsItem(title: "Urges", subtitle: "Modify tracked urges (2 selected)"),
        SettingsItem(title: "Goals", subtitle: "Update your goals (2 selected)"),
        SettingsItem(title: "Actions", subtitle: "Change tracked actions (3 selected)"),
        SettingsItem(title: "Notifications", subtitle: "Adjust notification settings")
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
                    profileViewModel.goBack() // ✅ FIXED: Use generic back instead of showMenu()
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
            
            // Title
            HStack {
                Text("settings")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Scrollable Content
    private var scrollableContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
                    settingsItemView(item: item, index: index)
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private func settingsItemView(item: SettingsItem, index: Int) -> some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            handleNavigation(for: item.title)
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
            .background(settingsItemBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.08 + 0.4), value: animateContent)
    }
    
    private var settingsItemBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.92, green: 0.92, blue: 0.94), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Navigation Handler
    private func handleNavigation(for itemTitle: String) {
        switch itemTitle {
        case "Name":
            profileViewModel.showNamePreference()
        case "Age":
            profileViewModel.showAgePreference()
        case "Medications":
            profileViewModel.showMedicationsPreference()
        case "Urges":
            profileViewModel.showUrgesPreference()
        case "Goals":
            profileViewModel.showGoalsPreference()
        case "Actions":
            profileViewModel.showActionsPreference()
        case "Notifications":
            profileViewModel.showNotificationSettings()
        default:
            break
        }
    }
    
    // MARK: - Helper Methods
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Supporting Types
struct SettingsItem {
    let title: String
    let subtitle: String
}

#Preview {
    SettingsView()
        .environmentObject(ProfileViewModel(onLogout: {}))
}
