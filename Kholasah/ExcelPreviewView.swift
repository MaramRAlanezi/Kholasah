//
//  ExcelPreviewView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI
import QuickLook


struct ExcelPreviewView: View {
    let fileURL: URL

    @State private var showShareSheet = false
    var body: some View {
        VStack {
            Text("Excel Sheet")
                .font(.title2).bold()
                .padding()

            QuickLookPreview(fileURL: fileURL)
                .frame(height: 400)

            Button(action: {
                showShareSheet = true
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareExcelSheet(activityItems: [fileURL])
        }
        
    }
}

struct QuickLookPreview: UIViewControllerRepresentable {
    let fileURL: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(fileURL: fileURL)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let fileURL: URL

        init(fileURL: URL) {
            self.fileURL = fileURL
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            fileURL as QLPreviewItem
        }
    }
}

struct ShareExcelSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
