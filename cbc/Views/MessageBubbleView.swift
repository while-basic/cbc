//----------------------------------------------------------------------------
//File:       MessageBubbleView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Message bubble with text resolution animation
//Version:     2.0.0 - Subtle Physics Edition
//License:     MIT
//Last Update: December 2025
//----------------------------------------------------------------------------

import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let isActive: Bool
    let onTap: () -> Void

    // Calculate message age for time-based dimming
    private var messageAge: TimeInterval {
        Date().timeIntervalSince(message.timestamp)
    }

    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 16) {
            // Message text with resolution animation
            HStack {
                if message.isUser {
                    Spacer(minLength: 60)
                }

                Text(message.content)
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
                    .foregroundColor(message.isUser ? .white : Color(hex: "E0E0E0"))
                    .lineSpacing(6)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(
                        Group {
                            if message.isUser {
                                Color(hex: "0066FF").opacity(0.15)
                            } else {
                                Color(hex: "1A1A1A")
                            }
                        }
                    )
                    .cornerRadius(2)
                    .textResolution(delay: message.isUser ? 0 : 0.08)

                if !message.isUser {
                    Spacer(minLength: 60)
                }
            }

            // Project cards if any
            if isActive, let projects = message.projectCards, !projects.isEmpty {
                LazyVStack(spacing: 12) {
                    ForEach(Array(projects.enumerated()), id: \.element.id) { index, project in
                        ProjectCardView(project: project)
                            .textResolution(delay: Double(index) * 0.12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .timeDimming(age: messageAge)
        .opacity(isActive ? 1.0 : 0.15)
        .scaleEffect(isActive ? 1.0 : 0.98)
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.2)) {
                onTap()
            }
        }
        .drawingGroup()
    }
}

#Preview {
    VStack(spacing: 16) {
        MessageBubbleView(
            message: Message(
                content: "What are you working on?",
                isUser: true
            ),
            isActive: true,
            onTap: {}
        )

        MessageBubbleView(
            message: Message(
                content: "I'm currently focused on several key projects. Let me show you CLOS, my primary focus right now.",
                isUser: false,
                projectCards: [
                    Project(
                        name: "CLOS",
                        description: "Cognitive Life Operating System - AI-augmented cognitive optimization using voice journaling and multi-modal analysis",
                        status: "90-day self-experimentation protocol active",
                        tech: ["iOS Shortcuts", "Voice transcription", "Pattern analysis"]
                    )
                ]
            ),
            isActive: true,
            onTap: {}
        )
    }
    .background(Color(hex: "0A0A0A"))
}
