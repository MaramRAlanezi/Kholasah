//
//  RecordUploadSheet.swift
//  Kholasah
//
//  Created by Maram Rabeh  on 12/05/2025.
//


import SwiftUICore
import SwiftUI


struct RecordUploadSheet: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer().frame(height: 0)

            Button(action: {
                print("Record tapped")
            }) {
                HStack {
                    Image(systemName: "mic.fill")
                    Text("Record audio")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orrange)
                .cornerRadius(10)
            }

            Button(action: {
                print("Upload tapped")
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Audio or Video")
                }
                .foregroundColor(.orrange)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orrange, lineWidth: 1)
                )
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Tips for better results")
                    .font(.headline)
                    .foregroundColor(.black)

                VStack(alignment: .leading, spacing: 5) {
                    Text("• Ensure the mic is centered if in a room")
                    Text("• Avoid background noise when possible")
                    Text("• Use high-quality audio files for better accuracy")
                }
                .font(.subheadline)
              //  .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )

            Spacer()
        } 
       // .frame(width: 414, height: 303)
        .padding()
        .background(Color.graay)
        .cornerRadius(20)
        .presentationDetents([.height(350)])
        .presentationDragIndicator(.visible)
        
    }
    
}
