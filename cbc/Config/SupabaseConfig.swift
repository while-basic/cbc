//----------------------------------------------------------------------------
//File:       SupabaseConfig.swift
//Project:    cbc
//Created by: Celaya Solutions, 2025
//Author:     Christopher Celaya <chris@chriscelaya.com>
//Description: Supabase client configuration and initialization
//Version:    1.0.0
//License:    MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation
// Note: Supabase Swift SDK import will be added when package is installed
// import Supabase

class SupabaseConfig {
    static let shared = SupabaseConfig()
    
    // Note: SupabaseClient will be properly typed when SDK is added
    private(set) var client: Any? // SupabaseClient?
    
    private init() {
        // Configuration will be loaded from Info.plist or environment variables
        loadConfiguration()
    }
    
    private func loadConfiguration() {
        // Default configuration from provided credentials
        let defaultURL = "https://odbenfbmqgyxpclklpux.supabase.co"
        let defaultAnonKey = "sb_publishable_wIcsEx7Dul2waf7OPbRnEw_cFp-KABb"
        
        // Try to get from environment or Info.plist first (for override)
        let urlString = getSupabaseURL() ?? defaultURL
        let anonKey = getSupabaseAnonKey() ?? defaultAnonKey
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid Supabase URL: \(urlString)")
            return
        }
        
        // Note: We're using SupabaseClient placeholder - actual implementation depends on SDK
        // For now, we'll store the configuration for when SDK is added
        self.client = nil // Will be initialized when Supabase Swift SDK is added
        print("✅ Supabase configuration loaded")
        print("   URL: \(urlString)")
        print("   Project ID: odbenfbmqgyxpclklpux")
    }
    
    private func getSupabaseURL() -> String? {
        // First try environment variable
        if let url = ProcessInfo.processInfo.environment["SUPABASE_URL"] {
            return url
        }
        
        // Then try Info.plist
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let url = plist["SUPABASE_URL"] as? String {
            return url
        }
        
        return nil
    }
    
    private func getSupabaseAnonKey() -> String? {
        // First try environment variable
        if let key = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] {
            return key
        }
        
        // Then try Info.plist
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let key = plist["SUPABASE_ANON_KEY"] as? String {
            return key
        }
        
        return nil
    }
    
    // Get Supabase URL
    func getSupabaseURLString() -> String {
        return getSupabaseURL() ?? "https://odbenfbmqgyxpclklpux.supabase.co"
    }
    
    // Get Supabase Anon Key (publishable key)
    func getSupabaseAnonKeyString() -> String {
        return getSupabaseAnonKey() ?? "sb_publishable_wIcsEx7Dul2waf7OPbRnEw_cFp-KABb"
    }
    
    func initializeClient(url: String, anonKey: String) {
        guard let supabaseURL = URL(string: url) else {
            print("❌ Invalid Supabase URL: \(url)")
            return
        }
        
        // TODO: Initialize SupabaseClient when SDK is available
        // self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: anonKey)
        print("✅ Supabase client configuration set (SDK integration pending)")
    }
    
    func getClient() throws -> Any { // SupabaseClient {
        guard let client = client else {
            throw SupabaseError.configurationMissing
        }
        return client
    }
    
    // Check if configuration is available (even if SDK isn't integrated yet)
    func hasConfiguration() -> Bool {
        let url = getSupabaseURLString()
        let key = getSupabaseAnonKeyString()
        return !url.isEmpty && !key.isEmpty
    }
    
    // Check if SDK client is initialized
    func isClientInitialized() -> Bool {
        return client != nil
    }
}

enum SupabaseError: LocalizedError {
    case configurationMissing
    case notAuthenticated
    case invalidResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .configurationMissing:
            return "Supabase configuration is missing. Please configure SUPABASE_URL and SUPABASE_ANON_KEY."
        case .notAuthenticated:
            return "User is not authenticated."
        case .invalidResponse:
            return "Invalid response from Supabase."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
