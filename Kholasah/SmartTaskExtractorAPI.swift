//
//  Untitled.swift
//  Kholasah
//
//  Created by Reem on 17/11/1446 AH.
//

import Foundation

// MARK: - Task Model for Excel Export
struct SmartTask: Codable, Identifiable {
    let id = UUID()
    let task: String
    let assignee: String?
    let due_date: String?
    let status: String?
    let comments: String?
}


func extractTasksFromTranscript(_ transcript: String, completion: @escaping ([SmartTask]) -> Void) {
    let apiKey = "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" // 🔐 Replace with your actual key
    let url = URL(string: "https://api.groq.com/openai/v1/chat/completions")!

    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(apiKey)"
    ]

    let isArabic = transcript.range(of: #"[\u0600-\u06FF]"#, options: .regularExpression) != nil

    let prompt = isArabic ?
    """
    استخرج المهام من نص الاجتماع التالي بصيغة JSON فقط (بدون شرح)، ويجب أن تكون الحقول كما يلي:

    [
      {
        "task": "",
        "assignee": "",
        "due_date": "",
        "status": "",
        "comments": ""
      }
    ]

    إذا لم تتوفر بعض الحقول اتركها فارغة. لا تشرح أي شيء.
    النص:
    \(transcript)
    """ :
    """
    Extract all tasks from this meeting transcript and return them strictly as valid JSON:

    [
      {
        "task": "",
        "assignee": "",
        "due_date": "",
        "status": "",
        "comments": ""
      }
    ]

    Leave fields empty if not mentioned. No explanation. Just return the JSON array.
    Transcript:
    \(transcript)
    """

//    let messages = [
//        Message(role: "system", content: "You are a multilingual assistant that extracts structured task data from meeting transcripts."),
//        Message(role: "user", content: prompt)
//    ]
//
//    let requestBody = ChatRequest(model: "llama3-70b-8192", messages: messages)
    let taskMessages = [
        TaskMessage(role: "system", content: "You are a multilingual assistant that extracts structured task data from meeting transcripts."),
        TaskMessage(role: "user", content: prompt)
    ]
    let requestBody = TaskRequest(model: "llama3-70b-8192", messages: taskMessages)

    guard let httpBody = try? JSONEncoder().encode(requestBody) else {
        print("⚠️ Failed to encode API request.")
        completion([])
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = httpBody

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("❌ Network error: \(error)")
            completion([])
            return
        }

        guard let data = data else {
            print("❌ No data received")
            completion([])
            return
        }

        do {
            let taskResponse = try JSONDecoder().decode(TaskResponse.self, from: data)
            guard let content = taskResponse.choices.first?.message.content else {
                print("❌ No message content found")
                completion([])
                return
            }

            guard let jsonData = content.data(using: .utf8) else {
                print("❌ Cannot convert task content to Data")
                completion([])
                return
            }

            let parsedTasks = try JSONDecoder().decode([SmartTask].self, from: jsonData)
            completion(parsedTasks) // ✅ Now inside the do block and properly scoped
        } catch {
            print("❌ Failed to decode task response: \(error)")
            print("🧾 Raw response: \(String(data: data, encoding: .utf8) ?? "none")")
            completion([])
        }
    }.resume()

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
struct TaskRequest: Codable {
    let model: String
    let messages: [TaskMessage]
}

struct TaskMessage: Codable {
    let role: String
    let content: String
}

struct TaskResponse: Codable {
    struct Choice: Codable {
        let message: TaskMessage
    }
    let choices: [Choice]
}
