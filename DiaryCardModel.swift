
//
//  DiaryCardModel.swift
//  AppUI
//
//  Diary card data model - stores one day's diary responses
//

import Foundation

// MARK: - Response Models (user's answer + which item they're answering about)

struct UrgeResponse: Codable, Identifiable {
    let id: String
    let urgeId: String    // Which urge (references the ID)
    let intensity: Int    // User's 0-10 rating
    
    init(urgeId: String, intensity: Int) {
        self.id = UUID().uuidString
        self.urgeId = urgeId
        self.intensity = max(0, min(10, intensity))
    }
}

struct EmotionResponse: Codable, Identifiable {
    let id: String
    let emotionId: String // Which emotion (references the ID)
    let intensity: Int    // User's 0-10 rating
    
    init(emotionId: String, intensity: Int) {
        self.id = UUID().uuidString
        self.emotionId = emotionId
        self.intensity = max(0, min(10, intensity))
    }
}

struct GoalResponse: Codable, Identifiable {
    let id: String
    let goalId: String    // Which goal (references the ID)
    let completed: Bool   // User's Yes/No answer
    
    init(goalId: String, completed: Bool) {
        self.id = UUID().uuidString
        self.goalId = goalId
        self.completed = completed
    }
}

struct ActionResponse: Codable, Identifiable {
    let id: String
    let actionId: String  // Which action (references the ID)
    let performed: Bool   // User's Yes/No answer
    
    init(actionId: String, performed: Bool) {
        self.id = UUID().uuidString
        self.actionId = actionId
        self.performed = performed
    }
}

// MARK: - Diary Card (one complete day's responses)

struct DiaryCard: Codable, Identifiable {
    let id: String
    let userId: String    // Links back to UserProfile
    let date: Date        // Which day this entry is for
    
    // All responses for this day
    let urgeResponses: [UrgeResponse]
    let emotionResponses: [EmotionResponse]
    let goalResponses: [GoalResponse]
    let actionResponses: [ActionResponse]
    
    // Additional daily data
    let skillRating: DbtSkillUsefulnessRating?
    let medicationCheckIn: DbtMedicationCheckIn?
    let note: DbtDiaryNote?
    
    let createdAt: Date
    let updatedAt: Date
    
    init(userId: String, date: Date = Date()) {
        self.id = UUID().uuidString
        self.userId = userId
        self.date = Calendar.current.startOfDay(for: date)
        self.urgeResponses = []
        self.emotionResponses = []
        self.goalResponses = []
        self.actionResponses = []
        self.skillRating = nil
        self.medicationCheckIn = nil
        self.note = nil
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
