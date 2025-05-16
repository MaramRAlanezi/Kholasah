
//  AudioRecorder.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.

import AudioKit
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    private var recorder: AVAudioRecorder?
    var audioURL: URL?

    func startRecording() {
        let filename = "recording.wav"
        audioURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false
        ]

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .default)
            try session.setActive(true)

            recorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            recorder?.record()
        } catch {
            print("Recording error: \(error.localizedDescription)")
        }
    }

    func stopRecording(completion: @escaping (URL?) -> Void) {
        recorder?.stop()
        completion(audioURL)
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

