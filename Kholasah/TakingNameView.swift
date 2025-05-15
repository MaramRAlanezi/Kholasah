//
//  TakingNameView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI

struct TakingNameView: View {
    var body: some View {
        Text("Welcome \(UserDefaults.standard.string(forKey: "name") ?? "")!")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    TakingNameView()
}
