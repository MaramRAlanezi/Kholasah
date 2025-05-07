//
//  HomeView.swift
//  onboarding
//
//  Created by Razan on 03/11/1446 AH.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Welcome \(UserDefaults.standard.string(forKey: "name") ?? "")!")
            .font(.largeTitle)
            .padding()
    }
}
