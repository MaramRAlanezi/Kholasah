//
//  HomePage.swift
//  Kholasah

//  Created by Wejdan Alghamdi on 17/11/1446 AH.


import SwiftUI

struct HomePage: View {
    
    @State private var showSheet = false

    @State private var showMeetingSheet = true
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Mic Button
                Button(action: {
                    showSheet = true
                }) {
                    ZStack {
                        Circle()
                            .stroke(
                                RadialGradient(gradient: Gradient(colors: [Color(hex: "#101044"), Color(hex: "#2C2B65").opacity(0.8)]),center: .center,
                                    startRadius: 5,
                                    endRadius: 100), lineWidth: 10
                            )
                            .frame(width: 160, height: 160)
                        Image(systemName: "mic")
                            .font(.system(size: 40))
                            .foregroundColor(.pigOrange)
                    }
                }
                
                Text("Tap to begin recording your meeting")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer(minLength: 100)
                
                // Meeting history (mock example)
                List {
                    TestHome(title: "Innovation Brainstorm", date: "Jan 28, 2025", time: "11:00 PM", duration: "90 min")
                    TestHome(title: "Mid-Review", date: "Jan 28, 2025", time: "2:00 PM", duration: "60 min")
                    TestHome(title: "Mid-Review", date: "Jan 28, 2025", time: "2:00 PM", duration: "60 min")
                    TestHome(title: "Mid-Review", date: "Jan 28, 2025", time: "2:00 PM", duration: "60 min")
                        }
                        .listStyle(.plain)
            }
            
           // BottomCardSheet(meetings: meetings)
            //.padding(.top)
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("April 30, 2025")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Welcome, \(UserDefaults.standard.string(forKey: "name") ?? "")!")
                        .font(.headline)
                        .foregroundColor(.darkPurple)
                }
            }
            .sheet(isPresented: $showSheet) {
               
                RecordSheetView()
                    .presentationDetents([.height(350)])
                   
                
            }
        }
    }
}



#Preview {
    HomePage()
}
