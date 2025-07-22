//
//  ModernUIView.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 7/15/25.
//


import SwiftUI

// MARK: - Main View
struct ModernUIView: View {
    @State private var selectedCard: Int? = nil
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                
                // Color System Card (Wide)
                ModernCard(backgroundColor: .white) {
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 64, height: 64)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 32, height: 32)
                            )
                        
                        VStack(spacing: 4) {
                            Text("Color")
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundColor(.primary)
                            
                            Text("User Manual")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .gridCellColumns(2)
                
                // 3D Sphere Card
                ModernCard {
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [
                                        Color.blue.opacity(0.1),
                                        Color.purple.opacity(0.1),
                                        Color.pink.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 48, height: 48)
                            
                            Circle()
                                .fill(Color.white.opacity(0.6))
                                .frame(width: 12, height: 12)
                                .offset(x: 15, y: -15)
                        }
                        
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 32)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.05))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                
                // Start Button Card
                ModernCard {
                    VStack(spacing: 16) {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 96, height: 96)
                            .overlay(
                                Text("START")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            )
                        
                        Text("Flow state helps you\nfind unfinished elements\ntowards your tasks.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                    .padding(.vertical, 12)
                }
                
                // Object Card
                ModernCard {
                    VStack(alignment: .trailing, spacing: 16) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("OBJECT")
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(.primary)
                            
                            Text("2021 06")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 120)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 64, height: 64)
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            )
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 60, height: 8)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Conversation Card (Wide with Glassmorphism)
                GlassmorphCard {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Hello Chris,")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            Text("What are\nyou doing?")
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                        
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 32, height: 32)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.05))
                                .frame(width: 32, height: 32)
                            
                            Spacer()
                        }
                    }
                }
                .gridCellColumns(2)
                
                // Weight Goal Card
                ModernCard(backgroundColor: Color.gray.opacity(0.03)) {
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .padding(8)
                                    .overlay(
                                        VStack(spacing: 12) {
                                            HStack {
                                                Button("←") {
                                                    // Back action
                                                }
                                                .foregroundColor(.secondary)
                                                
                                                Spacer()
                                            }
                                            
                                            Text("What is your\nweight goal?")
                                                .font(.system(size: 16, weight: .medium))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.primary)
                                            
                                            HStack(alignment: .bottom, spacing: 2) {
                                                Text("70")
                                                    .font(.title2)
                                                    .fontWeight(.light)
                                                Text("kg")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Circle()
                                                    .fill(Color.primary)
                                                    .frame(width: 4, height: 4)
                                                Circle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 4, height: 4)
                                                Circle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 4, height: 4)
                                            }
                                            
                                            Button("Continue") {
                                                // Continue action
                                            }
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                        .padding(12)
                                    )
                            )
                            .frame(height: 180)
                        
                        Text("uimotionkit.io")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(20)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
    }
}

// MARK: - Modern Card Component
struct ModernCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    
    init(backgroundColor: Color = .white, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(24)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 8)
            .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Glassmorphism Card
struct GlassmorphCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 8)
    }
}

// MARK: - Custom Modifiers
extension View {
    func modernCardStyle() -> some View {
        self
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 8)
            .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
    }
    
    func glassmorphismEffect() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
}

// MARK: - Preview
struct ModernUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ModernUIView()
        }
    }
}
