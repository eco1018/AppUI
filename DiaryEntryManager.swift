

//
//  DiaryEntryManager.swift
//  AppUI
//
//  Manages the daily diary entry flow and temporary responses before saving
//

import Foundation
import SwiftUI

@MainActor
class DiaryEntryManager: ObservableObject {
    // MARK: - Current Entry State
    @Published var currentDate: Date = Date()
    @Published var isEntryInProgress: Bool = false
    @Published var currentStep: DiaryStep = .urges
    
    // Temporary response storage during diary entry
    @Published var urgeIntensities: [String: Int] = [:]      // urgeId: intensity (0-10)
    @Published var emotionIntensities: [String: Int] = [:]   // emotionId: intensity (0-10)
    @Published var goalCompletions: [String: Bool] = [:]     // goalId: completed (true/false)
    @Published var actionPerformed: [String: Bool] = [:]     // actionId: performed (true/false)
    @Published var skillRating: Int = 0                      // 0-10 rating
    @Published var medicationTaken: Bool = false             // Yes/No
    @Published var diaryNote: String = ""                    // Free text
    
    enum DiaryStep: String, CaseIterable {
        case urges = "urges"
        case emotions = "emotions" 
        case skills = "skills"
        case goals = "goals"
        case actions = "actions"
        case medications = "medications"
        case note = "note"
        case complete = "complete"
    }
    
    // MARK: - Navigation
    
    func nextStep() {
        guard let currentIndex = DiaryStep.allCases.firstIndex(of: currentStep),
              currentIndex < DiaryStep.allCases.count - 1 else {
            return
        }
        currentStep = DiaryStep.allCases[currentIndex + 1]
    }
    
    func previousStep() {
        guard let currentIndex = DiaryStep.allCases.firstIndex(of: currentStep),
              currentIndex > 0 else {
            return
        }
        currentStep = DiaryStep.allCases[currentIndex - 1]
    }
    
    // MARK: - Data Entry Methods
    
    func setUrgeIntensity(_ urgeId: String, intensity: Int) {
        urgeIntensities[urgeId] = max(0, min(10, intensity))
    }
    
    func setEmotionIntensity(_ emotionId: String, intensity: Int) {
        emotionIntensities[emotionId] = max(0, min(10, intensity))
    }
    
    func setGoalCompletion(_ goalId: String, completed: Bool) {
        goalCompletions[goalId] = completed
    }
    
    func setActionPerformed(_ actionId: String, performed: Bool) {
        actionPerformed[actionId] = performed
    }
    
    func setSkillRating(_ rating: Int) {
        skillRating = max(0, min(10, rating))
    }
    
    func setMedicationTaken(_ taken: Bool) {
        medicationTaken = taken
    }
    
    func setDiaryNote(_ note: String) {
        diaryNote = note
    }
    
    // MARK: - Entry Management
    
    func startNewEntry(for date: Date = Date()) {
        currentDate = Calendar.current.startOfDay(for: date)
        isEntryInProgress = true
        currentStep = .urges
        clearTemporaryData()
    }
    
    func loadExistingEntry(_ diaryCard: DiaryCard) {
        currentDate = diaryCard.date
        isEntryInProgress = true
        
        // Load existing responses into temporary storage
        for response in diaryCard.urgeResponses {
            urgeIntensities[response.urgeId] = response.intensity
        }
        
        for response in diaryCard.emotionResponses {
            emotionIntensities[response.emotionId] = response.intensity
        }
        
        for response in diaryCard.goalResponses {
            goalCompletions[response.goalId] = response.completed
        }
        
        for response in diaryCard.actionResponses {
            actionPerformed[response.actionId] = response.performed
        }
        
        skillRating = diaryCard.skillRating?.score ?? 0
        medicationTaken = diaryCard.medicationCheckIn?.didTakeMeds ?? false
        diaryNote = diaryCard.note?.text ?? ""
    }
    
    func completeDiaryEntry(
        userId: String,
        userDataManager: UserDataManager
    ) async throws {
        // Create response objects
        let urgeResponses = urgeIntensities.map { (urgeId, intensity) in
            UrgeResponse(urgeId: urgeId, intensity: intensity)
        }
        
        let emotionResponses = emotionIntensities.map { (emotionId, intensity) in
            EmotionResponse(emotionId: emotionId, intensity: intensity)
        }
        
        let goalResponses = goalCompletions.map { (goalId, completed) in
            GoalResponse(goalId: goalId, completed: completed)
        }
        
        let actionResponses = actionPerformed.map { (actionId, performed) in
            ActionResponse(actionId: actionId, performed: performed)
        }
        
        // Create additional data objects
        let skillUsefulnessRating = DbtSkillUsefulnessRating(score: skillRating)
        let medicationCheckIn = DbtMedicationCheckIn(didTakeMeds: medicationTaken)
        let note = diaryNote.isEmpty ? nil : DbtDiaryNote(text: diaryNote)
        
        // Create DiaryCard
        let diaryCard = DiaryCard(
            id: UUID().uuidString,
            userId: userId,
            date: currentDate,
            urgeResponses: urgeResponses,
            emotionResponses: emotionResponses,
            goalResponses: goalResponses,
            actionResponses: actionResponses,
            skillRating: skillUsefulnessRating,
            medicationCheckIn: medicationCheckIn,
            note: note,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // Save to Firebase
        try await userDataManager.saveDiaryCard(diaryCard)
        
        // Clear temporary data and end entry session
        clearTemporaryData()
        isEntryInProgress = false
        currentStep = .complete
    }
    
    private func clearTemporaryData() {
        urgeIntensities.removeAll()
        emotionIntensities.removeAll()
        goalCompletions.removeAll()
        actionPerformed.removeAll()
        skillRating = 0
        medicationTaken = false
        diaryNote = ""
    }
    
    // MARK: - Pre-population for User's Selected Items
    
    func prepareForUser(_ userProfile: UserProfile) {
        // Initialize all user's selected urges with 0 intensity
        for urgeId in DbtUrge.fixedUrges.map(\.id) + userProfile.selectedUrgeIds {
            urgeIntensities[urgeId] = 0
        }
        
        // Initialize all core emotions with 0 intensity
        for emotion in DbtEmotion.all {
            emotionIntensities[emotion.id] = 0
        }
        
        // Initialize user's selected goals with false
        for goalId in userProfile.selectedGoalIds {
            goalCompletions[goalId] = false
        }
        
        // Initialize all actions (fixed + user's selected) with false
        let allActionIds = DbtAction.fixedActions.map(\.id) + userProfile.selectedActionIds
        for actionId in allActionIds {
            actionPerformed[actionId] = false
        }
    }
    
    // MARK: - Validation
    
    var canProceedFromCurrentStep: Bool {
        switch currentStep {
        case .urges:
            return !urgeIntensities.isEmpty
        case .emotions:
            return !emotionIntensities.isEmpty
        case .skills:
            return true // Optional
        case .goals:
            return !goalCompletions.isEmpty
        case .actions:
            return !actionPerformed.isEmpty
        case .medications:
            return true // Always can proceed
        case .note:
            return true // Optional
        case .complete:
            return true
        }
    }
    
    var progressPercentage: Double {
        let totalSteps = DiaryStep.allCases.count - 1 // Exclude .complete
        guard let currentIndex = DiaryStep.allCases.firstIndex(of: currentStep) else { return 0 }
        return Double(currentIndex) / Double(totalSteps)
    }
    
    // MARK: - Cancel Entry
    
    func cancelEntry() {
        clearTemporaryData()
        isEntryInProgress = false
        currentStep = .urges
    }
}
