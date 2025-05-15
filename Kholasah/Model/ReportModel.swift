//
//  ReportModel.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import Foundation

struct MeetingReport {
    let title: String
    let date: Date
    let summary: String
    let keyDecisions: [String]
    let actionItems: [ActionItem]
}

struct ActionItem {
    let task: String
    let owner: String
    let dueDate: String
}

