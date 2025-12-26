//
//  ContentView.swift
//  cbc
//
//  Created by Christopher Celayac on 12/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    @State private var scrollProxy: ScrollViewProxy?
    @State private var showingSettings = false

    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0A")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView

                // API Key Warning
                if !KeychainService.shared.hasAPIKey && ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"] == nil {
                    apiKeyWarningBanner
                }

                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            // Messages
                            ForEach(viewModel.messages) { message in
                                MessageBubbleView(message: message)
                                    .id(message.id)
                            }

                            // Typing indicator
                            if viewModel.isLoading {
                                HStack {
                                    TypingIndicatorView()
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }

                            // Bottom spacer for scroll
                            Color.clear
                                .frame(height: 20)
                                .id("bottom")
                        }
                    }
                    .onAppear {
                        scrollProxy = proxy
                    }
                    .onChange(of: viewModel.messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }

                // Input field
                ChatInputView(
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
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    private var apiKeyWarningBanner: some View {
        Button(action: { showingSettings = true }) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)

                Text("Tap to configure Claude API key")
                    .font(.subheadline)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "A0A0A0"))
            }
            .padding()
            .background(Color.orange.opacity(0.2))
        }
    }

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Christopher Celaya")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(.white)

                PulsingStatusView()
            }

            Spacer()

            Button(action: { showingSettings = true }) {
                Image(systemName: "gear")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "A0A0A0"))
                    .padding(12)
                    .background(Color(hex: "1A1A1A"))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.top, 60)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "0A0A0A"))
    }
}

struct PulsingStatusView: View {
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(hex: "0066FF"))
                .frame(width: 8, height: 8)
                .scaleEffect(isPulsing ? 1.2 : 1.0)
                .opacity(isPulsing ? 1.0 : 0.6)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)

            Text("Currently: 90-day CLOS protocol • Neural Child launching Jan 2026")
                .font(.subheadline)
                .foregroundColor(Color(hex: "A0A0A0"))
        }
        .onAppear {
            isPulsing = true
        }
    }
}

#Preview {
    ContentView()
}
