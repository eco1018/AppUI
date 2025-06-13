//
//  OnboardingDataManager.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/12/25.
//


//
//  OnboardingDataManager.swift
//  AppUI
//
//  Manages the onboarding flow and temporary selections before saving to UserProfile
//

import Foundation
import SwiftUI

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
        
        // Create UserProfile
        let userProfile = UserProfile(
            id: UUID().uuidString,
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
        
        // Save to Firebase
        try await userDataManager.saveUserProfile(userProfile)
        
        // Mark onboarding as complete
        isOnboardingComplete = true
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
            } else {
                let customIndex = index - standardItems.count
                if customIndex < customItems.count {
                    ids.append(customItems[customIndex].id)
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
    
    // MARK: - Reset
    
    func resetOnboarding() {
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
    }
}