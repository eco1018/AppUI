//
//  GoalsSelectionView.swift
//
//  GoalsSelectionView.swift
//  AppUI
//
//  Minimalist goals selection interface
//

import SwiftUI

struct GoalsSelectionView: View {
    @State private var selectedGoals: Set<Int> = []
    @State private var animateContent = false
    @State private var showContinueButton = false
    @State private var activeItemIndex: Int = 0
    
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
                    Text("choose 2 goals to track and heal")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
                
                // Selection indicators
                HStack(spacing: 8) {
                    ForEach(0..<2, id: \.self) { index in
                        let isSelected = index < selectedGoals.count
                        let circleColor = isSelected ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.75, green: 0.75, blue: 0.77)
                        let scaleEffect: CGFloat = isSelected ? 1.3 : 1.0
                        
                        Circle()
                            .fill(circleColor)
                            .frame(width: 5, height: 5)
                            .scaleEffect(scaleEffect)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedGoals.count)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Scrollable Content
    private var scrollableContent: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Spacer(minLength: 80)
                    
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
    
    private func goalItemView(goal: GoalItem, index: Int) -> some View {
        let isActive = index == activeItemIndex
        let isSelected = selectedGoals.contains(index)
        let isSelectable = true
        
        return Button(action: {
            handleGoalSelection(index: index)
        }) {
            HStack(alignment: .top, spacing: 20) {
                goalContentView(goal: goal, index: index, isActive: isActive)
                Spacer(minLength: 12)
                if isSelectable && isSelected {
                    selectionIndicatorView(index: index, isSelected: isSelected)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, isActive ? 12 : 8)
            .background(goalBackgroundView(isActive: isActive))
            .scaleEffect(getItemScale(index: index))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isSelectable)
        .background(geometryReaderView(index: index))
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 40)
        .animation(.easeOut(duration: 0.7).delay(Double(index) * 0.08), value: animateContent)
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
        
        // Size logic: selected items get bigger, active items get biggest
        let fontSize: CGFloat = {
            if isActive {
                return isSelected ? 44 : 42
            } else if isSelected {
                return 30
            } else {
                return 26
            }
        }()
        
        let fontWeight: Font.Weight = isActive ? .thin : .ultraLight
        let tracking: CGFloat = isActive ? -1.0 : -0.2
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
            // Subtle background circle
            Circle()
                .fill(Color(red: 0.98, green: 0.98, blue: 0.99))
                .frame(width: 28, height: 28)
                .overlay(
                    Circle()
                        .stroke(Color(red: 0.15, green: 0.15, blue: 0.2), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
            
            // Minimalist checkmark
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
            if showContinueButton {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    // Handle continue action
                }) {
                    Text("next")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .tracking(-0.3)
                }
                .opacity(showContinueButton ? 1.0 : 0.0)
                .offset(y: showContinueButton ? 0 : 30)
                .animation(.easeOut(duration: 0.8), value: showContinueButton)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Methods
    private func handleGoalSelection(index: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Allow selection of any item, limit to 2
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if selectedGoals.contains(index) {
                selectedGoals.remove(index)
                showContinueButton = false
            } else if selectedGoals.count < 2 {
                selectedGoals.insert(index)
                if selectedGoals.count == 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showContinueButton = true
                        }
                    }
                }
            }
        }
    }
    
    private func getTextColor(for index: Int) -> Color {
        let isSelected = selectedGoals.contains(index)
        
        if index == activeItemIndex {
            return isSelected ?
            Color(red: 0.05, green: 0.05, blue: 0.1) :  // Even darker when both active and selected
            Color(red: 0.15, green: 0.15, blue: 0.2)
        } else if isSelected {
            return Color(red: 0.15, green: 0.15, blue: 0.2)  // Darker for selected items
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
        // Target the center of the visible area where we want the active item
        let targetY: CGFloat = 380
        
        // Find the item closest to the target center position
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

// MARK: - Supporting Types
struct GoalItem {
    let title: String
    let description: String
    let timing: String
}

struct GoalsScrollOffsetData: Equatable {
    let index: Int
    let offset: CGFloat
    
    static func == (lhs: GoalsScrollOffsetData, rhs: GoalsScrollOffsetData) -> Bool {
        return lhs.index == rhs.index && abs(lhs.offset - rhs.offset) < 0.1
    }
}

struct GoalsScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [GoalsScrollOffsetData] = []
    
    static func reduce(value: inout [GoalsScrollOffsetData], nextValue: () -> [GoalsScrollOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    GoalsSelectionView()
}
