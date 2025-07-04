
//
//  OnboardingCoordinator.swift
//  AppUI
//
//  Onboarding flow coordinator
//

import SwiftUI

// MARK: - Onboarding Step Enum
enum OnboardingStep: Int, CaseIterable {
    case firstName = 0
    case lastName = 1
    case age = 2
    case medications = 3
    case urges = 4
    case goals = 5
    case actions = 6
    case reminder = 7
    case success = 8
    
    var title: String {
        switch self {
        case .firstName: return "First Name"
        case .lastName: return "Last Name"
        case .age: return "Age"
        case .medications: return "Medications"
        case .urges: return "Urges"
        case .goals: return "Goals"
        case .actions: return "Actions"
        case .reminder: return "Reminder"
        case .success: return "Success"
        }
    }
}

// MARK: - Onboarding View Model
@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .firstName
    @Published var isLoading = false
    
    // User Data (will replace hardcoded values in your views)
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var age = 25.0
    @Published var selectedMedication = ""
    @Published var selectedUrges: Set<Int> = []
    @Published var selectedGoals: Set<Int> = []
    @Published var selectedActions: Set<Int> = []
    @Published var reminderTime = Date()
    
    // Navigation
    var onOnboardingComplete: (() -> Void)?
    
    init(onOnboardingComplete: @escaping () -> Void) {
        self.onOnboardingComplete = onOnboardingComplete
    }
    
    // MARK: - Navigation Methods
    func goToNext() {
        guard let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) else {
            // We're at the last step, complete onboarding
            completeOnboarding()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = nextStep
        }
    }
    
    func goToPrevious() {
        guard let previousStep = OnboardingStep(rawValue: currentStep.rawValue - 1) else {
            return // Can't go back from first step
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = previousStep
        }
    }
    
    func completeOnboarding() {
        isLoading = true
        
        // Simulate saving user data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // Save onboarding completion flag
            UserDefaults.standard.set(true, forKey: "onboarding_complete")
            self.onOnboardingComplete?()
        }
    }
    
    // MARK: - Validation Methods
    func canProceedFromCurrentStep() -> Bool {
        switch currentStep {
        case .firstName:
            return !firstName.trimmingCharacters(in: .whitespaces).isEmpty
        case .lastName:
            return !lastName.trimmingCharacters(in: .whitespaces).isEmpty
        case .age:
            return age >= 13 && age <= 80
        case .medications:
            return !selectedMedication.isEmpty
        case .urges:
            return selectedUrges.count == 2
        case .goals:
            return selectedGoals.count == 2
        case .actions:
            return selectedActions.count == 3
        case .reminder:
            return true // Always valid
        case .success:
            return true // Always valid
        }
    }
    
    // MARK: - Progress Calculation
    var progressPercentage: Double {
        let totalSteps = OnboardingStep.allCases.count - 1 // Exclude success step
        return Double(currentStep.rawValue) / Double(totalSteps)
    }
}

// MARK: - Onboarding Coordinator View
struct OnboardingCoordinator: View {
    @StateObject private var onboardingViewModel: OnboardingViewModel
    
    init(onOnboardingComplete: @escaping () -> Void) {
        self._onboardingViewModel = StateObject(wrappedValue: OnboardingViewModel(onOnboardingComplete: onOnboardingComplete))
    }
    
    var body: some View {
        ZStack {
            // Background matching your app style
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
            
            // Content based on current step
            switch onboardingViewModel.currentStep {
            case .firstName:
                FirstNameView()
                    .environmentObject(onboardingViewModel)
            case .lastName:
                LastNameView()
                    .environmentObject(onboardingViewModel)
            case .age:
                AgeSelectionView()
                    .environmentObject(onboardingViewModel)
            case .medications:
                MedicationsView()
                    .environmentObject(onboardingViewModel)
            case .urges:
                UrgesSelectionView()
                    .environmentObject(onboardingViewModel)
            case .goals:
                GoalsSelectionView()
                    .environmentObject(onboardingViewModel)
            case .actions:
                ActionsSelectionView()
                    .environmentObject(onboardingViewModel)
            case .reminder:
                DiaryCardReminderView()
                    .environmentObject(onboardingViewModel)
            case .success:
                OnboardingSuccessView()
                    .environmentObject(onboardingViewModel)
            }
        }
    }
}
