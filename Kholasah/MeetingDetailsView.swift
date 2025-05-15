//
//  MeetingDetailsView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 17/11/1446 AH.
//

import SwiftUI

struct MeetingDetailsView: View {
    @State private var selectedTab = "Transcript"
    let tabs = ["Transcript", "Summary", "Report"]
    let transcript: String
    @State private var summaryText: String = ""
    
    @State private var isLoading: Bool = false
    @State private var showExcelPreview = false
    @State private var excelFileURL: URL?
    
    @ObservedObject var reportVM: ReportViewModel
    
    let transcriptSample = """
    Alright, let’s kick off. First up is the backend update.
    
    We finished integrating the authentication API. The response time dropped significantly — about 30% better than before. We tested it using Postman, and it’s stable.
    
    Did you loop in the security team for a quick review on the new protocols?
    
    Not yet. I’ll send them the report by end of day today.
    
    Okay. On the frontend side, there’s an issue showing up in Safari. The layout breaks when the user switches from light to dark mode. It works fine in Chrome and Firefox.
    
    Yeah, I noticed that too. I think it's related to the CSS toggle state. I’m pushing a fix today — I just need someone to review it before merging.
    
    Send me the pull request — I’ll take a look.
    
    Cool. On iOS, the camera module is working fine, but VoiceOver isn’t behaving correctly. When it’s enabled, the focus jumps around randomly. It's not following a logical reading order.
    
    Let’s flag that as a blocker. Also, we need to wrap up the dashboard redesign this sprint. Are the mockups ready?
    
    They are — I uploaded them to Figma. The new design uses a tabbed layout with a floating action button at the bottom.
    
    Great. From the QA side, we found three bugs related to logout. One of them is a session timeout issue. It’s already documented in Jira.
    
    Alright. We also need to schedule a meeting with the security team this week to review everything.
    
    Task list for next week:
    
    Backend: finalize the token refresh logic.
    Frontend: fix Safari layout issue and logout timeout.
    iOS: improve VoiceOver behavior.
    QA: start regression testing on Monday.
    Any blockers or dependencies?
    
    We’re still waiting on the new API key from the third-party provider. It’s been two days.
    
    I’ll escalate that today.
    
    Anything else?
    
    Nope, that’s all.
    
    Cool — thanks, everyone. Let’s meet again next week, same time.
    """
    
