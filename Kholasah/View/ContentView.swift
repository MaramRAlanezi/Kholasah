//
//  ContentView.swift
//  Kholasah
//
//  Created by Maram Rabeh  on 24/04/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showPremiumSheet = false
    
    @State private var showConfirmation = false
    
    @State private var showConfirmation2 = false
    

    
    var body: some View {
        
        
        /// Premium Plan Sheet
        VStack {
            Button("Show Premium Plan") {
                showPremiumSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        
        /// End Meeting Pop up
        ZStack {
            Button("End Meeting") {
                showConfirmation = true
            }
            
            .buttonStyle(.borderedProminent)
            

            if showConfirmation {
                EndMeetingConfirmationView(isPresented: $showConfirmation) {
                    print("Meeting ended")
                }
            }
        }
        
        .padding()
        
        /// Delete Record Pop up
        ZStack {
            Button("", systemImage: "xmark") {
                showConfirmation2 = true
            }
            
            if showConfirmation2 {
                DeleteRecordConfirmation(isPresented: $showConfirmation2) {
                    print("Delete Record")
                }
            }
        }

        
        
        .sheet(isPresented: $showPremiumSheet) {
            PremiumPlanView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
}

#Preview {
    ContentView()
}
