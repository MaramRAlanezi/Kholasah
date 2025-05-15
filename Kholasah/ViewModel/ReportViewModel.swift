//
//  ReportViewModel.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//
import SwiftUI
import Combine

public class ReportViewModel: ObservableObject {
    @Published var reports: MeetingReport = .init(title: "", date: Date(), summary: "", keyDecisions: [], actionItems: [])
    @Published var navigateToPDF = false
    @Published var generatedPDFURL: URL?
    
    func generatePDF() {
        let report = MeetingReport(
            title: "Weekly Software Development Sync",
            date: Date(),
            summary: "The team discussed...",
            keyDecisions: ["Decision 1", "Decision 2"],
            actionItems: [
                ActionItem(task: "Fix bug", owner: "Frontend", dueDate: "Today"),
                ActionItem(task: "Deploy patch", owner: "Backend", dueDate: "Tomorrow")
            ]
        )

        exportMeetingReport(report) { url in
            if let url = url {
                self.generatedPDFURL = url
                self.navigateToPDF = true
            }
        }
 
    }
    
    func exportMeetingReport(_ report: MeetingReport, completion: @escaping (URL?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long

        let pdfMetaData = [
            kCGPDFContextCreator: "Kholasah",
            kCGPDFContextAuthor: "Your App"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 595.2
        let pageHeight: CGFloat = 841.8
        let margin: CGFloat = 40
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { context in
            context.beginPage()
            var y: CGFloat = margin

            func drawHeader(_ text: String, font: UIFont, yOffset: CGFloat = 10) {
                let attr = [NSAttributedString.Key.font: font]
                let size = text.size(withAttributes: attr)
                text.draw(at: CGPoint(x: margin, y: y), withAttributes: attr)
                y += size.height + yOffset
            }

            drawHeader("PROFESSIONAL REPORT", font: .boldSystemFont(ofSize: 14))
            drawHeader(report.title, font: .boldSystemFont(ofSize: 24))
            drawHeader("Date: \(dateFormatter.string(from: report.date))", font: .systemFont(ofSize: 14))

            y += 10
            drawHeader("Meeting Summary", font: .boldSystemFont(ofSize: 18))
            let summaryRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: .greatestFiniteMagnitude)
            let summaryAttr = NSAttributedString(string: report.summary, attributes: [.font: UIFont.systemFont(ofSize: 14)])
            let summarySize = summaryAttr.boundingRect(with: summaryRect.size, options: .usesLineFragmentOrigin, context: nil)
            summaryAttr.draw(in: CGRect(origin: CGPoint(x: margin, y: y), size: summarySize.size))
            y += summarySize.height + 20

            drawHeader("Key Decisions", font: .boldSystemFont(ofSize: 18))
            for decision in report.keyDecisions {
                let bullet = "• \(decision)"
                let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                bullet.draw(at: CGPoint(x: margin + 10, y: y), withAttributes: attr)
                y += 20
            }

            y += 20
            drawHeader("Action Items", font: .boldSystemFont(ofSize: 18))
            y += 5

            // Draw Table Headers
            let headers = ["Task", "Owner", "Due Date"]
            let columnWidth = (pageWidth - 2 * margin) / 3
            for (index, header) in headers.enumerated() {
                let attr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
                let x = margin + CGFloat(index) * columnWidth
                header.draw(at: CGPoint(x: x, y: y), withAttributes: attr)
            }
            y += 20

            // Draw Table Rows
            for item in report.actionItems {
                let values = [item.task, item.owner, item.dueDate]
                for (index, value) in values.enumerated() {
                    let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
                    let x = margin + CGFloat(index) * columnWidth
                    value.draw(at: CGPoint(x: x, y: y), withAttributes: attr)
                }
                y += 20
            }
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("MeetingReport.pdf")
        do {
            try data.write(to: url)
            completion(url)
        } catch {
            print("PDF write failed: \(error)")
            completion(nil)
        }
    }
}
