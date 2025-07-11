
//
//
//  RootView.swift
//  AppUI
//
//  Central navigation controller for the entire app with authentication persistence
//

import SwiftUI

// MARK: - App State Enum
enum AppState {
    case loading
    case authentication
    case onboarding
    case mainApp
}

// MARK: - Root View Model
@MainActor
class RootViewModel: ObservableObject {
    @Published var appState: AppState = .loading
    @Published var isLoading = true
    
    // MARK: - UserDefaults Keys
    private let onboardingCompleteKey = "onboarding_complete"
    private let userAuthenticatedKey = "user_authenticated"
    
    init() {
        determineInitialState()
    }
    
    private func determineInitialState() {
        // Check both authentication and onboarding status
        let isAuthenticated = UserDefaults.standard.bool(forKey: userAuthenticatedKey)
        let onboardingComplete = UserDefaults.standard.bool(forKey: onboardingCompleteKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !isAuthenticated {
                // User needs to authenticate first
                self.appState = .authentication
            } else if !onboardingComplete {
                // User is authenticated but hasn't completed onboarding
                self.appState = .onboarding
            } else {
                // User is authenticated and has completed onboarding
                self.appState = .mainApp
            }
            self.isLoading = false
        }
    }
    
    func completeAuthentication() {
        // Save authentication status
        UserDefaults.standard.set(true, forKey: userAuthenticatedKey)
        
        // Check if onboarding is needed
        let onboardingComplete = UserDefaults.standard.bool(forKey: onboardingCompleteKey)
        
        if onboardingComplete {
            // Skip onboarding if already completed
            appState = .mainApp
        } else {
            // Go to onboarding
            appState = .onboarding
        }
    }
    
    func completeOnboarding() {
        // Save onboarding completion status
        UserDefaults.standard.set(true, forKey: onboardingCompleteKey)
        appState = .mainApp
    }
    
    func logout() {
        // Clear both authentication and onboarding status
        UserDefaults.standard.set(false, forKey: userAuthenticatedKey)
        UserDefaults.standard.set(false, forKey: onboardingCompleteKey)
        appState = .authentication
    }
    
    // MARK: - Helper Methods for Debugging
    func getCurrentAuthStatus() -> (isAuthenticated: Bool, onboardingComplete: Bool) {
        return (
            UserDefaults.standard.bool(forKey: userAuthenticatedKey),
            UserDefaults.standard.bool(forKey: onboardingCompleteKey)
        )
    }
}

// MARK: - Root View
struct RootView: View {
    @StateObject private var rootViewModel = RootViewModel()
    
    var body: some View {
        Group {
            if rootViewModel.isLoading {
                LoadingView()
            } else {
                switch rootViewModel.appState {
                case .loading:
                    LoadingView()
                case .authentication:
                    AuthCoordinator(onAuthenticationComplete: {
                        rootViewModel.completeAuthentication()
                    })
                case .onboarding:
                    OnboardingCoordinator(onOnboardingComplete: {
                        rootViewModel.completeOnboarding()
                    })
                case .mainApp:
                    MainAppCoordinatorView()
                        .environmentObject(rootViewModel)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: rootViewModel.appState)
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        ZStack {
            // Clean gradient background matching your app style
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
            
            VStack(spacing: 30) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Text("Loading...")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
            }
        }
    }
}

// MARK: - Main App Coordinator
struct MainAppCoordinatorView: View {
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        TabView {
            CoachCoordinator()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Coach")
                }
            
            DiaryCardCoordinator()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Card")
                }
            
            ProfileCoordinator(onLogout: {
                rootViewModel.logout()
            })
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(Color(red: 0.15, green: 0.15, blue: 0.2))
    }
}

#Preview {
    RootView()
}
