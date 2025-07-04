
//
//  RootView.swift
//  AppUI
//
//  Central navigation controller for the entire app
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
    
    init() {
        determineInitialState()
    }
    
    private func determineInitialState() {
        // Check if onboarding was completed
        let onboardingComplete = UserDefaults.standard.bool(forKey: "onboarding_complete")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if onboardingComplete {
                // Skip to main app if onboarding was completed
                self.appState = .mainApp
            } else {
                // Start with authentication
                self.appState = .authentication
            }
            self.isLoading = false
        }
    }
    
    func completeAuthentication() {
        appState = .onboarding
    }
    
    func completeOnboarding() {
        appState = .mainApp
    }
    
    func logout() {
        // Clear onboarding completion flag on logout
        UserDefaults.standard.set(false, forKey: "onboarding_complete")
        appState = .authentication
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
            
            ProfileCoordinator()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(Color(red: 0.15, green: 0.15, blue: 0.2))
    }
}

struct DiaryCardCoordinatorView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Daily Diary Card")
                .font(.system(size: 42, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .tracking(-1)
            
            Text("Multi-step diary entry")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
        }
    }
}

struct ProfileCoordinatorView: View {
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Profile")
                .font(.system(size: 42, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .tracking(-1)
            
            Text("Personal dashboard & settings")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
            
            Button("Logout") {
                rootViewModel.logout()
            }
            .font(.system(size: 18, weight: .light))
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.red)
            .cornerRadius(8)
        }
    }
}

#Preview {
    RootView()
}
