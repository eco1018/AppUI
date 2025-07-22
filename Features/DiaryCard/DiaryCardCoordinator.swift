//
//  DiaryCardCoordinator.swift
//  AppUI
//
//  Daily diary card flow coordinator
//

import SwiftUI

// MARK: - Diary Step Enum
enum DiaryStep: Int, CaseIterable {
    case emotions = 0
    case urges = 1
    case goals = 2
    case actions = 3
    case medications = 4
    case skills = 5
    case note = 6
    case completion = 7
    
    var title: String {
        switch self {
        case .emotions: return "Emotions"
        case .urges: return "Urges"
        case .goals: return "Goals"
        case .actions: return "Actions"
        case .medications: return "Medications"
        case .skills: return "Skills"
        case .note: return "Note"
        case .completion: return "Complete"
        }
    }
}

// MARK: - Diary Card View Model
@MainActor
class DiaryCardViewModel: ObservableObject {
    @Published var currentStep: DiaryStep = .emotions
    @Published var isLoading = false
    @Published var showingDiaryFlow = false
    
    // Diary Data
    @Published var selectedEmotions: Set<String> = []
    @Published var selectedUrges: Set<String> = []
    @Published var completedGoals: Set<String> = []
    @Published var performedActions: Set<String> = []
    @Published var tookMedications: Bool? = nil  // CHANGED: from Bool to Bool?
    @Published var usedSkills: Set<String> = []
    @Published var noteText = ""
    
    // Navigation - ADDED onComplete handler
    var onComplete: (() -> Void)?
    
    // UPDATED: Added onComplete parameter
    init(onComplete: @escaping () -> Void = {}) {
        self.onComplete = onComplete
    }
    
    // MARK: - Navigation Methods
    func startDiaryCard() {
        // Reset diary data for new entry
        resetDiaryData()
        withAnimation(.easeInOut(duration: 0.3)) {
            showingDiaryFlow = true
            currentStep = .emotions
        }
    }
    
    func goToNext() {
        guard let nextStep = DiaryStep(rawValue: currentStep.rawValue + 1) else {
            // We're at the last step, complete diary
            completeDiaryCard()
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = nextStep
        }
    }
    
    func goToPrevious() {
        guard let previousStep = DiaryStep(rawValue: currentStep.rawValue - 1) else {
            // Go back to main diary view
            withAnimation(.easeInOut(duration: 0.3)) {
                showingDiaryFlow = false
            }
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = previousStep
        }
    }
    
    // UPDATED: Now calls onComplete
    func completeDiaryCard() {
        isLoading = true
        
        // Simulate saving diary entry
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // Return to main diary view
            withAnimation(.easeInOut(duration: 0.3)) {
                self.showingDiaryFlow = false
            }
            // ✅ NEW: Communicate completion back to parent
            self.onComplete?()
        }
    }
    
    // MARK: - Helper Methods
    private func resetDiaryData() {
        selectedEmotions.removeAll()
        selectedUrges.removeAll()
        completedGoals.removeAll()
        performedActions.removeAll()
        tookMedications = nil  // CHANGED: from false to nil
        usedSkills.removeAll()
        noteText = ""
    }
    
    // MARK: - Progress Calculation
    var progressPercentage: Double {
        let totalSteps = DiaryStep.allCases.count - 1 // Exclude completion step
        let currentStepValue = min(currentStep.rawValue, totalSteps - 1)
        return Double(currentStepValue) / Double(totalSteps - 1)
    }
}

// MARK: - Diary Card Coordinator View
struct DiaryCardCoordinator: View {
    @StateObject private var diaryViewModel: DiaryCardViewModel
    
    // UPDATED: Added onComplete parameter
    init(onComplete: @escaping () -> Void = {}) {
        self._diaryViewModel = StateObject(wrappedValue: DiaryCardViewModel(onComplete: onComplete))
    }
    
    var body: some View {
        ZStack {
            if diaryViewModel.showingDiaryFlow {
                // Full-screen diary flow
                diaryFlowContent
            } else {
                // Main diary dashboard
                DiaryMainView {
                    diaryViewModel.startDiaryCard()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: diaryViewModel.showingDiaryFlow)
    }
    
    // MARK: - Diary Flow Content
    private var diaryFlowContent: some View {
        ZStack {
            // Background
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
            
            VStack(spacing: 0) {
                // Progress Bar Section - Only show if not on completion step
                if diaryViewModel.currentStep != .completion {
                    progressBarSection
                }
                
                // Content based on current step
                switch diaryViewModel.currentStep {
                case .emotions:
                    DiaryEmotions()
                        .environmentObject(diaryViewModel)
                case .urges:
                    DiaryUrgesView()
                        .environmentObject(diaryViewModel)
                case .goals:
                    DiaryGoals()
                        .environmentObject(diaryViewModel)
                case .actions:
                    DiaryActionsView()
                        .environmentObject(diaryViewModel)
                case .medications:
                    DiaryMedications()
                        .environmentObject(diaryViewModel)
                case .skills:
                    DiarySkills()
                        .environmentObject(diaryViewModel)
                case .note:
                    DiaryNote()
                        .environmentObject(diaryViewModel)
                case .completion:
                    DiaryCompletion()
                        .environmentObject(diaryViewModel)
                }
            }
        }
    }
    
    // MARK: - Progress Bar Section
    private var progressBarSection: some View {
        VStack(spacing: 0) {
            // Progress Bar
            HStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.92))
                            .frame(height: 4)
                        
                        // Progress fill
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                            .frame(width: geometry.size.width * diaryViewModel.progressPercentage, height: 4)
                            .animation(.easeInOut(duration: 0.3), value: diaryViewModel.progressPercentage)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal, 30)
            .padding(.top, 50)
            .padding(.bottom, 20)
        }
    }
}
