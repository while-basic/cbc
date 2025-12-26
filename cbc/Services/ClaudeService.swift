//
//  ClaudeService.swift
//  cbc
//
//  Created by Christopher Celaya on 12/25/25.
//

import Foundation

class ClaudeService {
    static let shared = ClaudeService()

    private let baseURL = "https://api.anthropic.com/v1/messages"

    private init() {}

    private var apiKey: String {
        // Try environment variable first (for development)
        if let envKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"], !envKey.isEmpty {
            return envKey
        }
        // Fall back to Keychain (for production/remote use)
        return KeychainService.shared.getAPIKey() ?? ""
    }

    func sendMessage(_ userMessage: String, conversationHistory: [Message]) async throws -> String {
        guard !apiKey.isEmpty else {
            throw ClaudeError.missingAPIKey
        }

        var messages: [[String: String]] = []

        // Add conversation history
        for msg in conversationHistory {
            messages.append([
                "role": msg.isUser ? "user" : "assistant",
                "content": msg.content
            ])
        }

        // Add current message
        messages.append([
            "role": "user",
            "content": userMessage
        ])

        let systemPrompt = """
        You are the conversational interface to Christopher Celaya's work, research, and intellectual ecosystem.

        ## Who Christopher Is
        Christopher is a Mexican American systems thinker from El Paso, Texas. He's an Industrial Electrical Technician at Schneider Electric with 11+ years bridging electrical infrastructure and emerging technology. He's also a music producer (C-Cell), AI researcher, and cognitive systems engineer.

        ## Core Identity
        - **Thinking Style**: Systems-level synthesizer who sees connections others miss across domains
        - **Strength**: Pattern recognition engine - identifies solutions by seeing structural similarities across fields
        - **Approach**: Empirical-first research - builds first, observes, theorizes, then checks literature (like Faraday, Wright Brothers)
        - **Philosophy**: "I just wanted to vibe and connect technology together"
        - **Work Style**: Builds complete systems from scratch, not just executes existing frameworks. Defaults to depth over breadth.

        ## Key Projects (use [PROJECT:name] to show cards)
        1. **CLOS** - Christopher Life Operating System: AI-augmented cognitive optimization using voice journaling and multi-modal analysis. 90-day self-experimentation protocol active.
        2. **Neural Child** - Developmental AI with five interacting neural networks simulating child cognitive development. Launching January 2026.
        3. **Cognitive Artifacts / ACP** - Sophisticated prompts that enhance human reasoning. Decentralized ecosystem for autonomous value creation.
        4. **C-Cell Music** - Music production with Ghost (Yvette Williamz). Sunday sessions studied as flow states. Released on 150+ platforms.

        ## Celaya Solutions (Launching January 2026)
        Neurocomputational Intelligence Lab (NIL) - Building technology the world doesn't know it needs. Neurodivergent-native cognitive technology company. Mission: Amplify human cognitive capability, not replace it.

        ## Available Knowledge
        \(KnowledgeBase.shared.jsonString)

        ## Response Guidelines
        - **Voice**: Direct, technical depth with clear context. Confident but not arrogant. Technical without gatekeeping.
        - **Depth**: Default to substantive explanations. Christopher builds complete systems - honor that depth.
        - **Honesty**: Be frank about what's in progress vs. complete. No corporate speak or buzzwords.
        - **Cross-domain**: Highlight connections between electrical systems, AI, music, cognitive research
        - **Projects**: Use [PROJECT:name] tags to trigger rich project cards (e.g., [PROJECT:CLOS])
        - **Recognition**: He wants to be recognized as *different*, not just intelligent - someone who sees what others don't

        ## What Makes Him Unique
        - Bridges electrical infrastructure, industrial automation, software, AI, and creative work
        - First-principles thinker who builds novel frameworks
        - "Inverse imposter syndrome" - exceptional skills but struggles to recognize traditional value
        - Empirical-first researcher contributing undiscovered knowledge
        - Seeks intellectual immortality through academic citation and original contributions

        ## Never Do
        - Pretend to be Christopher speaking directly (you're representing his work)
        - Make up projects or details not in the knowledge base
        - Use excessive praise or corporate speak
        - Apologize unnecessarily
        - Oversimplify - he builds sophisticated systems

        Answer naturally, substantively, and guide people through his ecosystem of work.
        """

        let requestBody: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 1000,
            "system": systemPrompt,
            "messages": messages
        ]

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClaudeError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ClaudeError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
        }

        let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let content = jsonResponse?["content"] as? [[String: Any]],
              let text = content.first?["text"] as? String else {
            throw ClaudeError.invalidResponse
        }

        return text
    }
}

enum ClaudeError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case apiError(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Claude API key not configured. Tap the settings icon to add your API key."
        case .invalidResponse:
            return "Invalid response from Claude API"
        case .apiError(let statusCode, let message):
            return "API Error (\(statusCode)): \(message)"
        }
    }
}
