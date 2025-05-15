//
//  MeetingViewModel.swift
//  Kholasah
//
//  Created by Shaden Alhumood on 09/11/1446 AH.
//

import Foundation
import SwiftUI

class MeetingViewModel: ObservableObject {
    @Published var meetings: [Meeting] = [
        .init(title: "Innovation Brainstorm", date: "Jan 28, 2025", time: "11:00 PM", duration: "90 min"),
        .init(title: "Mid-Review", date: "Jan 28, 2025", time: "11:00 PM", duration: "90 min"),
        .init(title: "Business Model Review", date: "Jan 28, 2025", time: "11:00 PM", duration: "90 min"),
        .init(title: "Design Review", date: "Jan 28, 2025", time: "11:00 PM", duration: "90 min"),
        .init(title: "Payments Gateway", date: "Jan 28, 2025", time: "11:00 PM", duration: "90 min"),
        .init(title: "DataSchema Review", date: "Jan 28, 2025", time: "11:00 PM", duration: "90 min")
    ]
    
    func delete(meeting: Meeting) {
        meetings.removeAll { $0 == meeting }
    }
    
    func updateTitle(for meeting: Meeting, newTitle: String) {
        if let index = meetings.firstIndex(of: meeting) {
            meetings[index].title = newTitle
        }
    }
}


