//
//  EditMeetingName.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 18/11/1446 AH.
//

import SwiftUI

struct EditMeetingName: View {
    
    @Binding var newTitle: String
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Meeting Title")) {
                    TextField("New Title", text: $newTitle)
                }
            }
            .navigationBarTitle("Edit Name", displayMode: .inline)
            .navigationBarItems(
                leading: Button( action: onCancel){
                    Text("Cancel")
                        .foregroundColor(.gray)
                },
                trailing: Button(action: {
                    onSave()
                }) {
                    Text("Save")
                        .foregroundColor(.redd) // 🔴 Always red
                }
                    .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(newTitle.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0) // 👁️‍🗨️ Fade if disabled

            )
        }
    }
}

#Preview {
    EditMeetingName(
        EditMeetingName(
            newTitle: .constant("Design Review"),
            onSave: {},
            onCancel: {}
        )
    )
}
