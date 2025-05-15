//
//  PDFPreviewView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI
import UIKit
import PDFKit


struct PDFPreviewView: View {
    
    let pdfURL: URL
    @Environment(\.dismiss) var dismiss
    @State private var showShare = false
    
    var body: some View {
        VStack {
                  PDFKitView(url: pdfURL)
              }
              .navigationTitle("Professional Report")
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  Menu {
                      Button("Share as PDF", systemImage: "square.and.arrow.up") {
                          showShare = true
                      }
                      Button("Share as Text", systemImage: "trash", role: .destructive) {
                          dismiss()
                      }
                  } label: {
                      Image(systemName: "ellipsis.circle")
                  }
              }
              .sheet(isPresented: $showShare) {
                  ShareSheet(activityItems: [pdfURL])
              }
    }
}


struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

