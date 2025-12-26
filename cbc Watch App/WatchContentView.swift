//----------------------------------------------------------------------------
//File:       WatchContentView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Main watchOS view
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import SwiftUI

struct WatchContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    // Header
                    VStack(spacing: 4) {
                        Text("Christopher Celaya")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: "0066FF"))
                                .frame(width: 6, height: 6)
                            
                            Text("Building CLOS")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "A0A0A0"))
                        }
                    }
                    .padding(.top, 8)
                    
                    // Messages
                    ForEach(viewModel.messages) { message in
                        WatchMessageBubbleView(
                            message: message,
                            isActive: viewModel.activePathIds.contains(message.id),
                            onTap: {
                                viewModel.selectMessage(message.id)
                            }
                        )
                    }
                    
                    // Typing indicator
                    if viewModel.isLoading {
                        HStack {
                            TypingIndicatorView()
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.horizontal, 4)
            }
            .background(Color(hex: "0A0A0A"))
            
            // Input at bottom
            VStack {
                Spacer()
                WatchChatInputView(
                    text: $inputText,
                    onSend: {
                        Task {
                            let message = inputText
                            inputText = ""
                            await viewModel.sendMessage(message)
                        }
                    },
                    isLoading: viewModel.isLoading
                )
                .background(Color(hex: "0A0A0A"))
            }
        }
    }
}

#Preview {
    WatchContentView()
}
