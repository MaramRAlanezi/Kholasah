//
//  MeetingListView.swift
//  Kholasah
//
//  Created by Shaden Alhumood on 09/11/1446 AH.
//

import SwiftUI

struct MeetingListView: View {
    @StateObject private var viewModel = MeetingViewModel()
    @State private var editingMeeting: Meeting?
    @State private var newTitle: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.meetings) { meeting in
                        MeetingCardView(
                            meeting: meeting,
                            onEdit: {
                                editingMeeting = meeting
                                newTitle = meeting.title
                            },
                            onDelete: {
                                viewModel.delete(meeting: meeting)
                            }
                        )
                    }
                }
                .padding()
            }
            .sheet(item: $editingMeeting) { meeting in
                EditMeetingSheet(
                    newTitle: $newTitle,
                    onSave: {
                        viewModel.updateTitle(for: meeting, newTitle: newTitle)
                        editingMeeting = nil
                    },
                    onCancel: {
                        editingMeeting = nil
                    }
                )
            }
        }
    }
}


#Preview {
    MeetingListView()
}
