//
//  AppCoordinator.swift
//  AppUI
//
//  Main coordinator that manages the overall app state and navigation
//

import Foundation
import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    // MARK: - App State
    @Published var appState: AppState = .loading
    
    // MARK: - Managers
    @Published var userDataManager = UserDataManager()
    @Published var onboardingManager = OnboardingDataManager()
    @Published var diaryManager = DiaryEntryManager()
    
    // MARK: - Current User State
    @Published var isUserLoggedIn: Bool = false
    @Published var hasCompletedOnboarding: Bool = false
    
    enum AppState {
        case loading
        case authentication
        case onboarding
        case main
        case diaryEntry
    }
    
    // MARK: - Initialization
    
    init() {
        // Check if user is already logged in
        checkUserAuthenticationStatus()
    }
    
    // MARK: - Authentication Flow
    
    private func checkUserAuthenticationStatus() {
        // TODO: Implement actual authentication check
        // For now, we'll simulate checking if user data exists
        
        Task {
            do {
                // Try to load user profile with a stored user ID
                if let savedUserId = UserDefaults.standard.string(forKey: "userId"),
                   let userProfile = try await userDataManager.loadUserProfile(userId: savedUserId) {
                    
                    // User exists and has completed onboarding
                    isUserLoggedIn = true
                    hasCompletedOnboarding = true
                    appState = .main
                    
                } else {
                    // No user found, show authentication
                    appState = .authentication
                }
            } catch {
                // Error loading user, show authentication
                appState = .authentication
            }
        }
    }
    
    func handleSuccessfulLogin(userId: String) {
        UserDefaults.standard.set(userId, forKey: "userId")
        isUserLoggedIn = true
        
        // Check if user has completed onboarding
        Task {
            do {
                if let userProfile = try await userDataManager.loadUserProfile(userId: userId) {
                    hasCompletedOnboarding = true
                    appState = .main
                } else {
                    hasCompletedOnboarding = false
                    appState = .onboarding
                }
            } catch {
                // If we can't load the profile, assume they need onboarding
                hasCompletedOnboarding = false
                appState = .onboarding
            }
        }
    }
    
    func handleLogout() {
        UserDefaults.standard.removeObject(forKey: "userId")
        isUserLoggedIn = false
        hasCompletedOnboarding = false
        appState = .authentication
        
        // Reset all managers
        userDataManager = UserDataManager()
        onboardingManager = OnboardingDataManager()
        diaryManager = DiaryEntryManager()
    }
    
    // MARK: - Onboarding Flow
    
    func startOnboarding() {
        onboardingManager.resetOnboarding()
        appState = .onboarding
    }
    
    func completeOnboarding() {
        Task {
            do {
                try await onboardingManager.completeOnboarding(with: userDataManager)
                hasCompletedOnboarding = true
                appState = .main
            } catch {
                // Handle onboarding completion error
                print("Failed to complete onboarding: \(error)")
                // Could show an error state or retry
            }
        }
    }
    
    // MARK: - Diary Entry Flow
    
    func startDiaryEntry() {
        guard let user = userDataManager.currentUser else { return }
        
        diaryManager.startNewEntry()
        diaryManager.prepareForUser(user)
        appState = .diaryEntry
    }
    
    func completeDiaryEntry() {
        guard let userId = userDataManager.currentUser?.id else { return }
        
        Task {
            do {
                try await diaryManager.completeDiaryEntry(
                    userId: userId,
                    userDataManager: userDataManager
                )
                appState = .main
            } catch {
                // Handle diary entry completion error
                print("Failed to complete diary entry: \(error)")
                // Could show an error state or retry
            }
        }
    }
    
    func cancelDiaryEntry() {
        diaryManager.cancelEntry()
        appState = .main
    }
    
    // MARK: - Navigation Helpers
    
    func navigateToMain() {
        appState = .main
    }
    
    func navigateToOnboarding() {
        appState = .onboarding
    }
    
    // MARK: - Data Loading Helpers
    
    func loadTodaysDiaryCard() async {
        guard let userId = userDataManager.currentUser?.id else { return }
        
        do {
            let todaysCard = try await userDataManager.loadTodaysDiaryCard(userId: userId)
            if let card = todaysCard {
                diaryManager.loadExistingEntry(card)
            }
        } catch {
            print("Failed to load today's diary card: \(error)")
        }
    }
    
    func loadRecentDiaryCards() async -> [DiaryCard] {
        guard let userId = userDataManager.currentUser?.id else { return [] }
        
        do {
            return try await userDataManager.loadRecentDiaryCards(userId: userId)
        } catch {
            print("Failed to load recent diary cards: \(error)")
            return []
        }
    }
    
    // MARK: - Computed Properties
    
    var currentUser: UserProfile? {
        userDataManager.currentUser
    }
    
    var isLoading: Bool {
        userDataManager.isLoading
    }
    
    var errorMessage: String? {
        userDataManager.errorMessage
    }
}

// MARK: - Mock Authentication (Remove in production)

extension AppCoordinator {
    func mockLogin(firstName: String, lastName: String) {
        let mockUserId = UUID().uuidString
        handleSuccessfulLogin(userId: mockUserId)
    }
    
    func skipAuthentication() {
        // For development/testing purposes
        let mockUserId = UUID().uuidString
        UserDefaults.standard.set(mockUserId, forKey: "userId")
        isUserLoggedIn = true
        hasCompletedOnboarding = false
        appState = .onboarding
    }
}
