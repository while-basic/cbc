//----------------------------------------------------------------------------
//File:       AppleAuthService.swift
//Project:    cbc
//Created by: Celaya Solutions, 2025
//Author:     Christopher Celaya <chris@chriscelaya.com>
//Description: Sign in with Apple authentication service
//Version:    1.0.0
//License:    MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import Foundation
import AuthenticationServices
import CryptoKit

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS)
@MainActor
class AppleAuthService: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    static let shared = AppleAuthService()
    
    private var continuation: CheckedContinuation<AppleAuthResult, Error>?
    private var currentNonce: String?
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    func signInWithApple() async throws -> AppleAuthResult {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for security
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            authorizationController.performRequests()
        }
    }
    
    func exchangeAppleTokenForSupabaseSession(appleIDToken: String) async throws -> SupabaseSession {
        // Exchange Apple ID token with Supabase
        // TODO: Implement actual Supabase auth when SDK is available
        // For now, we'll create a session placeholder
        
        // In production, this would call:
        // let response = try await client.auth.signInWithIdToken(
        //     provider: .apple,
        //     idToken: appleIDToken
        // )
        
        // Placeholder: Create a session with the Apple user ID
        // This will be replaced with actual Supabase auth when SDK is integrated
        let session = SupabaseSession(
            accessToken: "placeholder_access_token",
            refreshToken: "placeholder_refresh_token",
            expiresAt: Date().addingTimeInterval(3600), // 1 hour
            userId: UUID().uuidString, // Will be replaced with actual user ID
            email: nil
        )
        
        // Store session in Keychain
        try KeychainService.shared.storeSession(session)
        
        return session
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleAuthError.invalidCredential)
            continuation = nil
            return
        }
        
        guard let identityToken = appleIDCredential.identityToken,
              let identityTokenString = String(data: identityToken, encoding: .utf8) else {
            continuation?.resume(throwing: AppleAuthError.tokenExtractionFailed)
            continuation = nil
            return
        }
        
        let result = AppleAuthResult(
            userID: appleIDCredential.user,
            identityToken: identityTokenString,
            email: appleIDCredential.email,
            fullName: appleIDCredential.fullName,
            authorizationCode: appleIDCredential.authorizationCode.flatMap { String(data: $0, encoding: .utf8) }
        )
        
        continuation?.resume(returning: result)
        continuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        #if os(iOS)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available for Sign in with Apple")
        }
        return window
        #elseif os(macOS)
        guard let window = NSApplication.shared.windows.first else {
            fatalError("No window available for Sign in with Apple")
        }
        return window
        #else
        fatalError("Unsupported platform")
        #endif
    }
    
    // MARK: - Helper Methods
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}

// MARK: - Models

struct AppleAuthResult {
    let userID: String
    let identityToken: String
    let email: String?
    let fullName: PersonNameComponents?
    let authorizationCode: String?
}

struct SupabaseSession {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date?
    let userId: String
    let email: String?
}

enum AppleAuthError: LocalizedError {
    case invalidCredential
    case tokenExtractionFailed
    case exchangeFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid Apple ID credential"
        case .tokenExtractionFailed:
            return "Failed to extract identity token"
        case .exchangeFailed:
            return "Failed to exchange Apple token for Supabase session"
        }
    }
}

// MARK: - Keychain Service

class KeychainService {
    static let shared = KeychainService()
    
    private let service = "com.cbc.cs.supabase"
    private let accessTokenKey = "supabase_access_token"
    private let refreshTokenKey = "supabase_refresh_token"
    private let expiresAtKey = "supabase_expires_at"
    
    private init() {}
    
    func storeSession(_ session: SupabaseSession) throws {
        // Store access token
        try store(key: accessTokenKey, value: session.accessToken)
        
        // Store refresh token
        try store(key: refreshTokenKey, value: session.refreshToken)
        
        // Store expiration date if available
        if let expiresAt = session.expiresAt {
            let expiresAtString = String(expiresAt.timeIntervalSince1970)
            try store(key: expiresAtKey, value: expiresAtString)
        }
    }
    
    func getAccessToken() -> String? {
        return retrieve(key: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return retrieve(key: refreshTokenKey)
    }
    
    func getExpiresAt() -> Date? {
        guard let expiresAtString = retrieve(key: expiresAtKey),
              let timeInterval = TimeInterval(expiresAtString) else {
            return nil
        }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func clearSession() {
        delete(key: accessTokenKey)
        delete(key: refreshTokenKey)
        delete(key: expiresAtKey)
    }
    
    private func store(key: String, value: String) throws {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.storeFailed(status)
        }
    }
    
    private func retrieve(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

enum KeychainError: LocalizedError {
    case storeFailed(OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .storeFailed(let status):
            return "Failed to store in Keychain: OSStatus \(status)"
        }
    }
}

#endif
