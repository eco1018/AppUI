//
//  NotificationSettingsView.swift
//  AppUI
//
//  Notification settings management interface
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var animateContent = false
    @State private var dailyReminder = true
    @State private var skillReminders = false
    @State private var progressUpdates = true
    @State private var hasChanges = false
    @State private var originalSettings = (daily: true, skills: false, progress: true)
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
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
                notificationsList
                Spacer()
                bottomSection
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
                Button(action: {
                    profileViewModel.showSettings()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Title
            HStack {
                Text("notifications")
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
    
    // MARK: - Notifications List
    private var notificationsList: some View {
        VStack(spacing: 20) {
            // Daily Reminder
            notificationToggle(
                title: "Daily Diary Reminder",
                subtitle: "Get reminded to complete your daily diary card",
                isOn: $dailyReminder,
                index: 0
            )
            
            // Skill Reminders
            notificationToggle(
                title: "Skill Practice Reminders",
                subtitle: "Gentle reminders to practice DBT skills",
                isOn: $skillReminders,
                index: 1
            )
            
            // Progress Updates
            notificationToggle(
                title: "Progress Updates",
                subtitle: "Weekly insights about your journey",
                isOn: $progressUpdates,
                index: 2
            )
        }
        .padding(.horizontal, 30)
    }
    
    private func notificationToggle(title: String, subtitle: String, isOn: Binding<Bool>, index: Int) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.15, green: 0.15, blue: 0.2)))
                .onChange(of: isOn.wrappedValue) { _ in
                    checkForChanges()
                }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(toggleBackground)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.4), value: animateContent)
    }
    
    private var toggleBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.92, green: 0.92, blue: 0.94), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack {
            if hasChanges {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    saveChanges()
                }) {
                    Text("save")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .tracking(-0.3)
                }
                .opacity(hasChanges ? 1.0 : 0.0)
                .offset(y: hasChanges ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: hasChanges)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func checkForChanges() {
        hasChanges = (dailyReminder != originalSettings.daily) ||
                    (skillReminders != originalSettings.skills) ||
                    (progressUpdates != originalSettings.progress)
    }
    
    private func saveChanges() {
        originalSettings = (daily: dailyReminder, skills: skillReminders, progress: progressUpdates)
        hasChanges = false
        // Save to persistent storage here
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    NotificationSettingsView()
        .environmentObject(ProfileViewModel(onLogout: {}))
}