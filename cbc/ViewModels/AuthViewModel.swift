//----------------------------------------------------------------------------
//File:       AuthViewModel.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: View model for authentication flow
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation
import SwiftUI
import Combine

enum AuthStep {
    case identity
    case session
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentIdentifier: String?
    @Published var step: AuthStep = .identity
    @Published var identifierText: String = ""
    @Published var accessKeyText: String = ""
    @Published var isLogin: Bool = true
    @Published var isSigningInWithApple: Bool = false
    @Published var authError: String?
    
    private let authService = AuthService.shared
    
    #if os(iOS) || os(macOS)
    private let appleAuthService = AppleAuthService.shared
    #endif
    
    init() {
        // Check if already authenticated
        if authService.isAuthenticated() {
            if let identifier = authService.getCurrentIdentifier() {
                self.currentIdentifier = identifier
                self.isAuthenticated = true
            }
        }
    }
    
    func submitIdentifier() {
        let trimmed = identifierText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Check if this is a login or new signup
        isLogin = authService.checkIdentifierExists(trimmed)
        
        // Move to session step
        step = .session
    }
    
    func submitAccessKey() {
        let trimmedKey = accessKeyText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedId = identifierText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedKey.isEmpty, !trimmedId.isEmpty else { return }
        
        // Validate access key
        if authService.validateAccessKey(trimmedKey, for: trimmedId) {
            // Save identifier
            authService.saveIdentifier(trimmedId)
            
            // Update state
            currentIdentifier = trimmedId.lowercased()
            isAuthenticated = true
            
            // Reset form
            identifierText = ""
            accessKeyText = ""
            step = .identity
        }
    }
    
    func goBack() {
        step = .identity
        accessKeyText = ""
    }
    
    func cancel() {
        // Reset to initial state
        step = .identity
        identifierText = ""
        accessKeyText = ""
    }
    
    func logout() {
        authService.clearAuth()
        currentIdentifier = nil
        isAuthenticated = false
        step = .identity
        identifierText = ""
        accessKeyText = ""
        authError = nil
    }
    
    // MARK: - Sign in with Apple
    
    #if os(iOS) || os(macOS)
    func signInWithApple() async {
        isSigningInWithApple = true
        authError = nil
        
        do {
            // Step 1: Sign in with Apple
            let appleResult = try await appleAuthService.signInWithApple()
            
            // Step 2: Exchange Apple token for Supabase session
            let supabaseSession = try await appleAuthService.exchangeAppleTokenForSupabaseSession(
                appleIDToken: appleResult.identityToken
            )
            
            // Step 3: Store session in AuthService
            authService.setSupabaseSession(supabaseSession)
            
            // Step 4: Update UI state
            self.currentIdentifier = supabaseSession.userId
            self.isAuthenticated = true
            self.step = .identity
            
            // Clear form
            identifierText = ""
            accessKeyText = ""
            
        } catch {
            authError = error.localizedDescription
            print("❌ Sign in with Apple failed: \(error.localizedDescription)")
        }
        
        isSigningInWithApple = false
    }
    #endif
}
