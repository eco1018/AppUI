//
//  AgeSelectionView.swift
//  AppUI
//
//
//  AgeSelectionView.swift
//  AppUI
//
//  Age selection with slider interface
//

import SwiftUI

struct AgeSelectionView: View {
    @State private var selectedAge: Double = 25
    @State private var animateContent = false
    @State private var showContinueButton = true
    
    let minAge: Double = 13
    let maxAge: Double = 80
    
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
                Spacer()
                ageSelectionContent
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
                    Text("Age")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .tracking(-1)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
                    
                    Spacer()
                }
                
                HStack {
                    Text("how old are you?")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Age Selection Content
    private var ageSelectionContent: some View {
        VStack(spacing: 40) {
            // Current age display
            VStack(spacing: 8) {
                Text("\(Int(selectedAge))")
                    .font(.system(size: 64, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .opacity(animateContent ? 1.0 : 0.0)
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                
                Text("years old")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .opacity(animateContent ? 0.8 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            }
            
            // Custom slider with curved line effect
            VStack(spacing: 20) {
                VStack(spacing: 8) { // Reduced spacing to bring circle closer to line
                    // Curved track that creates a mound at the current position
                    ZStack {
                        // Curved line that creates the mound effect (no background line)
                        CurvedSliderShape(progress: CGFloat((selectedAge - minAge) / (maxAge - minAge)))
                            .stroke(Color(red: 0.15, green: 0.15, blue: 0.2), lineWidth: 2.5)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8).delay(1.0), value: animateContent)
                            .animation(.easeInOut(duration: 0.3), value: selectedAge)
                    }
                    .frame(height: 30) // Increased height to accommodate the curve
                    
                    // Slider thumb positioned below the track
                    HStack {
                        Spacer()
                            .frame(width: sliderWidth * CGFloat((selectedAge - minAge) / (maxAge - minAge)) - 12)
                        
                        Circle()
                            .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                            .frame(width: 20, height: 20)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .scaleEffect(animateContent ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(1.2), value: animateContent)
                        
                        Spacer()
                    }
                }
                .frame(height: 50)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newValue = min(max(minAge, minAge + (maxAge - minAge) * Double(value.location.x / sliderWidth)), maxAge)
                            selectedAge = newValue
                            
                            // Haptic feedback on value change
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                )
            }
            .padding(.horizontal, 0) // No padding - full edge-to-edge
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
                    Text("continue")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        .tracking(-0.3)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.8)
                .animation(.easeOut(duration: 0.6).delay(1.6), value: animateContent)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Properties
    private var sliderWidth: CGFloat {
        UIScreen.main.bounds.width // Full screen width, no padding
    }
    
    private func performAppearAnimations() {
        withAnimation(.easeOut(duration: 0.6)) {
            animateContent = true
        }
    }
}

// MARK: - Custom Curved Slider Shape
struct CurvedSliderShape: Shape {
    let progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerY = height / 2
        let peakHeight: CGFloat = 10 // Reduced height of the curve peak
        let curveWidth: CGFloat = width * 0.3 // Width of the curve area
        
        // Calculate the X position of the peak based on progress
        let peakX = width * progress
        
        // Start from the left
        path.move(to: CGPoint(x: 0, y: centerY))
        
        // Create points for the curve
        let numPoints = 100
        for i in 0...numPoints {
            let x = (CGFloat(i) / CGFloat(numPoints)) * width
            
            // Calculate the curve effect - creates a bell curve centered at peakX
            let distanceFromPeak = abs(x - peakX)
            let normalizedDistance = min(distanceFromPeak / (curveWidth / 2), 1.0)
            
            // Use a smooth curve function (inverted cosine for bell shape)
            let curveEffect = cos(normalizedDistance * .pi / 2)
            let y = centerY - (peakHeight * max(0, curveEffect))
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

#Preview {
    AgeSelectionView()
}
