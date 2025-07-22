//
//  ElegantCard.swift
//  AppUI
//
//  Reusable elegant card component with glassmorphism styling
//

import SwiftUI

struct ElegantCard<Content: View>: View {
    let content: Content
    var horizontalPadding: CGFloat = 24
    var verticalPadding: CGFloat = 28
    var cornerRadius: CGFloat = 24
    var shadowRadius: CGFloat = 12
    var shadowOffset: CGSize = CGSize(width: 0, height: 6)
    
    init(
        horizontalPadding: CGFloat = 24,
        verticalPadding: CGFloat = 28,
        cornerRadius: CGFloat = 24,
        shadowRadius: CGFloat = 12,
        shadowOffset: CGSize = CGSize(width: 0, height: 6),
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.7))
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.98, green: 0.99, blue: 1.0),
                                        Color(red: 0.96, green: 0.97, blue: 0.99)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(
                        color: Color(red: 0.85, green: 0.87, blue: 0.92).opacity(0.4),
                        radius: shadowRadius,
                        x: shadowOffset.width,
                        y: shadowOffset.height
                    )
            )
    }
}

// MARK: - Convenience Components

struct CircleIndicator: View {
    let fillColor: Color
    let strokeColors: [Color]
    let size: CGFloat
    let dotSize: CGFloat
    
    init(
        fillColor: Color = Color(red: 0.91, green: 0.93, blue: 0.96),
        strokeColors: [Color] = [
            Color(red: 0.88, green: 0.9, blue: 0.94),
            Color(red: 0.82, green: 0.85, blue: 0.92)
        ],
        size: CGFloat = 36,
        dotSize: CGFloat = 10
    ) {
        self.fillColor = fillColor
        self.strokeColors = strokeColors
        self.size = size
        self.dotSize = dotSize
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: strokeColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: size, height: size)
            
            Circle()
                .fill(fillColor)
                .frame(width: dotSize, height: dotSize)
        }
    }
}

struct ChartIndicator: View {
    let gradientColors: [Color]
    let size: CGSize
    let barCount: Int
    let barWidth: CGFloat
    let barHeight: CGFloat
    
    init(
        gradientColors: [Color] = [
            Color(red: 0.90, green: 0.92, blue: 0.95),
            Color(red: 0.85, green: 0.88, blue: 0.93)
        ],
        size: CGSize = CGSize(width: 36, height: 24),
        barCount: Int = 3,
        barWidth: CGFloat = 6,
        barHeight: CGFloat = 10
    ) {
        self.gradientColors = gradientColors
        self.size = size
        self.barCount = barCount
        self.barWidth = barWidth
        self.barHeight = barHeight
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size.width, height: size.height)
            .overlay(
                HStack(spacing: 3) {
                    ForEach(0..<barCount, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.white.opacity(0.8))
                            .frame(width: barWidth, height: barHeight)
                    }
                }
            )
    }
}

struct IndicatorItem: View {
    let icon: AnyView
    let title: String
    let titleColor: Color
    let spacing: CGFloat
    
    init<Icon: View>(
        icon: Icon,
        title: String,
        titleColor: Color = Color(red: 0.45, green: 0.45, blue: 0.5),
        spacing: CGFloat = 12
    ) {
        self.icon = AnyView(icon)
        self.title = title
        self.titleColor = titleColor
        self.spacing = spacing
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            icon
            
            Text(title)
                .font(.system(size: 11, weight: .light))
                .foregroundColor(titleColor)
                .tracking(0.4)
        }
    }
}

// MARK: - Usage Examples

struct FocusInsightsCard: View {
    var body: some View {
        ElegantCard {
            HStack(spacing: 20) {
                IndicatorItem(
                    icon: CircleIndicator(),
                    title: "focus"
                )
                
                Spacer()
                
                IndicatorItem(
                    icon: ChartIndicator(),
                    title: "insights"
                )
            }
        }
    }
}

// MARK: - Previews

#Preview("Elegant Card with Content") {
    VStack(spacing: 20) {
        FocusInsightsCard()
        
        ElegantCard {
            VStack {
                Text("Custom Content")
                    .font(.headline)
                Text("This is a custom card")
                    .font(.caption)
            }
        }
        
        ElegantCard(
            horizontalPadding: 16,
            verticalPadding: 20,
            cornerRadius: 16
        ) {
            HStack {
                Text("Compact Card")
                Spacer()
                Image(systemName: "star.fill")
            }
        }
    }
    .padding()
    .background(Color(red: 0.96, green: 0.965, blue: 0.985))
}
