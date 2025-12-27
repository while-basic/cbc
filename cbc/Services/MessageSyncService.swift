//----------------------------------------------------------------------------
//File:       MessageSyncService.swift
//Project:    cbc
//Created by: Celaya Solutions, 2025
//Author:     Christopher Celaya <chris@chriscelaya.com>
//Description: Service for syncing messages between Supabase and CloudKit
//Version:    1.0.0
//License:    MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation

#if os(iOS) || os(macOS) || os(watchOS)
import CloudKit
#endif

class MessageSyncService {
    static let shared = MessageSyncService()
    
    private let supabaseService = SupabaseMessageService.shared
    #if os(iOS) || os(macOS) || os(watchOS)
    private let cloudKitService = CloudKitMessageService.shared
    #endif
    
    private var isSyncing = false
    private let lastSyncKey = "last_sync_timestamp"
    
    private init() {}
    
    // MARK: - Sync Operations
    
    func syncAll(userId: String) async throws {
        guard !isSyncing else {
            print("⚠️ Sync already in progress")
            return
        }
        
        isSyncing = true
        defer { isSyncing = false }
        
        print("🔄 Starting sync between Supabase and CloudKit...")
        
        // Strategy: Supabase is source of truth
        // 1. Load all messages from Supabase
        // 2. Sync to CloudKit
        // 3. Handle conflicts (Supabase wins)
        
        do {
            // Load from Supabase (source of truth)
            let supabaseMessages = try await supabaseService.loadMessages(userId: userId)
            
            // Sync to CloudKit
            #if os(iOS) || os(macOS) || os(watchOS)
            try await cloudKitService.saveMessages(supabaseMessages, userId: userId, conversationId: nil)
            #endif
            
            // Update last sync timestamp
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastSyncKey)
            
            print("✅ Sync completed: \(supabaseMessages.count) messages synced")
        } catch {
            print("❌ Sync failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func incrementalSync(userId: String) async throws {
        guard !isSyncing else {
            return
        }
        
        isSyncing = true
        defer { isSyncing = false }
        
        // Get last sync timestamp
        let lastSyncTimestamp = UserDefaults.standard.double(forKey: lastSyncKey)
        let lastSyncDate = lastSyncTimestamp > 0 ? Date(timeIntervalSince1970: lastSyncTimestamp) : nil
        
        print("🔄 Starting incremental sync...")
        
        // Load messages from Supabase since last sync
        // Note: This requires a timestamp filter in the query
        // For now, we'll do a full sync if lastSyncDate is nil
        
        if lastSyncDate == nil {
            // First sync - do full sync
            try await syncAll(userId: userId)
            return
        }
        
        // TODO: Implement timestamp-based query when Supabase SDK supports it
        // For now, we'll do a full sync
        try await syncAll(userId: userId)
    }
    
    // MARK: - Conflict Resolution
    
    func resolveConflicts(userId: String) async throws {
        print("🔧 Resolving conflicts...")
        
        // Load from both sources
        let supabaseMessages = try await supabaseService.loadMessages(userId: userId)
        
        #if os(iOS) || os(macOS) || os(watchOS)
        let cloudKitMessages = try await cloudKitService.loadMessages(userId: userId)
        
        // Create maps for quick lookup
        let supabaseMap = Dictionary(uniqueKeysWithValues: supabaseMessages.map { ($0.id, $0) })
        let cloudKitMap = Dictionary(uniqueKeysWithValues: cloudKitMessages.map { ($0.id, $0) })
        
        // Find conflicts (messages that exist in both but differ)
        var conflicts: [(UUID, Message, Message)] = []
        
        for (id, supabaseMsg) in supabaseMap {
            if let cloudKitMsg = cloudKitMap[id] {
                // Check if messages differ (simple content comparison)
                if supabaseMsg.content != cloudKitMsg.content ||
                   supabaseMsg.timestamp != cloudKitMsg.timestamp {
                    conflicts.append((id, supabaseMsg, cloudKitMsg))
                }
            }
        }
        
        // Resolve conflicts: Supabase wins
        for (id, supabaseMsg, _) in conflicts {
            print("🔧 Resolving conflict for message \(id): Supabase version wins")
            try await cloudKitService.saveMessage(supabaseMsg, userId: userId, conversationId: nil)
        }
        
        // Find messages only in CloudKit (orphaned)
        let cloudKitOnly = Set(cloudKitMap.keys).subtracting(Set(supabaseMap.keys))
        for id in cloudKitOnly {
            if let message = cloudKitMap[id] {
                print("📤 Syncing CloudKit-only message to Supabase: \(id)")
                try await supabaseService.saveMessage(message, userId: userId, conversationId: nil)
            }
        }
        
        print("✅ Conflict resolution completed: \(conflicts.count) conflicts resolved")
        #endif
    }
    
    // MARK: - Background Sync
    
    func startBackgroundSync(userId: String, interval: TimeInterval = 300) {
        // Schedule periodic sync
        Task {
            while true {
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                
                do {
                    try await incrementalSync(userId: userId)
                } catch {
                    print("⚠️ Background sync failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Sync Status
    
    func getLastSyncDate() -> Date? {
        let timestamp = UserDefaults.standard.double(forKey: lastSyncKey)
        return timestamp > 0 ? Date(timeIntervalSince1970: timestamp) : nil
    }
    
    func needsSync() -> Bool {
        guard let lastSync = getLastSyncDate() else {
            return true // Never synced
        }
        
        // Sync if last sync was more than 5 minutes ago
        let fiveMinutesAgo = Date().addingTimeInterval(-300)
        return lastSync < fiveMinutesAgo
    }
}
