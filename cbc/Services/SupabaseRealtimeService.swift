//----------------------------------------------------------------------------
//File:       SupabaseRealtimeService.swift
//Project:    cbc
//Created by: Celaya Solutions, 2025
//Author:     Christopher Celaya <chris@chriscelaya.com>
//Description: Real-time message updates via Supabase Realtime subscriptions
//Version:    1.0.0
//License:    MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation
import Combine

class SupabaseRealtimeService {
    static let shared = SupabaseRealtimeService()
    
    private var subscriptions: [AnyCancellable] = []
    private var messageSubject = PassthroughSubject<Message, Never>()
    private var isConnected = false
    
    // Published property for SwiftUI observation
    var messagePublisher: AnyPublisher<Message, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    private init() {}
    
    // MARK: - Subscription Management
    
    func subscribeToMessages(userId: String) {
        guard !isConnected else {
            print("⚠️ Already subscribed to messages")
            return
        }
        
        guard let client = try? SupabaseConfig.shared.getClient() else {
            print("❌ Cannot subscribe: Supabase client not configured")
            return
        }
        
        // TODO: Implement Supabase Realtime subscription when SDK is available
        // Example:
        // let channel = client.channel("messages:\(userId)")
        // channel.on("postgres_changes", filter: "user_id=eq.\(userId)") { payload in
        //     if let message = self.parseRealtimeMessage(payload) {
        //         self.messageSubject.send(message)
        //     }
        // }
        // channel.subscribe { status in
        //     self.isConnected = (status == .subscribed)
        // }
        
        print("📡 Subscribed to real-time message updates for user: \(userId)")
        isConnected = true
    }
    
    func unsubscribe() {
        guard let client = try? SupabaseConfig.shared.getClient() else {
            return
        }
        
        // TODO: Unsubscribe from channel when SDK is available
        // Example:
        // client.removeChannel("messages:\(userId)")
        
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        isConnected = false
        
        print("📡 Unsubscribed from real-time updates")
    }
    
    // MARK: - Message Parsing
    
    private func parseRealtimeMessage(_ payload: [String: Any]) -> Message? {
        // Parse Supabase Realtime payload
        // This will depend on the actual payload structure from Supabase
        
        guard let newRecord = payload["new"] as? [String: Any],
              let idString = newRecord["id"] as? String,
              let id = UUID(uuidString: idString),
              let content = newRecord["content"] as? String,
              let isUser = newRecord["is_user"] as? Bool,
              let timestampString = newRecord["timestamp"] as? String,
              let timestamp = ISO8601DateFormatter().date(from: timestampString) else {
            return nil
        }
        
        var parentId: UUID? = nil
        if let parentIdString = newRecord["parent_id"] as? String {
            parentId = UUID(uuidString: parentIdString)
        }
        
        var projectCards: [Project]? = nil
        if let projectCardsJson = newRecord["project_cards"] as? String,
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
    
    // MARK: - Connection Status
    
    func getConnectionStatus() -> Bool {
        return isConnected
    }
    
    // MARK: - Reconnection Logic
    
    func reconnect(userId: String) {
        unsubscribe()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.subscribeToMessages(userId: userId)
        }
    }
}
