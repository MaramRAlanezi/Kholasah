//
//  Untitled.swift
//  Kholasah
//
//  Created by Maram Rabeh  on 12/05/2025.
//

import SwiftUI

struct MainButton: View {
    @State private var showSheet = false

    var body: some View {
        Button(action: {
            showSheet = true
        }) {
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 100, height: 100)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)

                Image(systemName: "mic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $showSheet) {
            RecordUploadSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}


