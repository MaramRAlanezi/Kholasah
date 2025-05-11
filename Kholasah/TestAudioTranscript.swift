//
//  TestAudioTranscript.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 13/11/1446 AH.
//

import SwiftUI
import SwiftWhisper
import AudioKit
import AVFoundation


struct TestAudioTranscript: View {
    
    @StateObject private var recorder = AudioRecorder()
    @State private var transcript = ""
    @State private var isRecording = false
    @State private var whisper: Whisper?
    @State private var navigateToTranscript = false
    @State private var showTranscriptButton = false
    @State private var isProcessingTranscript = false
    @State private var audioToTranscribeURL: URL?
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Text("Arabic + English Transcription")
                    .font(.title2)
                    .bold()
              
                Button(action: {
                    isRecording ? stopAndTranscribe() : startRecording()
                }) {
                    Label(isRecording ? "Stop Recording" : "Start Recording", systemImage: isRecording ? "stop.circle" : "mic.circle")
                        .font(.title2)
                        .padding()
                        .background(isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if showTranscriptButton {
                    if isProcessingTranscript {
                        ProgressView("Transcribing...")
                            .padding()
                    } else {
                        Button("See Transcript") {
                            startTranscription() // 👈 This now runs transcription
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                }
                
                    NavigationLink(destination: MeetingDetailsView(transcript: transcript),isActive: $navigateToTranscript) {
                                       EmptyView()
                                   }
                
            }
            .padding()
            .onAppear {
                loadModel()
            }
        }
    }

    func loadModel() {
        if let url = Bundle.main.url(forResource: "ggml-small", withExtension: "bin") {
            whisper = try? Whisper(fromFileURL: url)
        }
    }

    func startRecording() {
        recorder.startRecording()
        isRecording = true
    }

    func stopAndTranscribe() {
        recorder.stopRecording { url in
            guard let url = url else { return }
            audioToTranscribeURL = url
            showTranscriptButton = true
        }
        isRecording = false
    }
    
    func startTranscription() {
        guard let url = audioToTranscribeURL else { return }
        isProcessingTranscript = true

        convertAudioFileToPCMArray(fileURL: url) { result in
            switch result {
            case .success(let audioFrames):
                guard let whisper = whisper else {
                    transcript = "Whisper model not loaded"
                    return
                }
                Task {
                    do {
                        let segments = try await whisper.transcribe(audioFrames: audioFrames)
                        transcript = segments.map(\.text).joined(separator: " ")
                        isProcessingTranscript = false
                        navigateToTranscript = true // ✅ Go to result view
                    } catch {
                        isProcessingTranscript = false
                        transcript = "Transcription error: \(error.localizedDescription)"
                    }
                }

            case .failure(let error):
                isProcessingTranscript = false
                transcript = "Audio conversion error: \(error.localizedDescription)"
            }
        }
    }

    func transcribeAudio(fileURL: URL) {
        convertAudioFileToPCMArray(fileURL: fileURL) { result in
            switch result {
            case .success(let audioFrames):
                guard let whisper = whisper else {
                    transcript = "Whisper model not loaded"
                    return
                }
                Task {
                    do {
                        let segments = try await whisper.transcribe(audioFrames: audioFrames)
                        transcript = segments.map(\.text).joined(separator: " ")
                    } catch {
                        transcript = "Transcription error: \(error.localizedDescription)"
                    }
                }

            case .failure(let error):
                transcript = "Audio conversion error: \(error.localizedDescription)"
            }
        }
    }

    func convertAudioFileToPCMArray(fileURL: URL, completionHandler: @escaping (Result<[Float], Error>) -> Void) {
        var options = FormatConverter.Options()
        options.format = .wav
        options.sampleRate = 16000
        options.bitDepth = 16
        options.channels = 1
        options.isInterleaved = false

        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        let converter = FormatConverter(inputURL: fileURL, outputURL: tempURL, options: options)
        converter.start { error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            do {
                let data = try Data(contentsOf: tempURL)
                let floats = stride(from: 44, to: data.count, by: 2).map {
                    data[$0..<$0 + 2].withUnsafeBytes {
                        let short = Int16(littleEndian: $0.load(as: Int16.self))
                        return max(-1.0, min(Float(short) / 32767.0, 1.0))
                    }
                }
                try FileManager.default.removeItem(at: tempURL)
                completionHandler(.success(floats))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}

#Preview {
    TestAudioTranscript()
}
