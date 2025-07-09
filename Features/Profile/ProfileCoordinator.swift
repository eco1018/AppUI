
//
//
//  ProfileCoordinator.swift
//  AppUI
//
//  Profile feature coordinator - Step 2: Connected actual preference views
//

import SwiftUI

// MARK: - Profile Flow Enum (updated with missing cases)
enum ProfileFlow {
    case main
    case menu
    case history
    case settings
    case account                    // Added
    case onboardingPreferences      // Added
    case namePreference
    case agePreference
    case goalsPreference
    case urgesPreference
    case actionsPreference
    case medicationsPreference
    case reminderPreference         // Added
    case notificationSettings
}

// MARK: - Profile View Model
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var currentFlow: ProfileFlow = .main
    @Published var isLoading = false
    
    // Navigation
    var onLogout: (() -> Void)?
    
    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }
    
    // MARK: - Navigation Methods
    func showMenu() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .menu
        }
    }
    
    func showMain() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .main
        }
    }
    
    func showHistory() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .history
        }
    }
    
    func showSettings() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .settings
        }
    }
    
    func showAccount() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .account
        }
    }
    
    func showOnboardingPreferences() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .onboardingPreferences
        }
    }
    
    func showNamePreference() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .namePreference
        }
    }
    
    func showAgePreference() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .agePreference
        }
    }
    
    func showGoalsPreference() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .goalsPreference
        }
    }
    
    func showUrgesPreference() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .urgesPreference
        }
    }
    
    func showActionsPreference() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .actionsPreference
        }
    }
    
    func showMedicationsPreference() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .medicationsPreference
        }
    }
    
    func showReminderPreference() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .reminderPreference
        }
    }
    
    func showNotificationSettings() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .notificationSettings
        }
    }
    
    func logout() {
        onLogout?()
    }
}

// MARK: - Profile Coordinator View
struct ProfileCoordinator: View {
    @StateObject private var profileViewModel: ProfileViewModel
    
    init(onLogout: @escaping () -> Void) {
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel(onLogout: onLogout))
    }
    
    var body: some View {
        ZStack {
            // Background matching app style
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
            
            // Content based on current flow
            switch profileViewModel.currentFlow {
            case .main:
                MainProfileView(onMenuTap: {
                    profileViewModel.showMenu()
                })
                .environmentObject(profileViewModel)
                
            case .menu:
                // Placeholder for menu view
                VStack(spacing: 30) {
                    Text("Menu")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    
                    Button("History") {
                        profileViewModel.showHistory()
                    }
                    
                    Button("Settings") {
                        profileViewModel.showSettings()
                    }
                    
                    Button("Account") {
                        profileViewModel.showAccount()
                    }
                    
                    Button("Logout") {
                        profileViewModel.logout()
                    }
                    
                    Button("Back to Profile") {
                        profileViewModel.showMain()
                    }
                }
                
            case .history:
                HistoryView()
                    .environmentObject(profileViewModel)
                
            case .settings:
                // Placeholder for settings view
                VStack {
                    Text("Settings")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    
                    Button("Preferences") {
                        profileViewModel.showOnboardingPreferences()
                    }
                    
                    Button("Notifications") {
                        profileViewModel.showNotificationSettings()
                    }
                    
                    Button("Back") {
                        profileViewModel.showMenu()
                    }
                }
                
            case .account:
                AccountOptionsView()
                    .environmentObject(profileViewModel)
                
            case .onboardingPreferences:
                OnboardingPreferencesView()
                    .environmentObject(profileViewModel)
                
            case .namePreference:
                NamePreferenceView()
                    .environmentObject(profileViewModel)
                
            case .agePreference:
                // Placeholder for age preference view (exists but empty)
                VStack {
                    Text("Age Preference")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    
                    Button("Back") {
                        profileViewModel.showOnboardingPreferences()
                    }
                }
                
            case .goalsPreference:
                GoalsPreferenceView()
                    .environmentObject(profileViewModel)
                
            case .urgesPreference:
                UrgesPreferenceView()
                    .environmentObject(profileViewModel)
                
            case .actionsPreference:
                ActionsPreferenceView()
                    .environmentObject(profileViewModel)
                
            case .medicationsPreference:
                MedicationsPreferenceView()
                    .environmentObject(profileViewModel)
                
            case .reminderPreference:
                // Placeholder for reminder preference view (exists but empty)
                VStack {
                    Text("Reminder Preference")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    
                    Button("Back") {
                        profileViewModel.showOnboardingPreferences()
                    }
                }
                
            case .notificationSettings:
                NotificationSettingsView()
                    .environmentObject(profileViewModel)
            }
        }
    }
}

// MARK: - Main Profile View
struct MainProfileView: View {
    @State private var userName: String = "Ella" // This would come from user data
    @State private var animateContent = false
    @State private var currentTime = Date()
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    let onMenuTap: () -> Void
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerSection
                Spacer()
                settingsButton
            }
        }
        .onAppear {
            performAppearAnimations()
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 30) {
            // Time and greeting
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(timeFormatter.string(from: currentTime))
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                    
                    Spacer()
                }
                
                Text("hello, \(userName.lowercased())")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        .padding(.top, 60)
    }
    
    // MARK: - Settings Button (Bottom Left)
    private var settingsButton: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    onMenuTap()
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .frame(width: 44, height: 44)
                }
                .opacity(animateContent ? 0.8 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
    
    // MARK: - Helper Properties
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    ProfileCoordinator(onLogout: {
        print("Logout tapped")
    })
}
