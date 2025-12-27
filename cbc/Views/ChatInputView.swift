//----------------------------------------------------------------------------
//File:       ChatInputView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Chat input with stateful cursor heartbeat animation
//Version:     2.0.0 - Subtle Physics Edition
//License:     MIT
//Last Update: December 2025
//----------------------------------------------------------------------------

import SwiftUI

struct ChatInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    let isLoading: Bool
    @FocusState private var isFocused: Bool

    // Stateful cursor tracking
    @State private var cursorState: CursorState = .idle
    @State private var lastTypingTime: Date = Date()
    @State private var silenceTimer: Timer?
    @State private var textCommitted: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Subtle top border with cursor pulse
            Rectangle()
                .fill(Color(hex: "0066FF").opacity(0.15))
                .frame(height: 0.5)
                .cursorPulse(state: cursorState)

            HStack(spacing: 12) {
                TextField("", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "1A1A1A"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        isFocused ? Color(hex: "0066FF").opacity(0.2) : Color.clear,
                                        lineWidth: 0.5
                                    )
                                    .cursorPulse(state: cursorState)
                            )
                    )
                    .lineLimit(1...5)
                    .disabled(isLoading)
                    .focused($isFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.send)
                    .onSubmit {
                        if !text.isEmpty && !isLoading {
                            executeCommit()
                        }
                    }
                    .onChange(of: text) { _ in
                        handleTextChange()
                    }
                    .onChange(of: isFocused) { focused in
                        if focused {
                            cursorState = .idle
                        }
                    }

                // Action boundary button (not a traditional button)
                Button(action: {
                    if !text.isEmpty && !isLoading {
                        isFocused = false
                        executeCommit()
                    }
                }) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                .disabled(text.isEmpty && !isLoading)
                .buttonStyle(ActionBoundaryButtonStyle(isEnabled: !text.isEmpty || isLoading))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "0B0B0C"),
                    Color(hex: "0B0B0C").opacity(0.98)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            startSilenceMonitoring()
        }
        .onDisappear {
            silenceTimer?.invalidate()
        }
    }

    // MARK: - Cursor State Management

    private func handleTextChange() {
        lastTypingTime = Date()

        if !text.isEmpty {
            cursorState = .typing
        } else {
            cursorState = .idle
        }

        // Reset silence timer
        silenceTimer?.invalidate()
        startSilenceMonitoring()
    }

    private func executeCommit() {
        textCommitted = true
        cursorState = .committed
        onSend()

        // Reset after commit
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            textCommitted = false
            cursorState = .idle
        }
    }

    private func startSilenceMonitoring() {
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let silenceDuration = Date().timeIntervalSince(lastTypingTime)

            if silenceDuration > 10 && isFocused && text.isEmpty && !textCommitted {
                cursorState = .decaying
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ChatInputView(text: .constant(""), onSend: {}, isLoading: false)
    }
    .background(Color(hex: "0A0A0A"))
}
