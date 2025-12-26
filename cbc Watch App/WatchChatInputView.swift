//----------------------------------------------------------------------------
//File:       WatchChatInputView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Chat input view for watchOS
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import SwiftUI

struct WatchChatInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    let isLoading: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            TextField("Message", text: $text)
                .textFieldStyle(.roundedBorder)
                .font(.caption)
                .disabled(isLoading)
            
            Button(action: {
                if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    onSend()
                }
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title3)
                    .foregroundColor(isLoading || text.isEmpty ? .gray : Color(hex: "0066FF"))
            }
            .disabled(isLoading || text.isEmpty)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

#Preview {
    WatchChatInputView(
        text: .constant(""),
        onSend: {},
        isLoading: false
    )
}
