//
//  StorageService.swift
//  cbc
//
//  Created by Christopher Celaya on 12/26/25.
//

import Foundation

class StorageService {
    static let shared = StorageService()

    private let messagesKey = "saved_messages"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func saveMessages(_ messages: [Message]) {
        do {
            let data = try encoder.encode(messages)
            UserDefaults.standard.set(data, forKey: messagesKey)
        } catch {
            print("Failed to save messages: \(error)")
        }
    }

    func loadMessages() -> [Message] {
        guard let data = UserDefaults.standard.data(forKey: messagesKey) else {
            return []
        }

        do {
            return try decoder.decode([Message].self, from: data)
        } catch {
            print("Failed to load messages: \(error)")
            return []
        }
    }

    func clearMessages() {
        UserDefaults.standard.removeObject(forKey: messagesKey)
    }
}
