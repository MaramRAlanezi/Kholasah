
//  ContentView.swift
//  Kholasah
//
//  Created by Maram Rabeh  on 24/04/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var audioRecorder: AudioRecorder

    @State private var isAnimating = false
    @State private var scaleInOut = false
    @State private var rotateInOut = false
    @State private var gradientColors = false
    @State private var showGlitter = false

    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)

            VStack {
                RecordingsList(audioRecorder: audioRecorder)

                ZStack {
                    // This outer ZStack fixes the layout size and centers the button
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

                                    Circle().stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: gradientColors ? [Color(hex: "#5951A3"), Color(hex: "#9856CB").opacity(0.1)] : [Color(hex: "#9856CB"), Color(hex: "#5951A3")]),
                                            startPoint: .bottom,
                                            endPoint: .top
                                        ),
                                        lineWidth: 10
                                    )
                                    .frame(width: 150, height: 150)

                                    Circle().stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: gradientColors ? [Color(hex: "#242477"), Color(hex: "#6E6E97").opacity(0.1)] : [Color(hex: "#6E6E97"), Color(hex: "#242477")]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 10
                                    )
                                    .frame(width: 150, height: 150)
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

                        // MARK: - STATIC CENTER BUTTON
                        Button(action: {
                            if audioRecorder.recording {
                                audioRecorder.stopRecording()
                            } else {
                                audioRecorder.startRecording()
                            }

                            isAnimating.toggle()
                            scaleInOut = isAnimating
                            rotateInOut = isAnimating
                            gradientColors.toggle()
                            showGlitter = isAnimating
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.black.opacity(0.1), radius: 8)

                                Image(systemName: "mic")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(hex: "#EB4D44"))
                            }
                        }
                        .frame(width: 150, height: 150) // Fixed layout to prevent shifting

                        // MARK: - Glitter Effect (isolated using overlay)
                        if showGlitter {
                            GeometryReader { geometry in
                                ZStack {
                                    ForEach(0..<30, id: \.self) { _ in
                                        Circle()
                                            .fill(Color.white.opacity(0.6))
                                            .frame(width: CGFloat.random(in: 2...5), height: CGFloat.random(in: 2...5))
                                            .position(
                                                x: CGFloat.random(in: 0...geometry.size.width),
                                                y: CGFloat.random(in: 0...geometry.size.height)
                                            )
                                            .animation(
                                                Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double.random(in: 0.1...0.6)),
                                                value: showGlitter
                                            )
                                    }
                                }
                            }
                            .frame(width: 150, height: 150)
                            .clipped()
                        }
                    }
                    .frame(width: 200, height: 200) // Keeps entire control area consistent
                }
                .padding(.top, 40)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}

// MARK: - HEX COLOR EXTENSION
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (255, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
