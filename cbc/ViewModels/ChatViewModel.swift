//----------------------------------------------------------------------------
//File:       ChatViewModel.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Chat view model with optimized message handling
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation
import SwiftUI
import Combine

#if os(iOS) || os(macOS) || os(watchOS)
import CloudKit
#endif

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var activeMessageId: UUID?
    @Published var isSyncing = false
    
    private let supabaseService = SupabaseMessageService.shared
    #if os(iOS) || os(macOS) || os(watchOS)
    private let cloudKitService = CloudKitMessageService.shared
    #endif
    private let authService = AuthService.shared
    
    private var conversationId: UUID?
    #if os(iOS) || os(macOS) || os(watchOS)
    private var cloudKitConversationId: CKRecord.ID?
    #endif
    
    // Compute the active path from root to current anchor
    var activePathIds: Set<UUID> {
        guard let activeId = activeMessageId else { return Set<UUID>() }
        var path = Set<UUID>()
        var currentId: UUID? = activeId

        while let id = currentId {
            path.insert(id)
            currentId = messages.first(where: { $0.id == id })?.parentId
        }

        return path
    }
    
    init() {
        // Load messages from database on initialization
        Task {
            await loadMessagesFromDatabase()
        }
    }

    // Get conversation context based on active path
    private func getContextHistory(from messageId: UUID?) -> [Message] {
        guard let currentId = messageId else { return [] }
        var path: [Message] = []
        var currentMessageId: UUID? = currentId

        while let id = currentMessageId {
            if let msg = messages.first(where: { $0.id == id }) {
                path.insert(msg, at: 0)
                currentMessageId = msg.parentId
            } else {
                break
            }
        }

        return path
    }

    func sendMessage(_ text: String) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        guard let userId = authService.getSupabaseUserId() ?? authService.getCurrentIdentifier() else {
            errorMessage = "Not authenticated"
            return
        }

        let userMessage = Message(
            content: text,
            isUser: true,
            parentId: activeMessageId
        )
        messages.append(userMessage)
        activeMessageId = userMessage.id
        
        // Save user message to database immediately
        await saveMessageToDatabase(userMessage, userId: userId)

        isLoading = true
        errorMessage = nil

        do {
            let history = getContextHistory(from: userMessage.id)
            let (responseText, projects) = try await ClaudeService.shared.sendMessage(text, conversationHistory: history)

            // Parse response for project tags (legacy support)
            let (cleanedResponse, additionalProjects) = parseProjectTags(from: responseText)
            
            // Combine projects from JSON response and parsed tags
            let allProjects = projects + additionalProjects

            let assistantMessage = Message(
                content: cleanedResponse,
                isUser: false,
                projectCards: allProjects.isEmpty ? nil : allProjects,
                parentId: userMessage.id
            )
            messages.append(assistantMessage)
            activeMessageId = assistantMessage.id
            
            // Save assistant message to database
            await saveMessageToDatabase(assistantMessage, userId: userId)

        } catch {
            errorMessage = error.localizedDescription
            let errorMsg = Message(
                content: "Sorry, I encountered an error: \(error.localizedDescription)",
                isUser: false,
                parentId: userMessage.id
            )
            messages.append(errorMsg)
            activeMessageId = errorMsg.id
            
            // Save error message to database
            await saveMessageToDatabase(errorMsg, userId: userId)
        }

        isLoading = false
    }

    func selectMessage(_ messageId: UUID) {
        activeMessageId = messageId
    }

    // Cache regex to avoid recompiling on every call
    private static let projectTagRegex: NSRegularExpression? = {
        let pattern = "\\[PROJECT:([^\\]]+)\\]"
        return try? NSRegularExpression(pattern: pattern)
    }()
    
    private func parseProjectTags(from response: String) -> (String, [Project]) {
        guard let regex = ChatViewModel.projectTagRegex else {
            return (response, [])
        }
        
        var cleanedResponse = response
        var foundProjects: [Project] = []
        
        // Use NSString for better performance with NSRange
        let nsString = response as NSString
        let matches = regex.matches(in: response, range: NSRange(location: 0, length: nsString.length))

        // Collect all ranges first, then process in reverse
        var rangesToRemove: [NSRange] = []
        
        for match in matches {
            guard match.numberOfRanges > 1 else { continue }
            
            let projectNameRange = match.range(at: 1)
            let projectName = nsString.substring(with: projectNameRange)

            // Find project in knowledge base
            if let project = KnowledgeBase.shared.activeProjects.first(where: { 
                $0.name.lowercased() == projectName.lowercased() 
            }) {
                foundProjects.append(project)
            }
            
            rangesToRemove.append(match.range)
        }

        // Remove tags in reverse order to maintain indices
        for range in rangesToRemove.reversed() {
            if let swiftRange = Range(range, in: cleanedResponse) {
                cleanedResponse.removeSubrange(swiftRange)
            }
        }

        return (cleanedResponse.trimmingCharacters(in: .whitespacesAndNewlines), foundProjects)
    }

    func clearMessages() {
        messages = []
        errorMessage = nil
        activeMessageId = nil
    }
    
    // MARK: - Database Operations
    
    private func loadMessagesFromDatabase() async {
        guard let userId = authService.getSupabaseUserId() ?? authService.getCurrentIdentifier() else {
            return
        }
        
        isSyncing = true
        
        do {
            // Try to load from Supabase first
            let supabaseMessages = try await supabaseService.loadMessages(userId: userId)
            
            if !supabaseMessages.isEmpty {
                messages = supabaseMessages
                if let lastMessage = messages.last {
                    activeMessageId = lastMessage.id
                }
            } else {
                // Fallback to CloudKit if Supabase is empty
                #if os(iOS) || os(macOS) || os(watchOS)
                let cloudKitMessages = try await cloudKitService.loadMessages(userId: userId)
                if !cloudKitMessages.isEmpty {
                    messages = cloudKitMessages
                    if let lastMessage = messages.last {
                        activeMessageId = lastMessage.id
                    }
                }
                #endif
            }
        } catch {
            print("⚠️ Error loading messages from database: \(error.localizedDescription)")
            // Try CloudKit as fallback
            #if os(iOS) || os(macOS) || os(watchOS)
            do {
                let cloudKitMessages = try await cloudKitService.loadMessages(userId: userId)
                if !cloudKitMessages.isEmpty {
                    messages = cloudKitMessages
                    if let lastMessage = messages.last {
                        activeMessageId = lastMessage.id
                    }
                }
            } catch {
                print("⚠️ Error loading messages from CloudKit: \(error.localizedDescription)")
            }
            #endif
        }
        
        isSyncing = false
    }
    
    private func saveMessageToDatabase(_ message: Message, userId: String) async {
        // Save to Supabase (primary)
        do {
            try await supabaseService.saveMessage(message, userId: userId, conversationId: conversationId)
        } catch {
            // Only log as error if it's not a configuration/SDK issue
            if case SupabaseError.configurationMissing = error {
                print("ℹ️ Supabase SDK not yet integrated - message saved locally only")
            } else {
                print("⚠️ Error saving message to Supabase: \(error.localizedDescription)")
            }
        }
        
        // Also save to CloudKit for offline access (secondary)
        #if os(iOS) || os(macOS) || os(watchOS)
        do {
            try await cloudKitService.saveMessage(message, userId: userId, conversationId: cloudKitConversationId)
        } catch {
            // CloudKit errors are often due to iCloud not being signed in or container not configured
            // Log as info rather than error to avoid alarming users
            print("ℹ️ CloudKit save skipped: \(error.localizedDescription)")
        }
        #endif
    }
}
