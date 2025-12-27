//----------------------------------------------------------------------------
//File:       ContentView_iOS.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: iOS ContentView with subtle physics animations
//Version:     2.0.0 - Subtle Physics Edition
//License:     MIT
//Last Update: December 2025
//----------------------------------------------------------------------------

#if os(iOS)
import SwiftUI

struct ContentView_iOS: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    @State private var scrollProxy: ScrollViewProxy?
    @State private var stateChangeTrigger: Int = 0
    @State private var showBaselineEstablished: Bool = false
    @AppStorage("hasShownBaseline") private var hasShownBaseline: Bool = false

    var body: some View {
        ZStack {
            // Film grain background (near-black, not pure black)
            FilmGrainView()

            VStack(spacing: 0) {
                // Header with identity reveal and peripheral indicators
                headerView

                // Baseline established signature (first launch only)
                if showBaselineEstablished && !hasShownBaseline {
                    BaselineEstablishedView(onComplete: {
                        hasShownBaseline = true
                        showBaselineEstablished = false
                    })
                    .padding(.top, 20)
                }

                // Messages (no scroll, time-based dimming)
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            // Messages
                            ForEach(viewModel.messages) { message in
                                MessageBubbleView(
                                    message: message,
                                    isActive: viewModel.activePathIds.contains(message.id),
                                    onTap: {
                                        viewModel.selectMessage(message.id)
                                        stateChangeTrigger += 1
                                    }
                                )
                                .id(message.id)
                            }

                            // Silent latency state (no typing indicator)
                            if viewModel.isLoading {
                                SilentLatencyView()
                                    .padding(.vertical, 20)
                            }

                            // Bottom spacer
                            Color.clear
                                .frame(height: 20)
                                .id("bottom")
                        }
                    }
                    .scrollDisabled(false)
                    .onAppear {
                        scrollProxy = proxy

                        // Show baseline established on first launch
                        if !hasShownBaseline {
                            showBaselineEstablished = true
                        }
                    }
                    .onChange(of: viewModel.messages.count) { oldCount, newCount in
                        if newCount > oldCount {
                            stateChangeTrigger += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                            }
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
                            stateChangeTrigger += 1
                            await viewModel.sendMessage(message)
                        }
                    },
                    isLoading: viewModel.isLoading
                )
            }
            .microJitter(trigger: stateChangeTrigger)

            // Peripheral state indicator (bottom right corner)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Environment V.02-BETA")
                        .peripheralIndicator()
                        .padding(.trailing, 16)
                        .padding(.bottom, 8)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            // Identity reveal animation
            Text("Christopher Celaya")
                .font(.system(size: 28, weight: .light, design: .monospaced))
                .foregroundColor(.white)
                .tracking(1)
                .identityReveal()
                .padding(.top, 50)

            // Status indicator (subtle)
            PeripheralStatusView()
                .padding(.top, 12)
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Peripheral Status View
struct PeripheralStatusView: View {
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(hex: "0066FF").opacity(0.4))
                .frame(width: 6, height: 6)
                .scaleEffect(isPulsing ? 1.4 : 1.0)
                .opacity(isPulsing ? 0.2 : 0.6)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false), value: isPulsing)

            Text("cognitive systems online")
                .font(.system(size: 10, weight: .light, design: .monospaced))
                .foregroundColor(Color.white.opacity(0.3))
                .tracking(1.2)
        }
        .onAppear {
            isPulsing = true
        }
    }
}

// MARK: - Silent Latency View
// No spinners, no "thinking..." - just silence and acknowledgment
struct SilentLatencyView: View {
    @State private var opacity: Double = 0.0

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color(hex: "0066FF").opacity(0.2))
                .frame(width: 3, height: 3)

            Circle()
                .fill(Color(hex: "0066FF").opacity(0.2))
                .frame(width: 3, height: 3)

            Circle()
                .fill(Color(hex: "0066FF").opacity(0.2))
                .frame(width: 3, height: 3)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.4).repeatForever(autoreverses: true)) {
                opacity = 0.4
            }
        }
    }
}

#Preview {
    ContentView_iOS()
}
#endif
