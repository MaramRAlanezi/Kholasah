//
//  Untitled.swift
//  Kholasah
//
//  Created by Reem on 17/11/1446 AH.
//

import SwiftUI

struct MeetingDetailsView: View {

@State private var selectedTab = "Transcript"
@State private var summaryText: String = ""
@State private var isLoading: Bool = false
@State private var showExcelPreview = false
@State private var excelFileURL: URL?
@State private var extractedTasks: [(task: String, assignee: String?, dueDate: String?, status: String?, comments: String?)] = []



let tabs = ["Transcript", "Summary", "Report"]

let transcriptSample = """
مم... طيب خلونا نبدأ، بس هل الكل موجود؟
إيه تقريبًا، باقي واحد أو اثنين ما دخلوا، بس نقدر نبدأ مبدئيًا.

أوكي، أول شيء... backend، وش صار على الـ API اللي كنا نشتغل عليه؟
إيه خلصنا الربط، والـ endpoints شغالة، بس فيه مشكلة بسيطة مع الـ authentication، أحيانًا الـ token ينتهي بسرعة.
هاه؟ قصدك إنه ينتهي قبل وقته؟
أيوه، بالضبط، جربنا نخلي الجلسة مفتوحة لمدة عشر دقايق بدون تفاعل، وانتهى فجأة.
مممم، يمكن لازم نراجع إعدادات الـ refresh token.

طيب والـ testing؟ سويتوا test على أكثر من سيناريو؟
إيه، استخدمنا Postman، و... جربنا login > access > refresh، كله تمام، إلا لما نترك الجهاز ساكت.
غريبة... طيب نرفع bug report ونخلي أحد يشوفها اليوم.

طيب الـ UI/UX، اللي سويناه الأسبوع اللي راح، هل وصل؟
إيه... عدلنا الـ dashboard layout، بس ترى واجهتنا مشكلة في responsiveness على بعض الأجهزة.
وش نوع الأجهزة؟
يعني مثلاً الـ iPhone 8 و 7، الحركة بطيئة.
آه، بسبب الـ animation؟
ممكن، لأن الـ transition ثقيل شوية، فـ راح نحاول نخفف منه أو نخليه optional.

وفيه شغلة ثانية... الـ dark mode؟ الأيقونات مو واضحة أبد.
إي صح، الأبيض طاغي، نغير اللون ولا نغير الأيقونات؟
نغيّر الـ assets أحسن... يكون فيهم تباين أكثر.

طيب، وش عن الحملة؟ التسويق؟
بدأنا من أمس، نشرنا فيديو مدته نص دقيقة، وحطيناه على تويتر وإنستا.
كيف التفاعل؟
يعني... مو ذاك الزود، فيه شوية likes وناس تسأل وش الفايدة من التطبيق.
إيه توقعت... لأن الفيديو ما فيه call to action واضح.
بالضبط، لازم نعيد المقطع أو نسوي نسخة قصيرة فيها steps.

وفيه شي... فيه أحد جرب النسخة الجديدة؟
أنا جربتها... في login فيه delay بسيط.
من النت ولا من التطبيق؟
لا، من التطبيق، لأن سويتها على Wi-Fi قوي وما زال delay موجود.
طيب نحطها في Jira، نخلي أحد يشوف الـ logs.

مممم، فيه شيء ثاني؟
أوه، الترجمة… الترجمة العربية داخل التطبيق شوي ركيكة.
إي حتى أنا لاحظت، خاصة لما تطلع رسالة خطأ.
طيب نرفع ملف الترجمة ونبدأ نراجع النصوص يدوي.

طيب، وش الخطة الجاية؟
يعني، نصلح الـ token، نحسّن الـ animations، ونسوي فيديو تسويقي جديد، غير كذا نراجع الترجمات ونرفع نسخة جديدة للـ TestFlight.

تمام... الاجتماع الجاي نخليه الأحد؟
إيه مناسب.
أوكي، يعطيكم العافية.
"""

var body: some View {
VStack(spacing: 16) {
Text("Software Development")
.font(.title2).bold()
.foregroundColor(Color.darkPurple)
.padding(.top)

Rectangle()
.fill(Color.gray.opacity(0.3))
.frame(height: 50)
.cornerRadius(10)
.padding(.horizontal)

HStack(spacing: 40) {
Image(systemName: "gobackward.15")
Image(systemName: "pause.fill")
Image(systemName: "goforward.15")
}
.font(.title2)
.foregroundColor(.pigOrange)

HStack {
ForEach(tabs, id: \.self) { tab in
TabItemView(tab: tab, selectedTab: selectedTab) {
selectedTab = tab
}
}
}
.padding(.horizontal)

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
.sheet(isPresented: $showExcelPreview) {
    if let url = excelFileURL {
        ExcelSheetPreview(tasks: extractedTasks, fileURL: url) // ✅ Use real tasks
    }
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



struct ExcelSheetPreview: View {
let tasks: [(task: String, assignee: String?, dueDate: String?, status: String?, comments: String?)]
let fileURL: URL
@State private var showShareSheet = false

let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 100)), count: 5)

var body: some View {
VStack {
Text("Excel Sheet")
.foregroundColor(Color.darkPurple)
.font(.title2).bold()
.padding(.top)

ScrollView([.horizontal, .vertical]) {
LazyVGrid(columns: columns, spacing: 12) {
headerCell("Task")
headerCell("Assignee")
headerCell("Due Date")
headerCell("Status")
headerCell("Comments")

ForEach(tasks, id: \.task) { task in
dataCell(task.task)
dataCell(task.assignee)
dataCell(task.dueDate)
dataCell(task.status)
dataCell(task.comments)
}
}
.padding()
}

Button(action: {
showShareSheet = true
}) {
Image(systemName: "square.and.arrow.up")
.font(.title2)
.padding()
.background(Color.darkPurple)
.foregroundColor(.white)
.clipShape(Circle())
.shadow(radius: 3)
}
}
.sheet(isPresented: $showShareSheet) {
ShareSheet(activityItems: [fileURL])
}
}

func headerCell(_ title: String) -> some View {
Text(title)
.bold()
.frame(minWidth: 100)
.padding(6)
.background(Color.gray.opacity(0.2))
.cornerRadius(6)
}

func dataCell(_ content: String?) -> some View {
Text(content ?? "-")
.frame(minWidth: 100)
.padding(4)
.background(Color.white)
.cornerRadius(4)
.border(Color.gray.opacity(0.3), width: 0.5)
}
}

var reportView: some View {
VStack(alignment: .leading, spacing: 20) {
Text("Choose the report form")
.font(.headline)
.foregroundColor(Color.darkPurple)

VStack(spacing: 12) {
Button(action: {
print("📄 Professional Report tapped")
}) {
HStack(spacing: 10) {
Image("pdficon")
.resizable()
.frame(width: 20, height: 20)
Text("Professional Report")
.fontWeight(.medium)
.foregroundColor(Color.darkPurple)
Spacer()
}
.padding()
.background(Color.white)
.overlay(
RoundedRectangle(cornerRadius: 12)
.stroke(Color.darkPurple, lineWidth: 1)
)
.cornerRadius(12)
}

    Button(action: {
        isLoading = true
        extractTasksFromTranscript(transcriptSample) { tasks in
            DispatchQueue.main.async {
                isLoading = false
                let csvTasks = tasks.map { ($0.task, $0.assignee, $0.due_date, $0.status, $0.comments) }
                self.extractedTasks = csvTasks // ✅ Save to state

                let csv = generateSmartCSV(from: csvTasks)
                if let url = saveCSVFile(csvContent: csv) {
                    excelFileURL = url
                    showExcelPreview = true
                }
            }
        }
    }) {
        HStack(spacing: 10) {
            Image(systemName: "tablecells")
                .foregroundColor(.white)
            Text("Excel Sheet")
                .fontWeight(.medium)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.darkPurple)
        .cornerRadius(12)
    }

}
.padding()
.background(Color.white)
.cornerRadius(20)
.shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
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
let apiKey = "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"
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
Summarize this meeting in English. Do **not** write any introductions like "Here is the summary" or "The summary is:". Just return the following structure directly:


- Brief of the meeting (3–4 lines max)

🔹 Meeting Important Highlights 🔹

• Key Decisions Made:
• Tasks Assigned:
• Main Focus:
"""
    let summaryMessages = [
        SummaryMessage(role: "system", content:
        """
        You are a a both arabic and english proffesional assistant that generates clear and well-formatted summaries for meeting transcripts. 
        ⚠️ Do not add any explanation, notes, or comments about how you generated the summary, also dont put any letters that is non arabic and english. 
        Only return the summary in the requested structure without mentioning formatting or technical term handling.
        """
        ),


        SummaryMessage(role: "user", content: "\(prompt)\n\nTranscript:\n\(transcript)")
    ]
    let requestBody = SummaryRequest(model: "llama3-70b-8192", messages: summaryMessages)


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
      let chatResponse = try? JSONDecoder().decode(SummaryResponse.self, from: data),
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



//struct ChatRequest: Codable {
//let model: String
//let messages: [Message]
//}
//
//struct Message: Codable {
//let role: String
//let content: String
//}
//
//struct ChatResponse: Codable {
//struct Choice: Codable {
//let message: Message
//}
//let choices: [Choice]
//}
struct SummaryRequest: Codable {
    let model: String
    let messages: [SummaryMessage]
}

struct SummaryMessage: Codable {
    let role: String
    let content: String
}

struct SummaryResponse: Codable {
    struct Choice: Codable {
        let message: SummaryMessage
    }
    let choices: [Choice]
}


#Preview {
MeetingDetailsView()
}
