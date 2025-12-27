//----------------------------------------------------------------------------
//File:       SupabaseMessageService.swift
//Project:    cbc
//Created by: Celaya Solutions, 2025
//Author:     Christopher Celaya <chris@chriscelaya.com>
//Description: Service for persisting and retrieving messages from Supabase
//Version:    1.0.0
//License:    MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation

class SupabaseMessageService {
    static let shared = SupabaseMessageService()
    
    private init() {}
    
    // MARK: - Conversation Management
    
    func getOrCreateDefaultConversation(userId: String) async throws -> UUID {
        guard SupabaseConfig.shared.hasConfiguration() else {
            throw SupabaseError.configurationMissing
        }
        
        // If SDK is not yet integrated, return a placeholder UUID
        // This allows the app to continue working while SDK integration is pending
        if !SupabaseConfig.shared.isClientInitialized() {
            print("⚠️ Supabase SDK not yet integrated - using placeholder conversation ID")
            return UUID()
        }
        
        // Try to find existing default conversation
        // For now, we'll create a new one each time or use a single conversation per user
        // This can be optimized later
        
        // Create a new conversation
        let conversationId = UUID()
        
        // TODO: Insert conversation into Supabase when SDK is available
        // Example:
        // let response = try await client
        //     .from("conversations")
        //     .insert([
        //         "id": conversationId.uuidString,
        //         "user_id": userId,
        //         "title": nil
        //     ])
        //     .execute()
        
        return conversationId
    }
    
    // MARK: - Message Operations
    
    func saveMessage(_ message: Message, userId: String, conversationId: UUID?) async throws {
        guard SupabaseConfig.shared.hasConfiguration() else {
            throw SupabaseError.configurationMissing
        }
        
        // If SDK is not yet integrated, log and return (don't throw error)
        if !SupabaseConfig.shared.isClientInitialized() {
            print("⚠️ Supabase SDK not yet integrated - message not persisted: \(message.id)")
            return
        }
        
        // Ensure we have a conversation
        let convId: UUID
        if let existingId = conversationId {
            convId = existingId
        } else {
            convId = try await getOrCreateDefaultConversation(userId: userId)
        }
        
        // Convert Message to database format
        var messageData: [String: Any] = [
            "id": message.id.uuidString,
            "user_id": userId,
            "content": message.content,
            "is_user": message.isUser,
            "timestamp": ISO8601DateFormatter().string(from: message.timestamp)
        ]
        
        messageData["conversation_id"] = convId.uuidString
        
        if let parentId = message.parentId {
            messageData["parent_id"] = parentId.uuidString
        }
        
        if let projectCards = message.projectCards {
            // Convert Project array to JSON
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(projectCards),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                messageData["project_cards"] = jsonString
            }
        }
        
        // TODO: Insert message into Supabase when SDK is available
        // Example:
        // try await client
        //     .from("messages")
        //     .insert(messageData)
        //     .execute()
        
        print("💾 Message saved to Supabase (placeholder): \(message.id)")
    }
    
    func loadMessages(userId: String, conversationId: UUID? = nil, limit: Int = 100) async throws -> [Message] {
        guard SupabaseConfig.shared.hasConfiguration() else {
            throw SupabaseError.configurationMissing
        }
        
        // If SDK is not yet integrated, return empty array
        if !SupabaseConfig.shared.isClientInitialized() {
            print("⚠️ Supabase SDK not yet integrated - returning empty message list")
            return []
        }
        
        // TODO: Query messages from Supabase when SDK is available
        // Example:
        // var query = client
        //     .from("messages")
        //     .select("*")
        //     .eq("user_id", value: userId)
        //     .order("timestamp", ascending: false)
        //     .limit(limit)
        //
        // if let conversationId = conversationId {
        //     query = query.eq("conversation_id", value: conversationId.uuidString)
        // }
        //
        // let response: [SupabaseMessage] = try await query.execute().value
        // return response.map { convertToMessage($0) }
        
        // Placeholder: return empty array
        print("📥 Loading messages from Supabase (placeholder)")
        return []
    }
    
    func deleteMessage(_ messageId: UUID, userId: String) async throws {
        guard SupabaseConfig.shared.hasConfiguration() else {
            throw SupabaseError.configurationMissing
        }
        
        // If SDK is not yet integrated, log and return
        if !SupabaseConfig.shared.isClientInitialized() {
            print("⚠️ Supabase SDK not yet integrated - delete not performed: \(messageId)")
            return
        }
        
        // TODO: Delete message from Supabase when SDK is available
        // Example:
        // try await client
        //     .from("messages")
        //     .delete()
        //     .eq("id", value: messageId.uuidString)
        //     .eq("user_id", value: userId)
        //     .execute()
        
        print("🗑️ Message deleted from Supabase (placeholder): \(messageId)")
    }
    
    // MARK: - Batch Operations
    
    func saveMessages(_ messages: [Message], userId: String, conversationId: UUID?) async throws {
        // Save messages in batch
        for message in messages {
            try await saveMessage(message, userId: userId, conversationId: conversationId)
        }
    }
    
    // MARK: - Helper Methods
    
    private func convertToMessage(_ dbMessage: [String: Any]) -> Message? {
        guard let idString = dbMessage["id"] as? String,
              let id = UUID(uuidString: idString),
              let content = dbMessage["content"] as? String,
              let isUser = dbMessage["is_user"] as? Bool,
              let timestampString = dbMessage["timestamp"] as? String,
              let timestamp = ISO8601DateFormatter().date(from: timestampString) else {
            return nil
        }
        
        var parentId: UUID? = nil
        if let parentIdString = dbMessage["parent_id"] as? String {
            parentId = UUID(uuidString: parentIdString)
        }
        
        var projectCards: [Project]? = nil
        if let projectCardsJson = dbMessage["project_cards"] as? String,
           let jsonData = projectCardsJson.data(using: .utf8) {
            let decoder = JSONDecoder()
            projectCards = try? decoder.decode([Project].self, from: jsonData)
        }
        
        return Message(
            id: id,
            content: content,
            isUser: isUser,
            timestamp: timestamp,
            projectCards: projectCards,
            parentId: parentId
        )
    }
}
