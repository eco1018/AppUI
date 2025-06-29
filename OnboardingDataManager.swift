//
//  OnboardingDataManager.swift
//  AppUI
//
//
//  OnboardingDataManager.swift
//  AppUI
//
//  Manages the onboarding flow and temporary selections before saving to UserProfile
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
class OnboardingDataManager: ObservableObject {
    // MARK: - Temporary Storage During Onboarding
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: Int = 18
    @Published var takesMediation: Bool = false
    @Published var reminderTime: Date = Date()
    
    // Selected items during onboarding (store indices, convert to IDs later)
    @Published var selectedUrgeIndices: Set<Int> = []
    @Published var selectedGoalIndices: Set<Int> = []
    @Published var selectedActionIndices: Set<Int> = []
    
    // Custom items created during onboarding
    @Published var customGoals: [DbtGoal] = []
    @Published var customActions: [DbtAction] = []
    @Published var customUrges: [DbtUrge] = []
    
    // Progress tracking
    @Published var currentStep: OnboardingStep = .intro
    @Published var isOnboardingComplete: Bool = false
    
    enum OnboardingStep: String, CaseIterable {
        case intro = "intro"
        case firstName = "firstName"
        case lastName = "lastName"
        case age = "age"
        case medications = "medications"
        case urges = "urges"
        case goals = "goals"
        case actions = "actions"
        case reminder = "reminder"
        case success = "success"
    }
    
    // MARK: - Navigation Methods
    
    func nextStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep),
              currentIndex < OnboardingStep.allCases.count - 1 else {
            return
        }
        currentStep = OnboardingStep.allCases[currentIndex + 1]
    }
    
    func previousStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep),
              currentIndex > 0 else {
            return
        }
        currentStep = OnboardingStep.allCases[currentIndex - 1]
    }
    
    // MARK: - Selection Management
    
    func toggleUrgeSelection(_ index: Int) {
        if selectedUrgeIndices.contains(index) {
            selectedUrgeIndices.remove(index)
        } else if selectedUrgeIndices.count < 2 {
            selectedUrgeIndices.insert(index)
        }
    }
    
    func toggleGoalSelection(_ index: Int) {
        if selectedGoalIndices.contains(index) {
            selectedGoalIndices.remove(index)
        } else if selectedGoalIndices.count < 2 {
            selectedGoalIndices.insert(index)
        }
    }
    
    func toggleActionSelection(_ index: Int) {
        if selectedActionIndices.contains(index) {
            selectedActionIndices.remove(index)
        } else if selectedActionIndices.count < 3 {
            selectedActionIndices.insert(index)
        }
    }
    
    // MARK: - Custom Item Management
    
    func addCustomGoal(_ name: String) {
        let customGoal = DbtGoal.custom(id: UUID().uuidString, name: name)
        customGoals.append(customGoal)
        // Auto-select the custom goal
        selectedGoalIndices.insert(DbtGoal.selectableGoals.count + customGoals.count - 1)
    }
    
    func addCustomAction(_ name: String) {
        let customAction = DbtAction.custom(id: UUID().uuidString, name: name)
        customActions.append(customAction)
        // Auto-select the custom action
        selectedActionIndices.insert(DbtAction.selectableActions.count + customActions.count - 1)
    }
    
    func addCustomUrge(_ name: String) {
        let customUrge = DbtUrge.custom(id: UUID().uuidString, name: name)
        customUrges.append(customUrge)
        // Auto-select the custom urge
        selectedUrgeIndices.insert(DbtUrge.selectableUrges.count + customUrges.count - 1)
    }
    
    // MARK: - Data Conversion & Completion
    
    func completeOnboarding(with userDataManager: UserDataManager) async throws {
        print("🎯 Starting onboarding completion...")
        
        // Make sure we have a current Firebase user
        guard let currentUser = Auth.auth().currentUser else {
            print("❌ No authenticated user found")
            throw NSError(domain: "OnboardingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        
        print("👤 Current user ID: \(currentUser.uid)")
        
        // Convert indices to actual IDs
        let selectedUrgeIds = convertIndicesToIds(
            indices: selectedUrgeIndices,
            standardItems: DbtUrge.selectableUrges,
            customItems: customUrges
        )
        
        let selectedGoalIds = convertIndicesToIds(
            indices: selectedGoalIndices,
            standardItems: DbtGoal.selectableGoals,
            customItems: customGoals
        )
        
        let selectedActionIds = convertIndicesToIds(
            indices: selectedActionIndices,
            standardItems: DbtAction.selectableActions,
            customItems: customActions
        )
        
        print("📊 Selected urges: \(selectedUrgeIds)")
        print("📊 Selected goals: \(selectedGoalIds)")
        print("📊 Selected actions: \(selectedActionIds)")
        
        // Create UserProfile with Firebase UID
        let userProfile = UserProfile(
            id: currentUser.uid,  // Use Firebase UID as the profile ID
            firstName: firstName,
            lastName: lastName,
            age: age,
            takesMediation: takesMediation,
            reminderTime: reminderTime,
            selectedUrgeIds: selectedUrgeIds,
            selectedGoalIds: selectedGoalIds,
            selectedActionIds: selectedActionIds,
            customGoals: customGoals,
            customActions: customActions,
            customUrges: customUrges,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        print("💾 Saving user profile to Firestore...")
        
        // Save to Firebase Firestore
        try await userDataManager.saveUserProfile(userProfile)
        
        print("✅ User profile saved successfully!")
        
        // Mark onboarding as complete
        isOnboardingComplete = true
        
        print("🎉 Onboarding completion process finished!")
    }
    
    private func convertIndicesToIds<T: Identifiable>(
        indices: Set<Int>,
        standardItems: [T],
        customItems: [T]
    ) -> [String] where T.ID == String {
        var ids: [String] = []
        
        for index in indices {
            if index < standardItems.count {
                ids.append(standardItems[index].id)
                print("📝 Selected standard item: \(standardItems[index].id)")
            } else {
                let customIndex = index - standardItems.count
                if customIndex < customItems.count {
                    ids.append(customItems[customIndex].id)
                    print("📝 Selected custom item: \(customItems[customIndex].id)")
                }
            }
        }
        
        return ids
    }
    
    // MARK: - Validation
    
    var canProceedFromCurrentStep: Bool {
        switch currentStep {
        case .intro:
            return true
        case .firstName:
            return !firstName.trimmingCharacters(in: .whitespaces).isEmpty
        case .lastName:
            return !lastName.trimmingCharacters(in: .whitespaces).isEmpty
        case .age:
            return age >= 13
        case .medications:
            return true // Always can proceed from medications
        case .urges:
            return selectedUrgeIndices.count == 2
        case .goals:
            return selectedGoalIndices.count == 2
        case .actions:
            return selectedActionIndices.count == 3
        case .reminder:
            return true
        case .success:
            return isOnboardingComplete
        }
    }
    
    var progressPercentage: Double {
        let totalSteps = OnboardingStep.allCases.count - 1 // Exclude .success
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep) else { return 0 }
        return Double(currentIndex) / Double(totalSteps)
    }
    
    // MARK: - Reset
    
    func resetOnboarding() {
        print("🔄 Resetting onboarding data...")
        firstName = ""
        lastName = ""
        age = 18
        takesMediation = false
        reminderTime = Date()
        selectedUrgeIndices.removeAll()
        selectedGoalIndices.removeAll()
        selectedActionIndices.removeAll()
        customGoals.removeAll()
        customActions.removeAll()
        customUrges.removeAll()
        currentStep = .intro
        isOnboardingComplete = false
        print("✅ Onboarding data reset complete")
    }
}
