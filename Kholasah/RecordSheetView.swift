//
//  RecordSheetView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI

struct RecordSheetView: View {
    var body: some View {
        VStack(spacing: 18) {
                   Capsule()
                       .fill(Color.gray.opacity(0.3))
                       .frame(width: 40, height: 5)
                       .padding(.top, 8)

                   Button(action: {
                       print("Record Audio tapped")
                   }) {
                       HStack {
                           Image(systemName: "mic.fill")
                           Text("Record audio")
                               .bold()
                       }
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.pigOrange)
                       .foregroundColor(.white)
                       .cornerRadius(10)
                   }

                   Button(action: {
                       print("Upload tapped")
                   }) {
                       HStack {
                           Image(systemName: "arrow.up.doc")
                           Text("Upload Audio or Video")
                               .bold()
                       }
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(
                           RoundedRectangle(cornerRadius: 10)
                               .stroke(Color.pigOrange, lineWidth: 1.5)
                       )
                       .foregroundColor(Color.pigOrange)
                   }

                   VStack(alignment: .leading, spacing: 6) {
                       Text("Tips for better results")
                           .font(.headline)
                           .bold()
                           .foregroundColor(.darkPurple)

                       VStack(alignment: .leading, spacing: 4) {
                           Text("• Ensure the mic is centered if in a room")
                           Text("• Avoid background noise when possible")
                           Text("• Use high-quality audio files for better accuracy")
                       }
                       .font(.footnote)
                       .foregroundColor(.darkGray)
                   }
                   .padding()
                   .frame(maxWidth: .infinity)
                   .background(Color(.systemGray6))
                   .cornerRadius(12)
//                   .background(
//                       RoundedRectangle(cornerRadius: 10)
//                           .stroke(Color.darkGray, lineWidth: 1.5)
//                   )
                   
                   

                   Spacer()
               }
               .padding()
    }
}

#Preview {
    RecordSheetView()
}
