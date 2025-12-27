//----------------------------------------------------------------------------
//File:       cbcApp.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Main app entry point - multiplatform (iOS/macOS)
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import SwiftUI

@main
struct cbcApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        // Initialize Supabase configuration
        _ = SupabaseConfig.shared
        print("🔧 Supabase configuration initialized")
        
        // Verify configuration on app startup
        Task {
            let (systemPrompt, knowledgeBase, apiKey) = ClaudeService.shared.verifyConfiguration()
            
            if !systemPrompt || !knowledgeBase {
                print("\n⚠️ WARNING: Configuration issues detected!")
                print("   Please check VERIFICATION_GUIDE.md for troubleshooting steps.\n")
            } else {
                print("\n✅ All systems ready!\n")
            }
            
            // Run migration if user is authenticated and migration hasn't been done
            // Check AuthService directly instead of authViewModel to avoid capturing self
            if AuthService.shared.isAuthenticated(),
               let userId = AuthService.shared.getSupabaseUserId() ?? AuthService.shared.getCurrentIdentifier() {
                await Self.runMigrationIfNeeded(userId: userId)
            }
        }
    }
    
    private static func runMigrationIfNeeded(userId: String) async {
        let migrationService = MessageMigrationService.shared
        
        guard !migrationService.hasMigrated() else {
            return
        }
        
        do {
            let migratedCount = try await migrationService.migrateFromLocalStorage(userId: userId)
            if migratedCount > 0 {
                print("✅ Migrated \(migratedCount) messages to Supabase")
            }
        } catch {
            print("⚠️ Migration failed: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            if authViewModel.isAuthenticated {
                ContentView_iOS()
            } else {
                AuthFlowView(viewModel: authViewModel)
            }
            #elseif os(macOS)
            ContentView()
            #else
            ContentView()
            #endif
        }
    }
}
