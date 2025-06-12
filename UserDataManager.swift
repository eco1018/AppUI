

//
//  UserDataManager.swift
//  AppUI
//
//  Handles all saving/loading operations for user data
//

import Foundation
import FirebaseFirestore

@MainActor
class UserDataManager: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var currentUser: UserProfile?
    @Published var todaysDiaryCard: DiaryCard?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - User Profile Operations
    
    func saveUserProfile(_ profile: UserProfile) async throws {
        isLoading = true
        
        do {
            let data = try Firestore.Encoder().encode(profile)
            try await db.collection("userProfiles").document(profile.id).setData(data)
            self.currentUser = profile
        } catch {
            errorMessage = "Failed to save profile: \(error.localizedDescription)"
            throw error
        }
        
        isLoading = false
    }
    
    func loadUserProfile(userId: String) async throws -> UserProfile? {
        isLoading = true
        
        do {
            let document = try await db.collection("userProfiles").document(userId).getDocument()
            
            guard let data = document.data() else {
                isLoading = false
                return nil
            }
            
            let profile = try Firestore.Decoder().decode(UserProfile.self, from: data)
            self.currentUser = profile
            isLoading = false
            return profile
            
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
            isLoading = false
            throw error
        }
    }
    
    // MARK: - Diary Card Operations
    
    func saveDiaryCard(_ card: DiaryCard) async throws {
        isLoading = true
        
        do {
            let data = try Firestore.Encoder().encode(card)
            try await db.collection("diaryCards").document(card.id).setData(data)
            
            // Update local state if it's today's card
            if Calendar.current.isDate(card.date, inSameDayAs: Date()) {
                self.todaysDiaryCard = card
            }
            
        } catch {
            errorMessage = "Failed to save diary card: \(error.localizedDescription)"
            throw error
        }
        
        isLoading = false
    }
    
    func loadTodaysDiaryCard(userId: String) async throws -> DiaryCard? {
        return try await loadDiaryCard(userId: userId, date: Date())
    }
    
    func loadDiaryCard(userId: String, date: Date) async throws -> DiaryCard? {
        isLoading = true
        
        do {
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let query = db.collection("diaryCards")
                .whereField("userId", isEqualTo: userId)
                .whereField("date", isGreaterThanOrEqualTo: startOfDay)
                .whereField("date", isLessThan: endOfDay)
                .limit(to: 1)
            
            let snapshot = try await query.getDocuments()
            
            if let document = snapshot.documents.first {
                let card = try Firestore.Decoder().decode(DiaryCard.self, from: document.data())
                
                // Update local state if it's today's card
                if Calendar.current.isDate(card.date, inSameDayAs: Date()) {
                    self.todaysDiaryCard = card
                }
                
                isLoading = false
                return card
            }
            
            isLoading = false
            return nil
            
        } catch {
            errorMessage = "Failed to load diary card: \(error.localizedDescription)"
            isLoading = false
            throw error
        }
    }
    
    func loadRecentDiaryCards(userId: String, limit: Int = 30) async throws -> [DiaryCard] {
        isLoading = true
        
        do {
            let query = db.collection("diaryCards")
                .whereField("userId", isEqualTo: userId)
                .order(by: "date", descending: true)
                .limit(to: limit)
            
            let snapshot = try await query.getDocuments()
            
            let cards = try snapshot.documents.map { document in
                try Firestore.Decoder().decode(DiaryCard.self, from: document.data())
            }
            
            isLoading = false
            return cards
            
        } catch {
            errorMessage = "Failed to load recent diary cards: \(error.localizedDescription)"
            isLoading = false
            throw error
        }
    }
    
    // MARK: - Update User Selections
    
    func updateUserSelections(
        userId: String,
        selectedGoalIds: [String],
        selectedActionIds: [String],
        selectedUrgeIds: [String]
    ) async throws {
        isLoading = true
        
        do {
            let updates: [String: Any] = [
                "selectedGoalIds": selectedGoalIds,
                "selectedActionIds": selectedActionIds,
                "selectedUrgeIds": selectedUrgeIds,
                "updatedAt": Date()
            ]
            
            try await db.collection("userProfiles").document(userId).updateData(updates)
            
            // Update local state
            if var user = currentUser, user.id == userId {
                user = UserProfile(
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    age: user.age,
                    takesMediation: user.takesMediation,
                    reminderTime: user.reminderTime,
                    selectedUrgeIds: selectedUrgeIds,
                    selectedGoalIds: selectedGoalIds,
                    selectedActionIds: selectedActionIds,
                    customGoals: user.customGoals,
                    customActions: user.customActions,
                    customUrges: user.customUrges,
                    createdAt: user.createdAt,
                    updatedAt: Date()
                )
                self.currentUser = user
            }
            
        } catch {
            errorMessage = "Failed to update selections: \(error.localizedDescription)"
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Add Custom Items
    
    func addCustomGoal(userId: String, goalName: String) async throws {
        let customGoal = DbtGoal.custom(id: UUID().uuidString, name: goalName)
        
        do {
            let goalData = try Firestore.Encoder().encode(customGoal)
            
            try await db.collection("userProfiles").document(userId).updateData([
                "customGoals": FieldValue.arrayUnion([goalData]),
                "selectedGoalIds": FieldValue.arrayUnion([customGoal.id]),
                "updatedAt": Date()
            ])
            
            // Update local state
            if var user = currentUser, user.id == userId {
                var updatedCustomGoals = user.customGoals
                updatedCustomGoals.append(customGoal)
                
                var updatedSelectedGoalIds = user.selectedGoalIds
                updatedSelectedGoalIds.append(customGoal.id)
                
                user = UserProfile(
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    age: user.age,
                    takesMediation: user.takesMediation,
                    reminderTime: user.reminderTime,
                    selectedUrgeIds: user.selectedUrgeIds,
                    selectedGoalIds: updatedSelectedGoalIds,
                    selectedActionIds: user.selectedActionIds,
                    customGoals: updatedCustomGoals,
                    customActions: user.customActions,
                    customUrges: user.customUrges,
                    createdAt: user.createdAt,
                    updatedAt: Date()
                )
                self.currentUser = user
            }
            
        } catch {
            errorMessage = "Failed to add custom goal: \(error.localizedDescription)"
            throw error
        }
    }
    
    func addCustomAction(userId: String, actionName: String) async throws {
        let customAction = DbtAction.custom(id: UUID().uuidString, name: actionName)
        
        do {
            let actionData = try Firestore.Encoder().encode(customAction)
            
            try await db.collection("userProfiles").document(userId).updateData([
                "customActions": FieldValue.arrayUnion([actionData]),
                "selectedActionIds": FieldValue.arrayUnion([customAction.id]),
                "updatedAt": Date()
            ])
            
            // Update local state
            if var user = currentUser, user.id == userId {
                var updatedCustomActions = user.customActions
                updatedCustomActions.append(customAction)
                
                var updatedSelectedActionIds = user.selectedActionIds
                updatedSelectedActionIds.append(customAction.id)
                
                user = UserProfile(
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    age: user.age,
                    takesMediation: user.takesMediation,
                    reminderTime: user.reminderTime,
                    selectedUrgeIds: user.selectedUrgeIds,
                    selectedGoalIds: user.selectedGoalIds,
                    selectedActionIds: updatedSelectedActionIds,
                    customGoals: user.customGoals,
                    customActions: updatedCustomActions,
                    customUrges: user.customUrges,
                    createdAt: user.createdAt,
                    updatedAt: Date()
                )
                self.currentUser = user
            }
            
        } catch {
            errorMessage = "Failed to add custom action: \(error.localizedDescription)"
            throw error
        }
    }
    
    func addCustomUrge(userId: String, urgeName: String) async throws {
        let customUrge = DbtUrge.custom(id: UUID().uuidString, name: urgeName)
        
        do {
            let urgeData = try Firestore.Encoder().encode(customUrge)
            
            try await db.collection("userProfiles").document(userId).updateData([
                "customUrges": FieldValue.arrayUnion([urgeData]),
                "selectedUrgeIds": FieldValue.arrayUnion([customUrge.id]),
                "updatedAt": Date()
            ])
            
            // Update local state
            if var user = currentUser, user.id == userId {
                var updatedCustomUrges = user.customUrges
                updatedCustomUrges.append(customUrge)
                
                var updatedSelectedUrgeIds = user.selectedUrgeIds
                updatedSelectedUrgeIds.append(customUrge.id)
                
                user = UserProfile(
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    age: user.age,
                    takesMediation: user.takesMediation,
                    reminderTime: user.reminderTime,
                    selectedUrgeIds: updatedSelectedUrgeIds,
                    selectedGoalIds: user.selectedGoalIds,
                    selectedActionIds: user.selectedActionIds,
                    customGoals: user.customGoals,
                    customActions: user.customActions,
                    customUrges: updatedCustomUrges,
                    createdAt: user.createdAt,
                    updatedAt: Date()
                )
                self.currentUser = user
            }
            
        } catch {
            errorMessage = "Failed to add custom urge: \(error.localizedDescription)"
            throw error
        }
    }
    
    // MARK: - Helper Methods
    
    func getUserSelectedGoals() -> [DbtGoal] {
        guard let user = currentUser else { return [] }
        
        let standardGoals = DbtGoal.selectableGoals.filter { goal in
            user.selectedGoalIds.contains(goal.id)
        }
        
        return standardGoals + user.customGoals
    }
    
    func getUserSelectedActions() -> [DbtAction] {
        guard let user = currentUser else { return [] }
        
        let standardActions = DbtAction.selectableActions.filter { action in
            user.selectedActionIds.contains(action.id)
        }
        
        return DbtAction.fixedActions + standardActions + user.customActions
    }
    
    func getUserSelectedUrges() -> [DbtUrge] {
        guard let user = currentUser else { return [] }
        
        let standardUrges = DbtUrge.selectableUrges.filter { urge in
            user.selectedUrgeIds.contains(urge.id)
        }
        
        return DbtUrge.fixedUrges + standardUrges + user.customUrges
    }
}

// MARK: - UserProfile Custom Initializer Extension

extension UserProfile {
    init(
        id: String,
        firstName: String,
        lastName: String,
        age: Int,
        takesMediation: Bool,
        reminderTime: Date,
        selectedUrgeIds: [String],
        selectedGoalIds: [String],
        selectedActionIds: [String],
        customGoals: [DbtGoal],
        customActions: [DbtAction],
        customUrges: [DbtUrge],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.takesMediation = takesMediation
        self.reminderTime = reminderTime
        self.selectedUrgeIds = selectedUrgeIds
        self.selectedGoalIds = selectedGoalIds
        self.selectedActionIds = selectedActionIds
        self.customGoals = customGoals
        self.customActions = customActions
        self.customUrges = customUrges
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
