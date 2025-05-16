//
//  RecordAudioView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI
import SwiftWhisper
import AudioKit
import AVFoundation

struct RecordAudioView: View {
    
    @State private var isAnimating = false
    @State private var scaleInOut = false
    @State private var rotateInOut = false
    @State private var moveInOut = false
    @State private var moveInOut1 = false
    @State private var moveInOut2 = false
    @State private var pulseMic = false
    @State private var gradientColors = false
    @State private var glowing = false
    @State private var wobbleEffect = false
    @State private var showGlitter = false
    
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
            
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            Button(action: {
                isAnimating.toggle()
                scaleInOut = isAnimating
                rotateInOut = isAnimating
                moveInOut = isAnimating
                moveInOut1 = isAnimating
                moveInOut2 = isAnimating
                gradientColors.toggle()
                glowing = isAnimating
                wobbleEffect = isAnimating
                showGlitter = isAnimating
                pulseMic = isAnimating
                isRecording ? stopAndTranscribe() : startRecording()
            }) {
                ZStack {
                    // MARK: - OUTER ANIMATED CIRCLE SETS
                    ZStack {
                        ForEach(0..<3) { i in
                            ZStack {
                                Circle().stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors ? [Color(hex: "#101044"), Color(hex: "#2C2B65").opacity(0.8)] : [Color(hex: "#2C2B65"), Color(hex: "#101044")]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 10
                                )
                                .frame(width: 150, height: 150)
                                .offset(y: moveInOut ? -10 : 0)
                                .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(Double(i) * 0.15), value: moveInOut)
                                
                                Circle().stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors ? [Color(hex: "#5951A3"), Color(hex: "#9856CB").opacity(0.1)] : [Color(hex: "#9856CB"), Color(hex: "#5951A3")]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    ),
                                    lineWidth: 10
                                )
                                .frame(width: 150, height: 150)
                                .offset(y: moveInOut1 ? -10 : 0)
                                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: moveInOut1)
                                
                                Circle().stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors ? [Color(hex: "#242477"), Color(hex: "#6E6E97").opacity(0.1)] : [Color(hex: "#6E6E97"), Color(hex: "#242477")]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 10
                                )
                                .frame(width: 150, height: 150)
                                .offset(y: moveInOut2 ? 10 : 0)
                                .animation(Animation.easeInOut(duration: 1.4).repeatForever(autoreverses: true).delay(Double(i) * 0.45), value: moveInOut2)
                            }
                            .rotationEffect(.degrees(Double(i) * 60))
                            .opacity(0.6)
                        }
                    }
                    .rotationEffect(.degrees(rotateInOut ? 360 : 0))
                    .scaleEffect(scaleInOut ? 1 : 0.7)
                    .animation(isAnimating ?
                               Animation.easeInOut(duration: 2).repeatForever(autoreverses: true) :
                            .default,
                               value: isAnimating
                    )
                    
                    // MARK: - CENTER BUTTON WITH MIC
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .shadow(color: glowing ? Color(hex: "#EB4D44").opacity(0.5) : Color.black.opacity(0.1), radius: glowing ? 20 : 8)
                        .scaleEffect(wobbleEffect ? 1.1 : 1)
                        .animation(wobbleEffect ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: wobbleEffect)
                        .overlay(
                            Circle()
                                .stroke(LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#EB4D44").opacity(0.4), Color(hex: "#EB4D44").opacity(0.6)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ), lineWidth: glowing ? 4 : 0)
                        )
                        .animation(glowing ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: glowing)
                    
                    Image(systemName: "mic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(hex: "#EB4D44"))
                        .opacity(pulseMic ? 0.7 : 1)
                        .animation(pulseMic ? Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: pulseMic)
                    
                    // MARK: - Glitter Effect
                    if showGlitter {
                        ForEach(0..<30, id: \.self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.6))
                                .frame(width: CGFloat.random(in: 2...5), height: CGFloat.random(in: 2...5))
                                .position(
                                    x: CGFloat.random(in: 50...150) + 50,
                                    y: CGFloat.random(in: 50...150) + 50
                                )
                                .opacity(1)
                                .scaleEffect(1)
                                .transition(.opacity)
                                .animation(
                                    Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double.random(in: 0.1...0.6)),
                                    value: showGlitter
                                )
                        }
                    }
                }
            }
            if showTranscriptButton {
                if isProcessingTranscript {
                    ProgressView("Transcribing...")
                        .padding()
                } else {
                    Button("See Transcript") {
                        startTranscription()
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
    RecordAudioView()
}