    var body: some View {
        NavigationView{
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
                
                if let url = reportVM.generatedPDFURL {
                    NavigationLink(destination: PDFPreviewView(pdfURL: url), isActive: $reportVM.navigateToPDF) {
                        EmptyView()
                    }
                }
            }
            .padding(.bottom)
            .background(Color(.white))
        }
    }
    var transcriptView: some View {
        let isArabic = transcriptSample.range(of: #"[\u0600-\u06FF]"#, options: .regularExpression) != nil
        
        return Text(transcriptSample)
            .padding()
            .foregroundColor(.darkPurple)
        
            .frame(maxWidth: .infinity, alignment: isArabic ? .trailing : .leading)
            .multilineTextAlignment(isArabic ? .trailing : .leading)
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
    
    var summaryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading {
                ProgressView("Generating summary...")
            } else if !summaryText.isEmpty {
                Text(summaryText)
                    .font(.subheadline)
                    .foregroundColor(.darkPurple)
                    .multilineTextAlignment(
                        summaryText.range(of: #"[\u0600-\u06FF]"#, options: .regularExpression) != nil
                        ? .trailing : .leading
                    )
            } else {
                ProgressView("Generating summary...")
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            if summaryText.isEmpty {
                isLoading = true
                summarizeTranscript(transcript: transcriptSample) { summary in
                    DispatchQueue.main.async {
                        isLoading = false
                        summaryText = summary ?? "⚠️ Failed to get summary."
                    }
                }
            }
        }
    }
    
    var reportView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose the report form")
                .font(.headline)
                .foregroundColor(Color.darkPurple)
            
            VStack(spacing: 12) {
                Button(action: {
                    reportVM.generatePDF()
                }) {
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
                
                Button(action: {
                    let tasks = extractSmartTasks(from: transcriptSample)
                    let csv = generateSmartCSV(from: tasks)
                    if let url = saveCSVFile(csvContent: csv) {
                        excelFileURL = url
                        showExcelPreview = true
                    }
                }) {
                    HStack {
                        Image(systemName: "tablecells")
                            .foregroundColor(Color.white)
                        Text("Excel Sheet")
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.darkPurple)
                    .cornerRadius(10)
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

struct TabItemView: View {
    let tab: String
    let selectedTab: String
    let onTap: () -> Void
    
    var isSelected: Bool {
        tab == selectedTab
    }
    
    var body: some View {
        VStack {
            Text(tab)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .darkPurple : .gray)
            if isSelected {
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.pigOrange)
            } else {
                Color.clear.frame(height: 2)
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}
func extractSmartTasks(from transcript: String) -> [(task: String, assignee: String?, dueDate: String?, status: String?, comments: String?)] {
    let lines = transcript.components(separatedBy: .newlines)
    var results: [(String, String?, String?, String?, String?)] = []
    
    for line in lines {
        let cleaned = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleaned.isEmpty else { continue }
        
        // Skip non-task phrases
        if cleaned.lowercased().contains("thanks")
            || cleaned.lowercased().contains("let’s meet")
            || cleaned.lowercased().contains("cool")
            || cleaned.lowercased().contains("kick off") {
            continue
        }
        
        // Rewrite task if possible
        if let rewritten = smartRewriteTask(from: cleaned) {
            let due = extractDate(from: cleaned)
            results.append((rewritten, nil, due, nil, nil))
        }
    }
    
    return results
}

func extractDate(from sentence: String) -> String? {
    let lower = sentence.lowercased()
    if lower.contains("end of day") {
        return "End of day"
    } else if lower.contains("monday") {
        return "Monday"
    } else if lower.contains("this week") {
        return "This week"
    }
    return nil
}

func smartRewriteTask(from sentence: String) -> String? {
    let lower = sentence.lowercased()
    
    if lower.contains("send") && lower.contains("report") {
        return "Send the security report"
    } else if lower.contains("pull request") && lower.contains("take a look") {
        return "Review pull request"
    } else if lower.contains("wrap up") && lower.contains("dashboard") {
        return "Finalize dashboard redesign"
    } else if lower.contains("upload") && lower.contains("figma") {
        return "Upload mockups to Figma"
    } else if lower.contains("start regression testing") {
        return "Start regression testing"
    } else if lower.contains("token refresh") {
        return "Finalize token refresh logic"
    } else if lower.contains("schedule") && lower.contains("meeting") {
        return "Schedule meeting with security team"
    } else if lower.contains("fix") && lower.contains("safari") {
        return "Fix Safari layout issue"
    } else if lower.contains("logout timeout") {
        return "Resolve logout timeout issue"
    } else if lower.contains("escalate") {
        return "Escalate API key delay"
    }
    
    // Try fallback if it seems actiony
    if lower.starts(with: "i’ll") || lower.starts(with: "we need") || lower.contains("please") {
        return sentence
    }
    
    // If it doesn't sound like a task, skip it
    return nil
}


func generateSmartCSV(from tasks: [(task: String, assignee: String?, dueDate: String?, status: String?, comments: String?)]) -> String {
    var csv = "Task,Assignee,Due Date,Status,Comments\n"
    
    for task in tasks {
        let row = [
            escapeCSV(task.task),
            escapeCSV(task.assignee),
            escapeCSV(task.dueDate),
            escapeCSV(task.status),
            escapeCSV(task.comments)
        ].joined(separator: ",")
        csv += row + "\n"
    }
    
    return csv
}
func escapeCSV(_ field: String?) -> String {
    let value = field ?? ""
    if value.contains(",") || value.contains("\"") || value.contains("\n") {
        return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
    } else {
        return value
    }
}


func saveCSVFile(csvContent: String, fileName: String = "MeetingTasks.xls") -> URL? {
    let fileManager = FileManager.default
    guard let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    
    let fileURL = docsURL.appendingPathComponent(fileName)
    
    do {
        try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
        print("✅ Excel file saved to: \(fileURL)")
        return fileURL
    } catch {
        print("❌ Failed to write Excel file: \(error)")
        return nil
    }
}



func cleanSummaryText(_ text: String) -> String {
    let invisibleControlCharacters: CharacterSet = [
        "\u{202A}", // LRE
        "\u{202B}", // RLE
        "\u{202C}", // PDF
        "\u{202D}", // LRO
        "\u{202E}", // RLO
        "\u{200E}", // LRM
        "\u{200F}" // RLM
    ].reduce(into: CharacterSet()) { $0.insert(charactersIn: $1) }
    
    return text.components(separatedBy: invisibleControlCharacters).joined()
}
func removeIntroAndFormatting(from text: String) -> String {
    var result = text
    
    // Remove common intro phrases
    let introsToRemove = [
        "Here is the summary:",
        "The summary is:",
        "Summary:",
        "This is the summary:",
        "This is a summary:",
        "In summary:"
    ]
    for phrase in introsToRemove {
        result = result.replacingOccurrences(of: phrase, with: "", options: .caseInsensitive)
    }
    
    result = result.replacingOccurrences(of: "**", with: "")
    
    return result.trimmingCharacters(in: .whitespacesAndNewlines)
}


func summarizeTranscript(transcript: String, completion: @escaping (String?) -> Void) {
    let apiKey = ""
    //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
    let url = URL(string: "https://api.groq.com/openai/v1/chat/completions")!
    
    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(apiKey)"
    ]
    
    let isArabic = transcript.range(of: #"[\u0600-\u06FF]"#, options: .regularExpression) != nil
    
    let prompt = isArabic ?
"""
لخص هذا الاجتماع بنفس لغة النص (العربية)، مع الحفاظ على الكلمات الإنجليزية التقنية مثل (API, backend, Python) كما هي. استخدم التنسيق التالي بدقة:

- ملخص عام للاجتماع (3 إلى 4 أسطر كحد أقصى)

🔹 أهمية الاجتماع:

• القرارات المتخذة:
• المهام الموكلة:
• التركيز الرئيسي:
""" :
"""
Summarize this meeting in English. Do **not** write any introductions like "Here is the summary\n" or "The summary is:\n". Just return the following structure directly:


- Brief of the meeting (3–4 lines max)

🔹 Meeting Important Highlights 🔹

• Key Decisions Made:
• Tasks Assigned:
• Main Focus:
"""
    
    let messages = [
        Message(role: "system", content: "You are a multilingual assistant that generates clear and well-formatted summaries for meeting transcripts."),
        Message(role: "user", content: "\(prompt)\n\nTranscript:\n\(transcript)")
    ]
    
    // let requestBody = ChatRequest(model: "mixtral-8x7b-32768", messages: messages)
    let requestBody = ChatRequest(model: "llama3-70b-8192", messages: messages)
    
    
    guard let httpBody = try? JSONEncoder().encode(requestBody) else {
        print("⚠️ Failed to encode request body")
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = httpBody
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("❌ Network error: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 HTTP status: \(httpResponse.statusCode)")
        }
        
        guard let data = data,
              let chatResponse = try? JSONDecoder().decode(ChatResponse.self, from: data),
              let summary = chatResponse.choices.first?.message.content else {
            print("❌ Failed to parse summary")
            print("🧾 Raw response: \(String(data: data ?? Data(), encoding: .utf8) ?? "No data")")
            completion(nil)
            return
        }
        
        let cleaned = cleanSummaryText(summary)
        let final = removeIntroAndFormatting(from: cleaned)
        completion(final)
        
    }.resume()
}



struct ChatRequest: Codable {
    let model: String
    let messages: [Message]
}

struct Message: Codable {
    let role: String
    let content: String
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }
    let choices: [Choice]
}

#Preview {
    MeetingDetailsView(transcript: "", reportVM: ReportViewModel())
}
