//
//  TestHome.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI

struct TestHome: View {
    let title: String
       let date: String
       let time: String
       let duration: String

       var body: some View {
           VStack(alignment: .leading, spacing: 6) {
               Text(title)
                   .font(.headline)
                   .foregroundColor(.darkPurple)

               HStack {
                   Label(date, systemImage: "calendar")
                   Label(time, systemImage: "clock")
                   Spacer()
                   Text(duration)
                       .font(.footnote)
                       .foregroundColor(.gray)
               }
               .font(.footnote)
               .foregroundColor(.gray)
           }
           .padding()
           .background(Color(.systemGray6))
           .cornerRadius(12)
           .swipeActions(edge: .trailing, allowsFullSwipe: false) {
               Button {
                   print("Edit tapped")
               } label: {
                   Label("Edit Name", systemImage: "pencil")
               }
               .tint(.gray)

               Button(role: .destructive) {
                   print("Delete tapped")
               } label: {
                   Label("Delete", systemImage: "trash")
               }
           }
       }
}


