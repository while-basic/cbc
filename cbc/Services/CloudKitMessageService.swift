//----------------------------------------------------------------------------
//File:       CloudKitMessageService.swift
//Project:    cbc
//Created by: Celaya Solutions, 2025
//Author:     Christopher Celaya <chris@chriscelaya.com>
//Description: CloudKit service for offline message caching on Apple devices
//Version:    1.0.0
//License:    MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation
import CloudKit

#if os(iOS) || os(macOS) || os(watchOS)
class CloudKitMessageService {
    static let shared = CloudKitMessageService()
    
    private let container: CKContainer
    private let privateDatabase: CKDatabase
    
    private let recordType = "Message"
    private let conversationRecordType = "Conversation"
    
    private init() {
        // Use default container - it's automatically configured and doesn't require
        // a custom container identifier in Xcode
        self.container = CKContainer.default()
        self.privateDatabase = container.privateCloudDatabase
    }
    
    // MARK: - Conversation Management
    
    func getOrCreateDefaultConversation(userId: String) async throws -> CKRecord.ID {
        // Try to find existing conversation
        let predicate = NSPredicate(format: "userId == %@", userId)
        let query = CKQuery(recordType: conversationRecordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        do {
            let (matchResults, _) = try await privateDatabase.records(matching: query)
            
            if let (_, result) = matchResults.first {
                switch result {
                case .success(let record):
                    return record.recordID
                case .failure(let error):
                    throw error
                }
            }
        } catch {
            // If query fails, we'll create a new conversation
        }
        
        // Create new conversation
        let conversationRecord = CKRecord(recordType: conversationRecordType)
        conversationRecord["userId"] = userId
        conversationRecord["title"] = "Default Conversation"
        
        let savedRecord = try await privateDatabase.save(conversationRecord)
        return savedRecord.recordID
    }
    
    // MARK: - Message Operations
    
    func saveMessage(_ message: Message, userId: String, conversationId: CKRecord.ID?) async throws {
        let conversationRecordId: CKRecord.ID
        if let existingId = conversationId {
            conversationRecordId = existingId
        } else {
            conversationRecordId = try await getOrCreateDefaultConversation(userId: userId)
        }
        
        let messageRecord = CKRecord(recordType: recordType)
        messageRecord["messageId"] = message.id.uuidString
        messageRecord["content"] = message.content
        messageRecord["isUser"] = message.isUser ? 1 : 0
        messageRecord["timestamp"] = message.timestamp
        messageRecord["userId"] = userId
        
        if let parentId = message.parentId {
            messageRecord["parentId"] = parentId.uuidString
        }
        
        if let projectCards = message.projectCards {
            // Convert Project array to JSON
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(projectCards),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                messageRecord["projectCards"] = jsonString
            }
        }
        
        // Create reference to conversation
        let conversationReference = CKRecord.Reference(recordID: conversationRecordId, action: .deleteSelf)
        messageRecord["conversation"] = conversationReference
        
        _ = try await privateDatabase.save(messageRecord)
        print("💾 Message saved to CloudKit: \(message.id)")
    }
    
    func loadMessages(userId: String, conversationId: CKRecord.ID? = nil, limit: Int = 100) async throws -> [Message] {
        let predicate: NSPredicate
        
        if let conversationId = conversationId {
            let conversationReference = CKRecord.Reference(recordID: conversationId, action: .none)
            predicate = NSPredicate(format: "userId == %@ AND conversation == %@", userId, conversationReference)
        } else {
            predicate = NSPredicate(format: "userId == %@", userId)
        }
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        var messages: [Message] = []
        var cursor: CKQueryOperation.Cursor?
        
        repeat {
            let (matchResults, queryCursor) = try await privateDatabase.records(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: limit)
            cursor = queryCursor
            
            for (_, result) in matchResults {
                switch result {
                case .success(let record):
                    if let message = convertRecordToMessage(record) {
                        messages.append(message)
                    }
                case .failure(let error):
                    print("⚠️ Error loading CloudKit record: \(error.localizedDescription)")
                }
            }
        } while cursor != nil && messages.count < limit
        
        print("📥 Loaded \(messages.count) messages from CloudKit")
        return messages
    }
    
    func deleteMessage(_ messageId: UUID, userId: String) async throws {
        let predicate = NSPredicate(format: "messageId == %@ AND userId == %@", messageId.uuidString, userId)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let (matchResults, _) = try await privateDatabase.records(matching: query)
        
        for (recordID, result) in matchResults {
            switch result {
            case .success:
                try await privateDatabase.deleteRecord(withID: recordID)
                print("🗑️ Message deleted from CloudKit: \(messageId)")
            case .failure(let error):
                throw error
            }
        }
    }
    
    // MARK: - Batch Operations
    
    func saveMessages(_ messages: [Message], userId: String, conversationId: CKRecord.ID?) async throws {
        // Save messages in batch using CKModifyRecordsOperation for efficiency
        let records = messages.map { message -> CKRecord in
            let record = CKRecord(recordType: recordType)
            record["messageId"] = message.id.uuidString
            record["content"] = message.content
            record["isUser"] = message.isUser ? 1 : 0
            record["timestamp"] = message.timestamp
            record["userId"] = userId
            
            if let parentId = message.parentId {
                record["parentId"] = parentId.uuidString
            }
            
            if let projectCards = message.projectCards {
                let encoder = JSONEncoder()
                if let jsonData = try? encoder.encode(projectCards),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    record["projectCards"] = jsonString
                }
            }
            
            if let conversationId = conversationId {
                let conversationReference = CKRecord.Reference(recordID: conversationId, action: .deleteSelf)
                record["conversation"] = conversationReference
            }
            
            return record
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        
        _ = try await privateDatabase.modifyRecords(saving: records, deleting: [])
        print("💾 Saved \(messages.count) messages to CloudKit in batch")
    }
    
    // MARK: - Helper Methods
    
    private func convertRecordToMessage(_ record: CKRecord) -> Message? {
        guard let messageIdString = record["messageId"] as? String,
              let messageId = UUID(uuidString: messageIdString),
              let content = record["content"] as? String,
              let isUserValue = record["isUser"] as? Int,
              let timestamp = record["timestamp"] as? Date else {
            return nil
        }
        
        let isUser = isUserValue == 1
        
        var parentId: UUID? = nil
        if let parentIdString = record["parentId"] as? String {
            parentId = UUID(uuidString: parentIdString)
        }
        
        var projectCards: [Project]? = nil
        if let projectCardsJson = record["projectCards"] as? String,
           let jsonData = projectCardsJson.data(using: .utf8) {
            let decoder = JSONDecoder()
            projectCards = try? decoder.decode([Project].self, from: jsonData)
        }
        
        return Message(
            id: messageId,
            content: content,
            isUser: isUser,
            timestamp: timestamp,
            projectCards: projectCards,
            parentId: parentId
        )
    }
    
    // MARK: - Sync Status
    
    func checkCloudKitAvailability() async -> Bool {
        do {
            let status = try await container.accountStatus()
            return status == .available
        } catch {
            return false
        }
    }
}

#endif
