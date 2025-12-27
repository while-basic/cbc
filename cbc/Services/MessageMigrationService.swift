//----------------------------------------------------------------------------
//File:       MessageMigrationService.swift
//Project:    cbc
//Created by: Celaya Solutions, 2025
//Author:     Christopher Celaya <chris@chriscelaya.com>
//Description: Service for migrating messages from local storage to Supabase
//Version:    1.0.0
//License:    MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation

class MessageMigrationService {
    static let shared = MessageMigrationService()
    
    private let migrationKey = "messages_migrated_to_supabase"
    private let storageHistoryPrefix = "portal_history_"
    
    private init() {}
    
    // MARK: - Migration Check
    
    func hasMigrated() -> Bool {
        return UserDefaults.standard.bool(forKey: migrationKey)
    }
    
    func markAsMigrated() {
        UserDefaults.standard.set(true, forKey: migrationKey)
    }
    
    // MARK: - Migrate from UserDefaults/localStorage
    
    func migrateFromLocalStorage(userId: String) async throws -> Int {
        guard !hasMigrated() else {
            print("✅ Messages already migrated")
            return 0
        }
        
        // Try to load messages from UserDefaults (iOS) or localStorage (web)
        let messages: [Message] = []
        
        // Check UserDefaults for stored messages
        // Note: The current implementation stores messages in memory only
        // This migration is for future compatibility if messages are stored locally
        
        // For now, we'll check if there are any legacy identifiers
        let identifierKey = "portal_current_identity"
        if let identifier = UserDefaults.standard.string(forKey: identifierKey) {
            // If there's a legacy identifier, we can create a migration record
            // but there are no actual messages stored in UserDefaults currently
            print("📦 Found legacy identifier: \(identifier)")
        }
        
        // If we had messages stored, we would load them here
        // For now, this is a placeholder for future migration
        
        if messages.isEmpty {
            markAsMigrated()
            return 0
        }
        
        // Save messages to Supabase
        let supabaseService = SupabaseMessageService.shared
        try await supabaseService.saveMessages(messages, userId: userId, conversationId: nil)
        
        // Also save to CloudKit for offline access
        #if os(iOS) || os(macOS) || os(watchOS)
        let cloudKitService = CloudKitMessageService.shared
        do {
            try await cloudKitService.saveMessages(messages, userId: userId, conversationId: nil)
        } catch {
            print("⚠️ Error saving migrated messages to CloudKit: \(error.localizedDescription)")
        }
        #endif
        
        markAsMigrated()
        print("✅ Migrated \(messages.count) messages to Supabase")
        
        return messages.count
    }
    
    // MARK: - Migrate from Web App localStorage (if needed)
    
    func migrateFromWebLocalStorage(userId: String, localStorageData: [String: Any]) async throws -> Int {
        // This would be called if migrating from web app's localStorage
        // Parse localStorage data and convert to Message objects
        
        var messages: [Message] = []
        
        // Example: If localStorage has message data
        // This is a placeholder implementation
        if let messagesData = localStorageData["messages"] as? [[String: Any]] {
            for messageData in messagesData {
                if let message = parseMessageFromDict(messageData) {
                    messages.append(message)
                }
            }
        }
        
        if messages.isEmpty {
            return 0
        }
        
        // Save to Supabase
        let supabaseService = SupabaseMessageService.shared
        try await supabaseService.saveMessages(messages, userId: userId, conversationId: nil)
        
        print("✅ Migrated \(messages.count) messages from web localStorage")
        
        return messages.count
    }
    
    // MARK: - Helper Methods
    
    private func parseMessageFromDict(_ dict: [String: Any]) -> Message? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString) else {
            return nil
        }
        
        // Get content from either "content" or "text" key
        guard let content = dict["content"] as? String ?? dict["text"] as? String else {
            return nil
        }
        
        // Determine if message is from user
        let isUser: Bool
        if let isUserValue = dict["isUser"] as? Bool {
            isUser = isUserValue
        } else if let role = dict["role"] as? String {
            isUser = (role == "user")
        } else {
            return nil
        }
        
        let timestamp: Date
        if let timestampString = dict["timestamp"] as? String {
            timestamp = ISO8601DateFormatter().date(from: timestampString) ?? Date()
        } else {
            timestamp = Date()
        }
        
        var parentId: UUID? = nil
        if let parentIdString = dict["parentId"] as? String {
            parentId = UUID(uuidString: parentIdString)
        }
        
        var projectCards: [Project]? = nil
        if let projectCardsData = dict["projectCards"] as? [[String: Any]] {
            projectCards = projectCardsData.compactMap { projectDict -> Project? in
                guard let name = projectDict["name"] as? String else { return nil }
                let description = projectDict["description"] as? String ?? ""
                let status = projectDict["status"] as? String ?? ""
                let tech = projectDict["tech"] as? [String] ?? []
                return Project(name: name, description: description, status: status, tech: tech)
            }
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
    
    // MARK: - Reset Migration (for testing)
    
    func resetMigration() {
        UserDefaults.standard.removeObject(forKey: migrationKey)
        print("🔄 Migration flag reset")
    }
}
