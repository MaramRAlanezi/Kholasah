//
//  MeetingCardView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 18/11/1446 AH.
//

import SwiftUI

struct MeetingCardView: View {
    
    let meeting: Meeting
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(meeting.title)
                    .font(.headline)
                    .foregroundColor(Color("navy"))
                
                Spacer()
                
                Menu {
                    Button {
                        onEdit()
                    } label: {
                        Label("Edit Name", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            
            .padding(.bottom, 20)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Label(meeting.date, systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Label(meeting.time, systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
                
                Spacer()
                
                Text(meeting.duration)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    MeetingCardView(
        meeting: Meeting(
            title: "Innovation Brainstorm",
            date: "Jan 28, 2025",
            time: "11:00 PM",
            duration: "90 min"
        ),
        onEdit: {},
        onDelete: {}
    )
}
