//
//  RecordSheetView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI
import UniformTypeIdentifiers

struct RecordSheetView: View {
    @State private var showFileImporter = false
    @State private var selectedFileURL: URL?
    @State private var navigateToTranscript = false
    @State private var goToRecordAudio = false
    
    var body: some View {
        VStack(spacing: 18) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            Button(action: {
                goToRecordAudio = true
            }) {
                HStack {
                    Image(systemName: "mic.fill")
                    Text("Record audio")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pigOrange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: {
                showFileImporter = true
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Audio or Video")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.pigOrange, lineWidth: 1.5)
                )
                .foregroundColor(Color.pigOrange)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Tips for better results")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.darkPurple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Ensure the mic is centered if in a room")
                    Text("• Avoid background noise when possible")
                    Text("• Use high-quality audio files for better accuracy")
                }
                .font(.footnote)
                .foregroundColor(.darkGray)
                
                NavigationLink(destination: RecordAudioView(), isActive: $goToRecordAudio) {
                    EmptyView()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            //                   .background(
            //                       RoundedRectangle(cornerRadius: 10)
            //                           .stroke(Color.darkGray, lineWidth: 1.5)
            //                   )
            
            
            
            Spacer()
        }
        .padding()
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [
                UTType.audio,
                UTType.movie,
                UTType(filenameExtension: "wav")!,
                UTType(filenameExtension: "mp4")!,
                UTType(filenameExtension: "m4a")!,
                UTType(filenameExtension: "mp3")!
            ],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let selected = urls.first {
                    selectedFileURL = selected
                    print("Selected file: \(selected.lastPathComponent)")
                    // You can now pass `selectedFileURL` to your processing logic
                }
            case .failure(let error):
                print("File selection error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    RecordSheetView()
}
