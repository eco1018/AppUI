//
//  OnboardingProgressBar.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 6/28/25.
//


//
//  OnboardingProgressBar.swift
//  AppUI
//
//  Reusable progress bar component for onboarding flow
//

import SwiftUI

struct OnboardingProgressBar: View {
    @EnvironmentObject var onboardingManager: OnboardingDataManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Progress bar
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .frame(height: 3)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .frame(width: progressWidth, height: 3)
                    .animation(.easeInOut(duration: 0.4), value: progressPercentage)
            }
            .frame(maxWidth: .infinity)
            
            // Step indicator
            HStack {
                Text("\(currentStepNumber) of \(totalSteps)")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                
                Spacer()
                
                Text(stepTitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    // MARK: - Computed Properties
    
    private var progressPercentage: Double {
        onboardingManager.progressPercentage
    }
    
    private var progressWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 60 // Account for horizontal padding
        return screenWidth * progressPercentage
    }
    
    private var currentStepNumber: Int {
        // Start counting from firstName (skip intro)
        let progressSteps = OnboardingDataManager.OnboardingStep.allCases.filter { step in
            step != .intro && step != .success
        }
        
        guard let currentIndex = progressSteps.firstIndex(of: onboardingManager.currentStep) else {
            return 1
        }
        
        return currentIndex + 1
    }
    
    private var totalSteps: Int {
        // Count all steps except intro and success
        OnboardingDataManager.OnboardingStep.allCases.filter { step in
            step != .intro && step != .success
        }.count
    }
    
    private var stepTitle: String {
        switch onboardingManager.currentStep {
        case .intro:
            return ""
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .age:
            return "Age"
        case .medications:
            return "Medications"
        case .urges:
            return "Urges"
        case .goals:
            return "Goals"
        case .actions:
            return "Actions"
        case .reminder:
            return "Reminder"
        case .success:
            return "Complete"
        }
    }
}

#Preview {
    VStack {
        OnboardingProgressBar()
            .environmentObject({
                let manager = OnboardingDataManager()
                manager.currentStep = .firstName
                return manager
            }())
        
        Spacer()
    }
    .background(Color(red: 0.99, green: 0.99, blue: 1.0))
}