
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
        // For now, we'll start with authentication after a brief loading period
        // Later this will check UserDefaults/Keychain for saved state
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.appState = .authentication
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
                    AuthCoordinatorView()
                        .environmentObject(rootViewModel)
                case .onboarding:
                    OnboardingCoordinatorView()
                        .environmentObject(rootViewModel)
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

// MARK: - Temporary Coordinator Views (we'll replace these in later steps)
struct AuthCoordinatorView: View {
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        ZStack {
            // Matching background
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
            
            VStack(spacing: 40) {
                Text("Authentication")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                
                Text("Sign in or create account")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                
                Button("Complete Auth (Temporary)") {
                    rootViewModel.completeAuthentication()
                }
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.96, green: 0.96, blue: 0.97))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
                        )
                )
            }
        }
    }
}

struct OnboardingCoordinatorView: View {
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        ZStack {
            // Matching background
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
            
            VStack(spacing: 40) {
                Text("Onboarding")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                
                Text("Set up your preferences")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                
                Button("Complete Onboarding (Temporary)") {
                    rootViewModel.completeOnboarding()
                }
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.96, green: 0.96, blue: 0.97))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
                        )
                )
            }
        }
    }
}

struct MainAppCoordinatorView: View {
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        TabView {
            CoachCoordinatorView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Coach")
                }
            
            DiaryCardCoordinatorView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Card")
                }
            
            ProfileCoordinatorView()
                .environmentObject(rootViewModel)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(Color(red: 0.15, green: 0.15, blue: 0.2))
    }
}

struct CoachCoordinatorView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("DBT Coach")
                .font(.system(size: 42, weight: .ultraLight))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                .tracking(-1)
            
            Text("Coaching features coming soon")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
        }
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
