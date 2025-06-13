//
//
//  AppUIApp.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct AppUIApp: App {
    // MARK: - App Coordinator (manages entire app state)
    @StateObject private var appCoordinator = AppCoordinator()
    
    // Initialize Firebase in init
    init() {
        FirebaseApp.configure()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appCoordinator)
                .environmentObject(appCoordinator.userDataManager)
                .environmentObject(appCoordinator.onboardingManager)
                .environmentObject(appCoordinator.diaryManager)
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - Root View that handles navigation based on app state

struct AppRootView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        Group {
            switch appCoordinator.appState {
            case .loading:
                LoadingView()
                
            case .authentication:
                AuthenticationFlow()
                
            case .onboarding:
                OnboardingFlow()
                
            case .main:
                MainAppFlow()
                
            case .diaryEntry:
                DiaryEntryFlow()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appCoordinator.appState)
    }
}

// MARK: - Flow Views

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.2)
                
                Text("Loading...")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AuthenticationFlow: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @State private var showSignUp = false
    
    var body: some View {
        NavigationView {
            if showSignUp {
                SignUpView()
                    .navigationBarHidden(true)
            } else {
                SignInView()
                    .navigationBarHidden(true)
            }
        }
        .overlay(
            // Development helper - remove in production
            VStack {
                Spacer()
                HStack {
                    Button("Skip Auth (Dev)") {
                        appCoordinator.skipAuthentication()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .padding()
            }
        )
    }
}

struct OnboardingFlow: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @EnvironmentObject var onboardingManager: OnboardingDataManager
    
    var body: some View {
        NavigationView {
            Group {
                switch onboardingManager.currentStep {
                case .intro:
                    OnboardingIntroView()
                case .firstName:
                    FirstNameView()
                case .lastName:
                    LastNameView()
                case .age:
                    AgeSelectionView()
                case .medications:
                    MedicationsView()
                case .urges:
                    UrgesSelectionView()
                case .goals:
                    GoalsSelectionView()
                case .actions:
                    ActionsSelectionView()
                case .reminder:
                    DiaryCardReminderView()
                case .success:
                    OnboardingSuccessView()
                        .onAppear {
                            appCoordinator.completeOnboarding()
                        }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MainAppFlow: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}

struct DiaryEntryFlow: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @EnvironmentObject var diaryManager: DiaryEntryManager
    
    var body: some View {
        NavigationView {
            Group {
                switch diaryManager.currentStep {
                case .urges:
                    DiaryUrgesView()
                case .emotions:
                    DiaryEmotions()
                case .skills:
                    DiarySkills()
                case .goals:
                    DiaryGoals()
                case .actions:
                    DiaryActionsView()
                case .medications:
                    DiaryMedications()
                case .note:
                    DiaryNote()
                case .complete:
                    DiaryCompletion()
                        .onAppear {
                            appCoordinator.completeDiaryEntry()
                        }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
