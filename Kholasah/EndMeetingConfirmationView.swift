//
//  EndMeetingConfirmationView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 18/11/1446 AH.
//

import SwiftUI

struct EndMeetingConfirmationView: View {
    
    @Binding var isPresented: Bool
    var onConfirm: () -> Void
    @State private var showPopup = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(showPopup ? 0.3 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        dismissPopup()
                    }
                }

            if showPopup {
                popupContent
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation {
                showPopup = true
            }
        }
    }
    
    var popupContent: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        dismissPopup()
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding(4)
                }
                
                .padding(.bottom, 4) // ✅ This gives space below the close button
            }

            Text("Are you sure you want to end the meeting?")
                .multilineTextAlignment(.center)
                .font(.headline)
                .foregroundColor(.navy)
                .padding(.top, -20) // ✅ Adjust this value to move it up slightly

            HStack(spacing: 16) {
                Button(action: {
                    withAnimation {
                        dismissPopup()
                    }
                }) {
                    Text("Cancel")
                        .frame(width: 100, height: 13)
                        .padding()
                        .foregroundColor(.redd)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.redd, lineWidth: 1)
                        )
                }

                Button(action: {
                    onConfirm()
                    withAnimation {
                        dismissPopup()
                    }
                }) {
                    Text("Confirm")
                        .frame(width: 100, height: 13)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.redd)
                        .cornerRadius(10)
                }
            }
            
            .padding()

        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 32)
        
    }

    private func dismissPopup() {
        showPopup = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

#Preview {
    EndMeetingConfirmationView(
        isPresented: .constant(true),
        onConfirm: { print("Confirmed ending meeting") }
    )
}
