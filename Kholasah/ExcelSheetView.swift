//
//  ExcelSheetView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI

struct ExcelSheetView: View {
    
    let tasks: [(task: String, assignee: String?, dueDate: String?, status: String?, comments: String?)]
    let fileURL: URL
    @State private var showShareSheet = false

    let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 100)), count: 5)
    
    var body: some View {
        VStack {
        Text("Excel Sheet")
        .foregroundColor(Color.darkPurple)
        .font(.title2).bold()
        .padding(.top)

        ScrollView([.horizontal, .vertical]) {
        LazyVGrid(columns: columns, spacing: 12) {
        headerCell("Task")
        headerCell("Assignee")
        headerCell("Due Date")
        headerCell("Status")
        headerCell("Comments")

        ForEach(tasks, id: \.task) { task in
        dataCell(task.task)
        dataCell(task.assignee)
        dataCell(task.dueDate)
        dataCell(task.status)
        dataCell(task.comments)
        }
        }
        .padding()
        }

        Button(action: {
        showShareSheet = true
        }) {
        Image(systemName: "square.and.arrow.up")
        .font(.title2)
        .padding()
        .background(Color.darkPurple)
        .foregroundColor(.white)
        .clipShape(Circle())
        .shadow(radius: 3)
        }
        }
        .sheet(isPresented: $showShareSheet) {
        ShareExcelSheet(activityItems: [fileURL])
        }
    }
    
    // MARK: - Helpers

    func headerCell(_ title: String) -> some View {
    Text(title)
    .bold()
    .frame(minWidth: 100)
    .padding(6)
    .background(Color.gray.opacity(0.2))
    .cornerRadius(6)
    }

    func dataCell(_ content: String?) -> some View {
    Text(content ?? "-")
    .frame(minWidth: 100)
    .padding(4)
    .background(Color.white)
    .cornerRadius(4)
    .border(Color.gray.opacity(0.3), width: 0.5)
    }
    
}


