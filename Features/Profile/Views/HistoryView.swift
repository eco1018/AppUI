
//
//
//  HistoryView.swift
//  AppUI
//
//  History view for displaying past diary card entries - Updated with ProfileViewModel navigation
//

import SwiftUI

// MARK: - History View
struct HistoryView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel  // Added
    @State private var animateContent = false
    
    // Sample diary entries (this would come from your data layer later)
    let sampleEntries = [
        DiaryEntry(date: Date(), emotions: ["happy", "calm"], completedGoals: 2, usedSkills: ["TIPP", "Mindfulness"]),
        DiaryEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), emotions: ["anxious", "hopeful"], completedGoals: 1, usedSkills: ["Distraction"]),
        DiaryEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), emotions: ["grateful", "tired"], completedGoals: 3, usedSkills: ["PLEASE", "Self-Soothing"]),
        DiaryEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), emotions: ["frustrated"], completedGoals: 0, usedSkills: ["Radical Acceptance"])
    ]
    
    var body: some View {
        ZStack {
            // Clean gradient background
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
                headerSection
                entriesList
            }
        }
        .onAppear {
            performAppearAnimations()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton {
                    profileViewModel.goBack()
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Title
            HStack {
                Text("history")
                    .font(.system(size: 42, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .tracking(-1)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Entries List
    private var entriesList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(Array(sampleEntries.enumerated()), id: \.offset) { index, entry in
                    diaryEntryCard(entry: entry, index: index)
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private func diaryEntryCard(entry: DiaryEntry, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date header
            HStack {
                Text(dateFormatter.string(from: entry.date))
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
                
                Text(timeAgo(from: entry.date))
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
            }
            
            // Entry details
            VStack(alignment: .leading, spacing: 8) {
                // Emotions
                HStack {
                    Text("Emotions:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    
                    Text(entry.emotions.joined(separator: ", "))
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                }
                
                // Goals
                HStack {
                    Text("Goals completed:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    
                    Text("\(entry.completedGoals)")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                }
                
                // Skills
                HStack {
                    Text("Skills used:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    
                    Text(entry.usedSkills.joined(separator: ", "))
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(entryCardBackground)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.4), value: animateContent)
    }
    
    private var entryCardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.92, green: 0.92, blue: 0.94), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Helper Properties
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }
    
    private func timeAgo(from date: Date) -> String {
        let daysDifference = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        switch daysDifference {
        case 0:
            return "today"
        case 1:
            return "yesterday"
        default:
            return "\(daysDifference) days ago"
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Sample Data Model
struct DiaryEntry {
    let date: Date
    let emotions: [String]
    let completedGoals: Int
    let usedSkills: [String]
}

#Preview {
    HistoryView()
        .environmentObject(ProfileViewModel(onLogout: {}))
}
