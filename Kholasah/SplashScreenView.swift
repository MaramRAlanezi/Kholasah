//
//  SplashScreenView.swift
//  Kholasah
//
//  Created by Maram Rabeh  on 13/05/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                ZStack {

                    HStack {
                        Spacer()
                        Dots()
                            .offset(y: 20)
                            .offset(x: -50)
                    }

                    VStack(spacing: 0) {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .offset(y: -30)
                            .offset(x: 40)

                    }
                }

                Spacer()
            }
        }
    }
}

struct Dots: View {
    @State private var activeIndex = 0
    let totalDots = 3
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(0..<totalDots), id: \.self) { index in
                Circle()
                    .frame(width: 12, height: 12)
                    .scaleEffect(activeIndex == index ? 1.4 : 1)
                    .foregroundColor(activeIndex == index ? Color(hex: "EB4D44") : Color(hex: "1C1C69"))
                    .animation(.easeInOut(duration: 0.3), value: activeIndex)
            }
        }
        .onReceive(timer) { _ in
            activeIndex = (activeIndex + 1) % totalDots
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255,
                           (int >> 8) * 17,
                           (int >> 4 & 0xF) * 17,
                           (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255,
                           int >> 16,
                           int >> 8 & 0xFF,
                           int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24,
                           int >> 16 & 0xFF,
                           int >> 8 & 0xFF,
                           int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
