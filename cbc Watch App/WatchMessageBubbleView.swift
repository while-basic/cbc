//----------------------------------------------------------------------------
//File:       WatchMessageBubbleView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Message bubble view for watchOS
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import SwiftUI

struct WatchMessageBubbleView: View {
    let message: Message
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.caption)
                    .foregroundColor(message.isUser ? .black : .white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(message.isUser ? Color.white : Color(hex: "1A1A1A"))
                    )

                if isActive, let projects = message.projectCards, !projects.isEmpty {
                    ForEach(projects) { project in
                        WatchProjectCardView(project: project)
                    }
                }
            }
            .frame(maxWidth: .infinity * 0.85, alignment: message.isUser ? .trailing : .leading)

            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .opacity(isActive ? 1.0 : 0.1)
        .onTapGesture {
            onTap()
        }
        .animation(.easeInOut(duration: 0.7), value: isActive)
    }
}

#Preview {
    VStack {
        WatchMessageBubbleView(
            message: Message(content: "Hello, how can I help?", isUser: false),
            isActive: true,
            onTap: {}
        )
        WatchMessageBubbleView(
            message: Message(content: "What projects are you working on?", isUser: true),
            isActive: true,
            onTap: {}
        )
    }
    .background(Color(hex: "0A0A0A"))
}
