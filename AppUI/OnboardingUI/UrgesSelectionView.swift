//
////  UrgesSelectionView.swift
////
////
////  UrgesSelectionView.swift
////  AppUI
////
////  Enhanced version with smooth scrolling - Optimized for compilation
////
//
//import SwiftUI
//
//struct UrgesSelectionView: View {
//    @State private var selectedUrges: Set<Int> = []
//    @State private var animateContent = false
//    @State private var showContinueButton = false
//    @State private var progressValue: Double = 0
//    @State private var activeItemIndex: Int = 0
//    
//    let urges = [
//        UrgeItem(title: "substance use", description: "the desire to use drugs or alcohol to cope with pain", timing: "track patterns • build awareness"),
//        UrgeItem(title: "disordered eating", description: "the urge to restrict, binge, or purge food", timing: "mindful eating • body awareness"),
//        UrgeItem(title: "shutting down", description: "an urge to shut down emotionally and avoid interaction", timing: "emotional regulation • connection tools"),
//        UrgeItem(title: "breaking things", description: "the urge to destroy things when feeling triggered", timing: "anger management • impulse control"),
//        UrgeItem(title: "alleviate", description: "reduce feelings of distress and emotional pain", timing: "coping strategies • healing"),
//        UrgeItem(title: "anxiety", description: "overwhelming worry and fear responses", timing: "mindfulness • grounding"),
//        UrgeItem(title: "awake", description: "difficulty with sleep and rest patterns", timing: "sleep hygiene • relaxation"),
//        UrgeItem(title: "sleep", description: "challenges with healthy sleep cycles", timing: "routine • environment"),
//        UrgeItem(title: "balance", description: "finding stability in daily life", timing: "wellness • harmony")
//    ]
//    
//    var body: some View {
//        ZStack {
//            backgroundGradient
//            
//            VStack(spacing: 0) {
//                headerSection
//                scrollableContent
//                bottomSection
//            }
//        }
//        .onAppear {
//            performAppearAnimations()
//        }
//    }
//    
//    // MARK: - Background
//    private var backgroundGradient: some View {
//        LinearGradient(
//            colors: [
//                Color(red: 0.98, green: 0.98, blue: 0.99),
//                Color(red: 0.96, green: 0.96, blue: 0.97),
//                Color(red: 0.94, green: 0.94, blue: 0.96),
//                Color(red: 0.92, green: 0.92, blue: 0.95)
//            ],
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )
//        .ignoresSafeArea()
//    }
//    
//    // MARK: - Header Section
//    private var headerSection: some View {
//        VStack(spacing: 0) {
//            progressIndicator
//            headerText
//        }
//    }
//    
//    private var progressIndicator: some View {
//        HStack {
//            Spacer()
//            ZStack {
//                Circle()
//                    .stroke(Color(red: 0.7, green: 0.7, blue: 0.72).opacity(0.4), lineWidth: 2)
//                    .frame(width: 40, height: 40)
//                
//                Circle()
//                    .trim(from: 0, to: progressValue)
//                    .stroke(Color(red: 0.3, green: 0.3, blue: 0.35), style: StrokeStyle(lineWidth: 2, lineCap: .round))
//                    .frame(width: 40, height: 40)
//                    .rotationEffect(.degrees(-90))
//                    .animation(.easeInOut(duration: 1.5), value: progressValue)
//                
//                Text("2/5")
//                    .font(.system(size: 10, weight: .medium))
//                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
//            }
//        }
//        .padding(.horizontal, 30)
//        .padding(.top, 20)
//        .padding(.bottom, 20)
//    }
//    
//    private var headerText: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("choose")
//                .font(.system(size: 48, weight: .ultraLight))
//                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//                .opacity(animateContent ? 1.0 : 0.0)
//                .offset(y: animateContent ? 0 : 30)
//                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
//            
//            Text("2 urges to track and heal")
//                .font(.system(size: 16, weight: .light))
//                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
//                .opacity(animateContent ? 1.0 : 0.0)
//                .offset(y: animateContent ? 0 : 20)
//                .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.horizontal, 30)
//        .padding(.bottom, 30)
//    }
//    
//    // MARK: - Scrollable Content
//    private var scrollableContent: some View {
//        ScrollViewReader { proxy in
//            ScrollView(.vertical, showsIndicators: false) {
//                LazyVStack(alignment: .leading, spacing: 0) {
//                    Spacer(minLength: 80)
//                    
//                    ForEach(Array(urges.enumerated()), id: \.offset) { index, urge in
//                        urgeItemView(urge: urge, index: index)
//                            .id(index)
//                    }
//                    
//                    Spacer(minLength: 120)
//                }
//            }
//            .coordinateSpace(name: "scroll")
//            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { preferences in
//                updateActiveItem(from: preferences)
//            }
//        }
//    }
//    
//    private func urgeItemView(urge: UrgeItem, index: Int) -> some View {
//        let isActive = index == activeItemIndex
//        let isSelected = selectedUrges.contains(index)
//        let isSelectable = true // Make all items selectable
//        
//        return Button(action: {
//            handleUrgeSelection(index: index)
//        }) {
//            HStack(alignment: .top, spacing: 20) {
//                urgeContentView(urge: urge, index: index, isActive: isActive)
//                Spacer(minLength: 12)
//                if isSelectable && isSelected {
//                    selectionIndicatorView(index: index, isSelected: isSelected)
//                }
//            }
//            .padding(.horizontal, 30)
//            .padding(.vertical, isActive ? 12 : 8)
//            .background(urgeBackgroundView(isActive: isActive))
//            .scaleEffect(getItemScale(index: index))
//        }
//        .buttonStyle(PlainButtonStyle())
//        .disabled(!isSelectable)
//        .background(geometryReaderView(index: index))
//        .opacity(animateContent ? 1.0 : 0.0)
//        .offset(y: animateContent ? 0 : 40)
//        .animation(.easeOut(duration: 0.7).delay(Double(index) * 0.08), value: animateContent)
//        .animation(.interpolatingSpring(stiffness: 180, damping: 18), value: activeItemIndex)
//    }
//    
//    private func urgeContentView(urge: UrgeItem, index: Int, isActive: Bool) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            titleView(urge: urge, index: index, isActive: isActive)
//            
//            if isActive {
//                descriptionView(urge: urge)
//            }
//        }
//    }
//    
//    private func titleView(urge: UrgeItem, index: Int, isActive: Bool) -> some View {
//        let fontSize: CGFloat = isActive ? 42 : 26
//        let fontWeight: Font.Weight = isActive ? .thin : .ultraLight
//        let tracking: CGFloat = isActive ? -1.0 : -0.2
//        let textColor = getTextColor(for: index)
//        let textOpacity = getTextOpacity(for: index)
//        
//        return Text(urge.title)
//            .font(.system(size: fontSize, weight: fontWeight))
//            .foregroundColor(textColor)
//            .opacity(textOpacity)
//            .multilineTextAlignment(.leading)
//            .tracking(tracking)
//            .lineLimit(nil)
//            .fixedSize(horizontal: false, vertical: true)
//            .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: activeItemIndex)
//            .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: selectedUrges)
//    }
//    
//    private func descriptionView(urge: UrgeItem) -> some View {
//        Text(urge.description)
//            .font(.system(size: 15, weight: .light))
//            .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.3))
//            .opacity(0.9)
//            .multilineTextAlignment(.leading)
//            .lineSpacing(4)
//            .fixedSize(horizontal: false, vertical: true)
//            .transition(.asymmetric(
//                insertion: .scale(scale: 0.95).combined(with: .opacity).animation(.easeOut(duration: 0.3)),
//                removal: .scale(scale: 1.05).combined(with: .opacity).animation(.easeIn(duration: 0.2))
//            ))
//    }
//    
//    private func selectionIndicatorView(index: Int, isSelected: Bool) -> some View {
//        ZStack {
//            let circleColor = isSelected ? Color(red: 0.95, green: 0.95, blue: 0.97) : Color.clear
//            let strokeColor = isSelected ? Color(red: 0.3, green: 0.3, blue: 0.35) : Color(red: 0.8, green: 0.8, blue: 0.82)
//            let strokeWidth: CGFloat = isSelected ? 2 : 1
//            let shadowOpacity: Double = isSelected ? 0.15 : 0.05
//            let shadowRadius: CGFloat = isSelected ? 8 : 4
//            
//            Circle()
//                .fill(circleColor)
//                .frame(width: 36, height: 36)
//                .overlay(
//                    Circle()
//                        .stroke(strokeColor, lineWidth: strokeWidth)
//                )
//                .shadow(color: Color.black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 2)
//            
//            if isSelected {
//                Image(systemName: "checkmark")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//                    .scaleEffect(1.1)
//            }
//        }
//        .scaleEffect(isSelected ? 1.05 : 1.0)
//        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
//    }
//    
//    private func urgeBackgroundView(isActive: Bool) -> some View {
//        RoundedRectangle(cornerRadius: 0)
//            .fill(Color.clear)
//    }
//    
//    private func geometryReaderView(index: Int) -> some View {
//        GeometryReader { geometry in
//            Color.clear
//                .preference(
//                    key: ScrollOffsetPreferenceKey.self,
//                    value: [ScrollOffsetData(index: index, offset: geometry.frame(in: .named("scroll")).midY)]
//                )
//        }
//    }
//    
//    // MARK: - Bottom Section
//    private var bottomSection: some View {
//        HStack {
//            selectionIndicators
//            Spacer()
//            if showContinueButton {
//                startButton
//            }
//        }
//        .padding(.horizontal, 30)
//        .padding(.bottom, 60)
//    }
//    
//    private var selectionIndicators: some View {
//        HStack(spacing: 10) {
//            Text("...")
//                .font(.system(size: 22, weight: .ultraLight))
//                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.65))
//            
//            ForEach(0..<2, id: \.self) { index in
//                let isSelected = index < selectedUrges.count
//                let circleColor = isSelected ? Color(red: 0.3, green: 0.3, blue: 0.35) : Color(red: 0.75, green: 0.75, blue: 0.77)
//                let scaleEffect: CGFloat = isSelected ? 1.3 : 1.0
//                
//                Circle()
//                    .fill(circleColor)
//                    .frame(width: 5, height: 5)
//                    .scaleEffect(scaleEffect)
//                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedUrges.count)
//            }
//        }
//    }
//    
//    private var startButton: some View {
//        Button(action: {
//            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
//            impactFeedback.impactOccurred()
//            // Handle continue
//        }) {
//            HStack(spacing: 10) {
//                Text("start")
//                    .font(.system(size: 17, weight: .medium))
//                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//                
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 13, weight: .semibold))
//                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
//            }
//            .padding(.horizontal, 24)
//            .padding(.vertical, 14)
//            .background(startButtonBackground)
//        }
//        .scaleEffect(showContinueButton ? 1.0 : 0.7)
//        .opacity(showContinueButton ? 1.0 : 0.0)
//        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContinueButton)
//    }
//    
//    private var startButtonBackground: some View {
//        Capsule()
//            .fill(Color(red: 0.96, green: 0.96, blue: 0.97))
//            .overlay(
//                Capsule()
//                    .stroke(Color(red: 0.82, green: 0.82, blue: 0.85), lineWidth: 1.2)
//            )
//            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
//    }
//    
//    // MARK: - Helper Methods
//    private func handleUrgeSelection(index: Int) {
//        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//        impactFeedback.impactOccurred()
//        
//        // Allow selection of any item, not just first 4
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//            if selectedUrges.contains(index) {
//                selectedUrges.remove(index)
//                showContinueButton = false
//            } else if selectedUrges.count < 2 {
//                selectedUrges.insert(index)
//                if selectedUrges.count == 2 {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
//                            showContinueButton = true
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    private func getTextColor(for index: Int) -> Color {
//        if index == activeItemIndex {
//            return selectedUrges.contains(index) ?
//            Color(red: 0.1, green: 0.1, blue: 0.15) :
//            Color(red: 0.15, green: 0.15, blue: 0.2)
//        } else if selectedUrges.contains(index) {
//            return Color(red: 0.25, green: 0.25, blue: 0.3)
//        } else {
//            return Color(red: 0.45, green: 0.45, blue: 0.5)
//        }
//    }
//    
//    private func getTextOpacity(for index: Int) -> Double {
//        if index >= 4 {
//            return index == activeItemIndex ? 0.7 : 0.4
//        } else if index == activeItemIndex {
//            return 1.0
//        } else if selectedUrges.contains(index) {
//            return 0.9
//        } else {
//            let distance = abs(index - activeItemIndex)
//            return distance == 1 ? 0.7 : 0.5
//        }
//    }
//    
//    private func getItemScale(index: Int) -> CGFloat {
//        if index == activeItemIndex {
//            return 1.02
//        } else if abs(index - activeItemIndex) == 1 {
//            return 0.98
//        } else {
//            return 0.95
//        }
//    }
//    
//    private func updateActiveItem(from preferences: [ScrollOffsetData]) {
//        // Target the center of the visible area where we want the active item
//        let targetY: CGFloat = 380
//        
//        // Find the item closest to the target center position
//        let closest = preferences.min { abs($0.offset - targetY) < abs($1.offset - targetY) }
//        
//        if let newActiveIndex = closest?.index, newActiveIndex != activeItemIndex {
//            withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) {
//                activeItemIndex = newActiveIndex
//            }
//            
//            let selectionFeedback = UISelectionFeedbackGenerator()
//            selectionFeedback.selectionChanged()
//        }
//    }
//    
//    private func performAppearAnimations() {
//        withAnimation(.easeOut(duration: 0.6)) {
//            animateContent = true
//        }
//        
//        withAnimation(.easeInOut(duration: 1.2).delay(1.0)) {
//            progressValue = 0.4
//        }
//    }
//}
//
//// MARK: - Supporting Types
//struct UrgeItem {
//    let title: String
//    let description: String
//    let timing: String
//}
//
//struct ScrollOffsetData: Equatable {
//    let index: Int
//    let offset: CGFloat
//    
//    static func == (lhs: ScrollOffsetData, rhs: ScrollOffsetData) -> Bool {
//        return lhs.index == rhs.index && abs(lhs.offset - rhs.offset) < 0.1
//    }
//}
//
//struct ScrollOffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: [ScrollOffsetData] = []
//    
//    static func reduce(value: inout [ScrollOffsetData], nextValue: () -> [ScrollOffsetData]) {
//        value.append(contentsOf: nextValue())
//    }
//}
//
//#Preview {
//    UrgesSelectionView()
//}







//
//
//
//
//  UrgesSelectionView.swift
//  AppUI
//
//  Enhanced version with smooth scrolling - Optimized for compilation
//

import SwiftUI

struct UrgesSelectionView: View {
    @State private var selectedUrges: Set<Int> = []
    @State private var animateContent = false
    @State private var showContinueButton = false
    @State private var activeItemIndex: Int = 0
    
    let urges = [
        UrgeItem(title: "substance use", description: "the desire to use drugs or alcohol to cope with pain", timing: "track patterns • build awareness"),
        UrgeItem(title: "disordered eating", description: "the urge to restrict, binge, or purge food", timing: "mindful eating • body awareness"),
        UrgeItem(title: "shutting down", description: "an urge to shut down emotionally and avoid interaction", timing: "emotional regulation • connection tools"),
        UrgeItem(title: "breaking things", description: "the urge to destroy things when feeling triggered", timing: "anger management • impulse control"),
        UrgeItem(title: "alleviate", description: "reduce feelings of distress and emotional pain", timing: "coping strategies • healing"),
        UrgeItem(title: "anxiety", description: "overwhelming worry and fear responses", timing: "mindfulness • grounding"),
        UrgeItem(title: "awake", description: "difficulty with sleep and rest patterns", timing: "sleep hygiene • relaxation"),
        UrgeItem(title: "sleep", description: "challenges with healthy sleep cycles", timing: "routine • environment"),
        UrgeItem(title: "balance", description: "finding stability in daily life", timing: "wellness • harmony")
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
                    Text("Urges")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("choose 2 to track and heal")
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
                        let isSelected = index < selectedUrges.count
                        let circleColor = isSelected ? Color(red: 0.15, green: 0.15, blue: 0.2) : Color(red: 0.75, green: 0.75, blue: 0.77)
                        let scaleEffect: CGFloat = isSelected ? 1.3 : 1.0
                        
                        Circle()
                            .fill(circleColor)
                            .frame(width: 5, height: 5)
                            .scaleEffect(scaleEffect)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedUrges.count)
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
                    
                    ForEach(Array(urges.enumerated()), id: \.offset) { index, urge in
                        urgeItemView(urge: urge, index: index)
                            .id(index)
                    }
                    
                    Spacer(minLength: 120)
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { preferences in
                updateActiveItem(from: preferences)
            }
        }
    }
    
    private func urgeItemView(urge: UrgeItem, index: Int) -> some View {
        let isActive = index == activeItemIndex
        let isSelected = selectedUrges.contains(index)
        let isSelectable = true // Make all items selectable
        
        return Button(action: {
            handleUrgeSelection(index: index)
        }) {
            HStack(alignment: .top, spacing: 20) {
                urgeContentView(urge: urge, index: index, isActive: isActive)
                Spacer(minLength: 12)
                if isSelectable && isSelected {
                    selectionIndicatorView(index: index, isSelected: isSelected)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, isActive ? 12 : 8)
            .background(urgeBackgroundView(isActive: isActive))
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
    
    private func urgeContentView(urge: UrgeItem, index: Int, isActive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            titleView(urge: urge, index: index, isActive: isActive)
            
            if isActive {
                descriptionView(urge: urge)
            }
        }
    }
    
    private func titleView(urge: UrgeItem, index: Int, isActive: Bool) -> some View {
        let isSelected = selectedUrges.contains(index)
        
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
        
        return Text(urge.title)
            .font(.system(size: fontSize, weight: fontWeight))
            .foregroundColor(textColor)
            .opacity(textOpacity)
            .multilineTextAlignment(.leading)
            .tracking(tracking)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: activeItemIndex)
            .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: selectedUrges)
    }
    
    private func descriptionView(urge: UrgeItem) -> some View {
        Text(urge.description)
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
    
    private func urgeBackgroundView(isActive: Bool) -> some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color.clear)
    }
    
    private func geometryReaderView(index: Int) -> some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: [ScrollOffsetData(index: index, offset: geometry.frame(in: .named("scroll")).midY)]
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
                    // Handle continue
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
    private func handleUrgeSelection(index: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Allow selection of any item, not just first 4
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if selectedUrges.contains(index) {
                selectedUrges.remove(index)
                showContinueButton = false
            } else if selectedUrges.count < 2 {
                selectedUrges.insert(index)
                if selectedUrges.count == 2 {
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
        let isSelected = selectedUrges.contains(index)
        
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
        if index >= 4 {
            return index == activeItemIndex ? 0.7 : 0.4
        } else if index == activeItemIndex {
            return 1.0
        } else if selectedUrges.contains(index) {
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
    
    private func updateActiveItem(from preferences: [ScrollOffsetData]) {
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
struct UrgeItem {
    let title: String
    let description: String
    let timing: String
}

struct ScrollOffsetData: Equatable {
    let index: Int
    let offset: CGFloat
    
    static func == (lhs: ScrollOffsetData, rhs: ScrollOffsetData) -> Bool {
        return lhs.index == rhs.index && abs(lhs.offset - rhs.offset) < 0.1
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [ScrollOffsetData] = []
    
    static func reduce(value: inout [ScrollOffsetData], nextValue: () -> [ScrollOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    UrgesSelectionView()
}
