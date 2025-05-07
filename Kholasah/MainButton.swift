//
//  MainButton.swift
//  Kholasah
//
//  Created by Reuof on 07/05/2025.
//

import SwiftUI

struct MainButton: View {
    @State private var isAnimating = false
    @State private var scaleInOut = false
    @State private var rotateInOut = false
    @State private var moveInOut = false
    @State private var moveInOut1 = false
    @State private var moveInOut2 = false
    @State private var pulseMic = false
    @State private var gradientColors = false
    @State private var glowing = false
    @State private var wobbleEffect = false
    @State private var showGlitter = false

    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)

            Button(action: {
                isAnimating.toggle()
                scaleInOut = isAnimating
                rotateInOut = isAnimating
                moveInOut = isAnimating
                moveInOut1 = isAnimating
                moveInOut2 = isAnimating
                gradientColors.toggle()
                glowing = isAnimating
                wobbleEffect = isAnimating
                showGlitter = isAnimating
                pulseMic = isAnimating
            }) {
                ZStack {
                    // MARK: - OUTER ANIMATED CIRCLE SETS
                    ZStack {
                        ForEach(0..<3) { i in
                            ZStack {
                                Circle().stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors ? [Color(hex: "#101044"), Color(hex: "#2C2B65").opacity(0.8)] : [Color(hex: "#2C2B65"), Color(hex: "#101044")]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 10
                                )
                                .frame(width: 150, height: 150)
                                .offset(y: moveInOut ? -10 : 0)
                                .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(Double(i) * 0.15), value: moveInOut)

                                Circle().stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors ? [Color(hex: "#5951A3"), Color(hex: "#9856CB").opacity(0.1)] : [Color(hex: "#9856CB"), Color(hex: "#5951A3")]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    ),
                                    lineWidth: 10
                                )
                                .frame(width: 150, height: 150)
                                .offset(y: moveInOut1 ? -10 : 0)
                                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: moveInOut1)

                                Circle().stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors ? [Color(hex: "#242477"), Color(hex: "#6E6E97").opacity(0.1)] : [Color(hex: "#6E6E97"), Color(hex: "#242477")]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 10
                                )
                                .frame(width: 150, height: 150)
                                .offset(y: moveInOut2 ? 10 : 0)
                                .animation(Animation.easeInOut(duration: 1.4).repeatForever(autoreverses: true).delay(Double(i) * 0.45), value: moveInOut2)
                            }
                            .rotationEffect(.degrees(Double(i) * 60))
                            .opacity(0.6)
                        }
                    }
                    .rotationEffect(.degrees(rotateInOut ? 360 : 0))
                    .scaleEffect(scaleInOut ? 1 : 0.7)
                    .animation(isAnimating ?
                        Animation.easeInOut(duration: 2).repeatForever(autoreverses: true) :
                        .default,
                        value: isAnimating
                    )

                    // MARK: - CENTER BUTTON WITH MIC
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .shadow(color: glowing ? Color(hex: "#EB4D44").opacity(0.5) : Color.black.opacity(0.1), radius: glowing ? 20 : 8)
                        .scaleEffect(wobbleEffect ? 1.1 : 1)
                        .animation(wobbleEffect ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: wobbleEffect)
                        .overlay(
                            Circle()
                                .stroke(LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#EB4D44").opacity(0.4), Color(hex: "#EB4D44").opacity(0.6)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ), lineWidth: glowing ? 4 : 0)
                        )
                        .animation(glowing ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: glowing)

                    Image(systemName: "mic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(hex: "#EB4D44"))
                        .opacity(pulseMic ? 0.7 : 1)
                        .animation(pulseMic ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: pulseMic)

                    // MARK: - Glitter Effect
                    if showGlitter {
                        ForEach(0..<30, id: \.self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.6))
                                .frame(width: CGFloat.random(in: 2...5), height: CGFloat.random(in: 2...5))
                                .position(
                                    x: CGFloat.random(in: 50...150) + 50,
                                    y: CGFloat.random(in: 50...150) + 50
                                )
                                .opacity(1)
                                .scaleEffect(1)
                                .transition(.opacity)
                                .animation(
                                    Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double.random(in: 0.1...0.6)),
                                    value: showGlitter
                                )
                        }
                    }
                }
            }
        }
    }
}

// MARK: - HEX COLOR EXTENSION
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//
//        let r, g, b: UInt64
//        switch hex.count {
//        case 6:
//            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
//        default:
//            (r, g, b) = (255, 0, 0)
//        }
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue: Double(b) / 255,
//            opacity: 1
//        )
//    }
//}
