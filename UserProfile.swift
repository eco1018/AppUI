//
//  UserProfileModel.swift
//  AppUI
//
//  User profile data model - stores user info and their selections
//

import Foundation

struct UserProfile: Codable, Identifiable {
    let id: String
    
    // Basic user info
    let firstName: String
    let lastName: String
    let age: Int
    let takesMediation: Bool
    let reminderTime: Date
    
    // What they selected during onboarding
    let selectedUrgeIds: [String]     // IDs of urges they chose to track
    let selectedGoalIds: [String]     // IDs of goals they chose to track
    let selectedActionIds: [String]   // IDs of actions they chose to track
    
    // Custom items they created
    let customGoals: [DbtGoal]
    let customActions: [DbtAction]
    let customUrges: [DbtUrge]
    
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString, firstName: String, lastName: String, age: Int, takesMediation: Bool, reminderTime: Date) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.takesMediation = takesMediation
        self.reminderTime = reminderTime
        self.selectedUrgeIds = []
        self.selectedGoalIds = []
        self.selectedActionIds = []
        self.customGoals = []
        self.customActions = []
        self.customUrges = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
