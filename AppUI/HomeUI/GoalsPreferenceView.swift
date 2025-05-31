//
//  GoalsPreferenceView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//


//
//  GoalsPreferenceView.swift
//  AppUI
//
//  Goals preference management interface
//

import SwiftUI

struct GoalsPreferenceView: View {
    @State private var selectedGoals: Set<Int> = [0, 3] // Pre-selected goals for demo
    @State private var animateContent = false
    @State private var showSaveButton = false
    @State private var activeItemIndex: Int = 0
    @State private var hasChanges = false
    @State private var originalGoals: Set<Int> = [0, 3] // Track original state
    
    let goals = [
        GoalItem(title: "use DBT skill", description: "practice using a DBT skill when feeling overwhelmed", timing: ""),
        GoalItem(title: "reach out", description: "reach out to someone for support when needed", timing: ""),
        GoalItem(title: "follow routine", description: "stick to a daily routine to provide structure", timing: ""),
        GoalItem(title: "nourish", description: "make sure you're eating and taking care of your physical health", timing: ""),
        GoalItem(title: "move body", description: "engage in physical activity to take care of your body", timing: ""),
        GoalItem(title: "get out of bed", description: "commit to getting out of bed, even on hard days", timing: ""),
        GoalItem(title: "self-compassion", description: "practice kindness towards yourself, especially in difficult moments", timing: ""),
        GoalItem(title: "ask for help", description: "be proactive in asking for support when you need it", timing: ""),
        GoalItem(title: "do for me", description: "set aside time to do something that's just for you", timing: ""),
        GoalItem(title: "align with values", description: "make choices that align with your core values", timing: ""),
        GoalItem(title: "other", description: "something else you want to track — write it in", timing: "")
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
                currentGoalsSection
                scrollableContent
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
                    // Navigate back
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
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Goals")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("manage your tracked goals")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Current Goals Section
    private var currentGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Current Goals")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
                
                Text("\(selectedGoals.count)/2")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            
            VStack(spacing: 12) {
                ForEach(Array(selectedGoals), id: \.self) { goalIndex in
                    if goalIndex < goals.count {
                        currentGoalItemView(goal: goals[goalIndex])
                    }
                }
                
                if selectedGoals.count < 2 {
                    emptyGoalSlotView()
                }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
    
    private func currentGoalItemView(goal: GoalItem) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Text(goal.description)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(currentGoalBackground)
    }
    
    private func emptyGoalSlotView() -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Add another goal")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.65))
                
                Text("Select from available goals below")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.75))
            }
            
            Spacer()
            
            Image(systemName: "plus.circle")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.65))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(emptyGoalBackground)
    }
    
    private var currentGoalBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.96, green: 0.98, blue: 0.96))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.85, green: 0.92, blue: 0.85), lineWidth: 1)
            )
    }
    
    private var emptyGoalBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.92), lineWidth: 1)
            )
    }
    
    // MARK: - Scrollable Content
    private var scrollableContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Available Goals")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        Spacer(minLength: 20)
                        
                        ForEach(Array(goals.enumerated()), id: \.offset) { index, goal in
                            goalItemView(goal: goal, index: index)
                                .id(index)
                        }
                        
                        Spacer(minLength: 120)
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(GoalsScrollOffsetPreferenceKey.self) { preferences in
                    updateActiveItem(from: preferences)
                }
            }
        }
    }
    
    private func goalItemView(goal: GoalItem, index: Int) -> some View {
        let isActive = index == activeItemIndex
        let isSelected = selectedGoals.contains(index)
        
        return Button(action: {
            handleGoalSelection(index: index)
        }) {
            HStack(alignment: .top, spacing: 20) {
                goalContentView(goal: goal, index: index, isActive: isActive)
                Spacer(minLength: 12)
                if isSelected {
                    selectionIndicatorView(index: index, isSelected: isSelected)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, isActive ? 12 : 8)
            .background(goalBackgroundView(isActive: isActive))
            .scaleEffect(getItemScale(index: index))
        }
        .buttonStyle(PlainButtonStyle())
        .background(geometryReaderView(index: index))
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 40)
        .animation(.easeOut(duration: 0.7).delay(Double(index) * 0.08 + 1.2), value: animateContent)
        .animation(.interpolatingSpring(stiffness: 180, damping: 18), value: activeItemIndex)
    }
    
    private func goalContentView(goal: GoalItem, index: Int, isActive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            titleView(goal: goal, index: index, isActive: isActive)
            
            if isActive {
                descriptionView(goal: goal)
            }
        }
    }
    
    private func titleView(goal: GoalItem, index: Int, isActive: Bool) -> some View {
        let isSelected = selectedGoals.contains(index)
        
        let fontSize: CGFloat = {
            if isActive {
                return isSelected ? 32 : 30
            } else if isSelected {
                return 22
            } else {
                return 20
            }
        }()
        
        let fontWeight: Font.Weight = isActive ? .light : .ultraLight
        let tracking: CGFloat = isActive ? -0.5 : -0.2
        let textColor = getTextColor(for: index)
        let textOpacity = getTextOpacity(for: index)
        
        return Text(goal.title)
            .font(.system(size: fontSize, weight: fontWeight))
            .foregroundColor(textColor)
            .opacity(textOpacity)
            .multilineTextAlignment(.leading)
            .tracking(tracking)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: activeItemIndex)
            .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: selectedGoals)
    }
    
    private func descriptionView(goal: GoalItem) -> some View {
        Text(goal.description)
            .font(.system(size: 15, weight: .light))
            .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.3))
            .opacity(0.9)
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
            .transition(.asymmetric(
                insertion: .scale(scale: 0.95).combined(with: .opacity).animation(.easeOut(duration: 0.3)),
                removal: .scale(scale: 1.05).combined(with: .opacity).animation(.easeIn(duration: 0.2))
            ))
    }
    
    private func selectionIndicatorView(index: Int, isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
                .frame(width: 28, height: 28)
                .overlay(
                    Circle()
                        .stroke(Color(red: 0.15, green: 0.15, blue: 0.2), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
            }
        }
        .scaleEffect(isSelected ? 1.0 : 0.9)
        .opacity(isSelected ? 1.0 : 0.8)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private func goalBackgroundView(isActive: Bool) -> some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color.clear)
    }
    
    private func geometryReaderView(index: Int) -> some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: GoalsScrollOffsetPreferenceKey.self,
                    value: [GoalsScrollOffsetData(index: index, offset: geometry.frame(in: .named("scroll")).midY)]
                )
        }
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
                    Text("save changes")
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
    private func handleGoalSelection(index: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if selectedGoals.contains(index) {
                selectedGoals.remove(index)
            } else if selectedGoals.count < 2 {
                selectedGoals.insert(index)
            }
            
            checkForChanges()
        }
    }
    
    private func checkForChanges() {
        hasChanges = selectedGoals != originalGoals
    }
    
    private func saveChanges() {
        originalGoals = selectedGoals
        hasChanges = false
        // Save to persistent storage here
    }
    
    private func getTextColor(for index: Int) -> Color {
        let isSelected = selectedGoals.contains(index)
        
        if index == activeItemIndex {
            return isSelected ?
            Color(red: 0.05, green: 0.05, blue: 0.1) :
            Color(red: 0.15, green: 0.15, blue: 0.2)
        } else if isSelected {
            return Color(red: 0.15, green: 0.15, blue: 0.2)
        } else {
            return Color(red: 0.45, green: 0.45, blue: 0.5)
        }
    }
    
    private func getTextOpacity(for index: Int) -> Double {
        if index == activeItemIndex {
            return 1.0
        } else if selectedGoals.contains(index) {
            return 0.9
        } else {
            let distance = abs(index - activeItemIndex)
            return distance == 1 ? 0.7 : 0.5
        }
    }
    
    private func getItemScale(index: Int) -> CGFloat {
        if index == activeItemIndex {
            return 1.02
        } else if abs(index - activeItemIndex) == 1 {
            return 0.98
        } else {
            return 0.95
        }
    }
    
    private func updateActiveItem(from preferences: [GoalsScrollOffsetData]) {
        let targetY: CGFloat = 400
        
        let closest = preferences.min { abs($0.offset - targetY) < abs($1.offset - targetY) }
        
        if let newActiveIndex = closest?.index, newActiveIndex != activeItemIndex {
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) {
                activeItemIndex = newActiveIndex
            }
            
            let selectionFeedback = UISelectionFeedbackGenerator()
            selectionFeedback.selectionChanged()
        }
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

#Preview {
    GoalsPreferenceView()
}