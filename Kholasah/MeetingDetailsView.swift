//
//  MeetingDetailsView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 08/11/1446 AH.
//

import SwiftUI

struct MeetingDetailsView: View {
    
    @State private var selectedTab = "Transcript"
        
    let tabs = ["Transcript", "Summary", "Report"]
    let transcript: String
    
    var body: some View {
        
        VStack(spacing: 16) {
                    // Title
                    Text("Software Development")
                        .font(.title2).bold()
                        .foregroundColor(Color.darkPurple)
                        .padding(.top)
                    
                    // Waveform placeholder
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Playback controls
                    HStack(spacing: 40) {
                        Image(systemName: "gobackward.15")
                        Image(systemName: "pause.fill")
                        Image(systemName: "goforward.15")
                    }
                    .font(.title2)
                    .foregroundColor(.pigOrange)
                    
                    // Tabs
                    HStack {
                        ForEach(tabs, id: \.self) { tab in
                            VStack {
                                Text(tab)
                                    .fontWeight(tab == selectedTab ? .bold : .regular)
                                    .foregroundColor(tab == selectedTab ? .darkPurple : .gray)
                                if tab == selectedTab {
                                    Rectangle()
                                        .frame(height: 4)
                                        .foregroundColor(.pigOrange)
                                } else {
                                    Color.clear.frame(height: 2)
                                }
                            }
                            .onTapGesture {
                                selectedTab = tab
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Scrollable transcript
                    ScrollView {
                            switch selectedTab {
                            case "Transcript":
                                transcriptView
                            case "Summary":
                                summaryView
                            case "Report":
                                reportView
                            default:
                                EmptyView()
                            }
                        }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(radius: 2)
                    
                    Spacer()
                }
                .padding(.bottom)
                .background(Color(.white))
        
    }
    var transcriptView: some View {
           Text(transcript)
           .padding()
       }
    
    var summaryView: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Meeting Importance Highlights:")
                    .font(.headline)
                
                Group {
                    Text("• **Key Decisions Made:** Proceed with current sprint scope (user profile, dashboard, voice support).")
                    Text("• **Tasks Assigned:**")
                    Text("   – Backend to finalize PATCH method by Thursday.")
                    Text("   – Frontend to fix Safari layout issue and adjust logout session timing.")
                }
                
                Divider()
                
                Text("Main Focus: Completing the user profile feature.")
                    .fontWeight(.semibold)
                
                Text("• **Product Update:**\n   – Good progress on user profile.\n   – Design team finalized mockups.\n   – Mockups will be uploaded to Figma after the call.")
                
                Text("• **Backend Update:**\n   – Database schema updated.\n   – API endpoints are live in staging.\n   – PATCH method is being tested (done by Thursday).")
                
                Text("• **Blockers:**\n   – Waiting for API keys from third-party verification service.")
            }
            .font(.subheadline)
            .foregroundColor(.black)
            .padding()
        }
    
    var reportView: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Choose the report form")
                    .font(.headline)
                    .foregroundColor(Color.darkPurple)
                
                VStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(Color.darkPurple)
                            Text("Professional Report")
                                .fontWeight(.medium)
                                .foregroundColor(Color.darkPurple)
                                
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.darkPurple, lineWidth: 1)
                        )
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "tablecells")
                                .foregroundColor(Color.darkPurple)
                            Text("Excel Sheet")
                                .fontWeight(.medium)
                                .foregroundColor(Color.darkPurple)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.darkPurple, lineWidth: 1)
                        )
                    }
                }
            }
            .padding()
        }
    
}

#Preview {
    MeetingDetailsView()
}
