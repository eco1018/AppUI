//
//
//  ProfileViewModel.swift
//  AppUI
//
//  Profile feature view model with navigation stack
//

import SwiftUI

// MARK: - Profile Flow Enum
enum ProfileFlow {
    case main
    case menu
    case history
    case settings
    case account
    case onboardingPreferences
    case namePreference
    case agePreference
    case goalsPreference
    case urgesPreference
    case actionsPreference
    case medicationsPreference
    case reminderPreference
    case notificationSettings
}

// MARK: - Profile View Model
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var currentFlow: ProfileFlow = .main
    @Published var isLoading = false
    
    // Navigation stack to track history
    private var navigationStack: [ProfileFlow] = []
    
    // Navigation
    var onLogout: (() -> Void)?
    
    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }
    
    // MARK: - Navigation History Helper
    private func pushToStack(_ flow: ProfileFlow) {
        navigationStack.append(currentFlow)
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = flow
        }
    }
    
    // MARK: - Generic Back Navigation
    func goBack() {
        guard !navigationStack.isEmpty else {
            // If no history, go to main
            withAnimation(.easeInOut(duration: 0.3)) {
                currentFlow = .main
            }
            return
        }
        
        let previousFlow = navigationStack.removeLast()
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = previousFlow
        }
    }
    
    // MARK: - Navigation Methods
    func showMenu() {
        pushToStack(.menu)
    }
    
    func showMain() {
        // Clear stack when going to main (root)
        navigationStack.removeAll()
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = .main
        }
    }
    
    func showHistory() {
        pushToStack(.history)
    }
    
    func showSettings() {
        pushToStack(.settings)
    }
    
    func showAccount() {
        pushToStack(.account)
    }
    
    func showOnboardingPreferences() {
        pushToStack(.onboardingPreferences)
    }
    
    func showNamePreference() {
        pushToStack(.namePreference)
    }
    
    func showAgePreference() {
        pushToStack(.agePreference)
    }
    
    func showGoalsPreference() {
        pushToStack(.goalsPreference)
    }
    
    func showUrgesPreference() {
        pushToStack(.urgesPreference)
    }
    
    func showActionsPreference() {
        pushToStack(.actionsPreference)
    }
    
    func showMedicationsPreference() {
        pushToStack(.medicationsPreference)
    }
    
    func showReminderPreference() {
        pushToStack(.reminderPreference)
    }
    
    func showNotificationSettings() {
        pushToStack(.notificationSettings)
    }
    
    func logout() {
        onLogout?()
    }
}
