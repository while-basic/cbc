//----------------------------------------------------------------------------
//File:       AuthService.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Authentication service for managing identity and session state
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation

class AuthService {
    static let shared = AuthService()
    
    private let identifierKey = "portal_current_identity"
    private let historyPrefix = "portal_history_"
    
    // Supabase session management
    private var supabaseSession: SupabaseSession?
    
    private init() {
        // Try to restore Supabase session from Keychain
        restoreSupabaseSession()
    }
    
    // MARK: - Legacy Authentication (UserDefaults - for backward compatibility)
    
    // Check if identifier exists in storage (for login vs signup)
    func checkIdentifierExists(_ identifier: String) -> Bool {
        let key = historyPrefix + identifier.lowercased()
        return UserDefaults.standard.string(forKey: key) != nil
    }
    
    // Save identifier to UserDefaults (legacy method)
    func saveIdentifier(_ identifier: String) {
        let normalized = identifier.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.set(normalized, forKey: identifierKey)
        
        // Also save to history for login detection
        let historyKey = historyPrefix + normalized
        UserDefaults.standard.set(true, forKey: historyKey)
    }
    
    // Get current authenticated identifier (legacy method)
    func getCurrentIdentifier() -> String? {
        // First check Supabase session
        if let session = supabaseSession {
            return session.userId
        }
        
        // Fallback to legacy UserDefaults
        return UserDefaults.standard.string(forKey: identifierKey)
    }
    
    // Check if user is authenticated
    func isAuthenticated() -> Bool {
        // Check Supabase session first
        if let session = supabaseSession {
            // Check if session is still valid
            if let expiresAt = session.expiresAt, expiresAt > Date() {
                return true
            } else if session.expiresAt == nil {
                // No expiration, assume valid
                return true
            } else {
                // Session expired, try to refresh
                Task {
                    await refreshSession()
                }
                return false
            }
        }
        
        // Fallback to legacy check
        return getCurrentIdentifier() != nil
    }
    
    // Clear authentication state
    func clearAuth() {
        // Clear Supabase session
        supabaseSession = nil
        KeychainService.shared.clearSession()
        
        // Clear legacy storage
        UserDefaults.standard.removeObject(forKey: identifierKey)
    }
    
    // Validate access key (simple validation for now - legacy method)
    func validateAccessKey(_ key: String, for identifier: String) -> Bool {
        // For now, accept any non-empty key
        // In production, this would validate against stored credentials
        return !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Supabase Authentication
    
    func setSupabaseSession(_ session: SupabaseSession) {
        self.supabaseSession = session
    }
    
    func getSupabaseSession() -> SupabaseSession? {
        return supabaseSession
    }
    
    func getSupabaseUserId() -> String? {
        return supabaseSession?.userId
    }
    
    func restoreSupabaseSession() {
        guard let accessToken = KeychainService.shared.getAccessToken(),
              let refreshToken = KeychainService.shared.getRefreshToken() else {
            return
        }
        
        let expiresAt = KeychainService.shared.getExpiresAt()
        
        // Create session from stored tokens
        // Note: We don't have user info stored, so we'll need to fetch it
        // For now, we'll use a placeholder
        self.supabaseSession = SupabaseSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt,
            userId: "", // Will be populated when needed
            email: nil
        )
    }
    
    func refreshSession() async {
        guard let refreshToken = KeychainService.shared.getRefreshToken() else {
            return
        }
        
        // TODO: Implement session refresh with Supabase
        // This will need to call Supabase auth refresh endpoint
        // For now, we'll just log that refresh is needed
        print("⚠️ Session refresh needed - not yet implemented")
    }
}
