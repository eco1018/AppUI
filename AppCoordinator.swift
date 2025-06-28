//
//
//  AppCoordinator.swift
//  AppUI
//
//  Main coordinator that manages the overall app state and navigation
//

import Foundation
import SwiftUI
import FirebaseAuth

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
        if let currentUser = Auth.auth().currentUser {
            // User is signed in with Firebase
            isUserLoggedIn = true
            
            Task {
                do {
                    // Try to load user profile from Firestore
                    if let userProfile = try await userDataManager.loadUserProfile(userId: currentUser.uid) {
                        hasCompletedOnboarding = true
                        appState = .main
                    } else {
                        // User exists in Firebase but no profile in Firestore - needs onboarding
                        hasCompletedOnboarding = false
                        appState = .onboarding
                    }
                } catch {
                    // Error loading user profile - assume needs onboarding
                    hasCompletedOnboarding = false
                    appState = .onboarding
                }
            }
        } else {
            // No user signed in
            appState = .authentication
        }
    }
    
    func handleSuccessfulLogin(userId: String) {
        isUserLoggedIn = true
        
        // Check if user has completed onboarding
        Task {
            do {
                if let userProfile = try await userDataManager.loadUserProfile(userId: userId) {
                    hasCompletedOnboarding = true
                    appState = .main
                } else {
                    // User authenticated but no profile exists - needs onboarding
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
        do {
            try Auth.auth().signOut()
            
            // Clear local state
            isUserLoggedIn = false
            hasCompletedOnboarding = false
            appState = .authentication
            
            // Reset all managers
            userDataManager = UserDataManager()
            onboardingManager = OnboardingDataManager()
            diaryManager = DiaryEntryManager()
            
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
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
        guard let currentUser = Auth.auth().currentUser else { return }
        
        Task {
            do {
                try await diaryManager.completeDiaryEntry(
                    userId: currentUser.uid,
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
        guard let currentUser = Auth.auth().currentUser else { return }
        
        do {
            let todaysCard = try await userDataManager.loadTodaysDiaryCard(userId: currentUser.uid)
            if let card = todaysCard {
                diaryManager.loadExistingEntry(card)
            }
        } catch {
            print("Failed to load today's diary card: \(error)")
        }
    }
    
    func loadRecentDiaryCards() async -> [DiaryCard] {
        guard let currentUser = Auth.auth().currentUser else { return [] }
        
        do {
            return try await userDataManager.loadRecentDiaryCards(userId: currentUser.uid)
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
    
    var currentFirebaseUser: User? {
        Auth.auth().currentUser
    }
}

// MARK: - Development/Mock Authentication (Keep for testing)

extension AppCoordinator {
    func mockLogin(firstName: String, lastName: String) {
        // This can be kept for development/testing purposes
        let mockUserId = UUID().uuidString
        handleSuccessfulLogin(userId: mockUserId)
    }
    
    func skipAuthentication() {
        // For development/testing purposes
        let mockUserId = UUID().uuidString
        isUserLoggedIn = true
        hasCompletedOnboarding = false
        appState = .onboarding
    }
}
