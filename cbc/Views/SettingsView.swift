//
//  SettingsView.swift
//  cbc
//
//  Created by Christopher Celaya on 12/26/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var apiKey: String = ""
    @State private var showingSuccess = false
    @State private var errorMessage: String?
    @State private var isSecure = true

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0A0A0A")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Settings")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Configure your Claude API key for the conversational interface")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "A0A0A0"))
                        }
                        .padding(.top, 20)

                        // API Key Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Claude API Key")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("Your API key is stored securely in Keychain and never leaves your device.")
                                .font(.caption)
                                .foregroundColor(Color(hex: "A0A0A0"))

                            HStack {
                                Group {
                                    if isSecure {
                                        SecureField("sk-ant-...", text: $apiKey)
                                    } else {
                                        TextField("sk-ant-...", text: $apiKey)
                                    }
                                }
                                .textFieldStyle(.plain)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(12)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()

                                Button(action: { isSecure.toggle() }) {
                                    Image(systemName: isSecure ? "eye.slash" : "eye")
                                        .foregroundColor(Color(hex: "A0A0A0"))
                                }
                                .padding(.trailing, 12)
                            }
                            .background(Color(hex: "1A1A1A"))
                            .cornerRadius(8)

                            // Save Button
                            Button(action: saveAPIKey) {
                                HStack {
                                    Image(systemName: "lock.fill")
                                    Text("Save API Key Securely")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "0066FF"))
                                .cornerRadius(12)
                            }
                            .disabled(apiKey.isEmpty)
                            .opacity(apiKey.isEmpty ? 0.5 : 1.0)

                            // Success Message
                            if showingSuccess {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("API key saved successfully!")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                            }

                            // Error Message
                            if let error = errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text(error)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                        .padding(20)
                        .background(Color(hex: "1A1A1A").opacity(0.5))
                        .cornerRadius(16)

                        // How to Get API Key
                        VStack(alignment: .leading, spacing: 12) {
                            Text("How to get your API key")
                                .font(.headline)
                                .foregroundColor(.white)

                            VStack(alignment: .leading, spacing: 8) {
                                instructionRow(number: "1", text: "Go to console.anthropic.com")
                                instructionRow(number: "2", text: "Sign in or create account")
                                instructionRow(number: "3", text: "Go to API Keys section")
                                instructionRow(number: "4", text: "Create new key")
                                instructionRow(number: "5", text: "Copy and paste here")
                            }

                            Link(destination: URL(string: "https://console.anthropic.com")!) {
                                HStack {
                                    Text("Open Anthropic Console")
                                    Image(systemName: "arrow.up.right")
                                }
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "0066FF"))
                            }
                            .padding(.top, 8)
                        }
                        .padding(20)
                        .background(Color(hex: "1A1A1A").opacity(0.5))
                        .cornerRadius(16)

                        // Current Status
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status")
                                .font(.headline)
                                .foregroundColor(.white)

                            HStack {
                                Circle()
                                    .fill(KeychainService.shared.hasAPIKey ? Color.green : Color(hex: "A0A0A0"))
                                    .frame(width: 8, height: 8)

                                Text(KeychainService.shared.hasAPIKey ? "API key configured" : "No API key configured")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "A0A0A0"))
                            }
                        }
                        .padding(20)
                        .background(Color(hex: "1A1A1A").opacity(0.5))
                        .cornerRadius(16)

                        // Delete Key
                        if KeychainService.shared.hasAPIKey {
                            Button(action: deleteAPIKey) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete API Key")
                                }
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "0066FF"))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            // Don't pre-fill API key for security
            apiKey = ""
        }
    }

    private func instructionRow(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color(hex: "0066FF"))
                .clipShape(Circle())

            Text(text)
                .font(.subheadline)
                .foregroundColor(Color(hex: "A0A0A0"))
        }
    }

    private func saveAPIKey() {
        do {
            try KeychainService.shared.saveAPIKey(apiKey)
            showingSuccess = true
            errorMessage = nil

            // Hide success message after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showingSuccess = false
            }
        } catch {
            errorMessage = error.localizedDescription
            showingSuccess = false
        }
    }

    private func deleteAPIKey() {
        KeychainService.shared.deleteAPIKey()
        apiKey = ""
        showingSuccess = false
        errorMessage = nil
    }
}

#Preview {
    SettingsView()
}
