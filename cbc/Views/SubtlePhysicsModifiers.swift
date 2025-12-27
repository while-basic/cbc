//
//  SubtlePhysicsModifiers.swift
//  cbc
//
//  Subtle physics-based animations and view modifiers
//  Philosophy: No UI affordances, everything feels measured, observed, alive
//

import SwiftUI

// MARK: - Text Resolution Animation
// Text should never "appear" — it should *resolve*
struct TextResolutionModifier: ViewModifier {
    let delay: Double
    @State private var opacity: Double = 0.0

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                // Start at lower opacity (signal acquisition)
                opacity = 0.65
                // Resolve to full opacity over 80-140ms
                withAnimation(.easeOut(duration: Double.random(in: 0.08...0.14)).delay(delay)) {
                    opacity = 1.0
                }
            }
    }
}

extension View {
    func textResolution(delay: Double = 0) -> some View {
        self.modifier(TextResolutionModifier(delay: delay))
    }
}

// MARK: - Micro-Jitter on State Changes
// 1-2px sub-pixel shift for ~50ms on state updates
struct MicroJitterModifier: ViewModifier {
    let trigger: Int
    @State private var offset: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .offset(offset)
            .onChange(of: trigger) { _ in
                // Apply sudden shift (no easing)
                offset = CGSize(
                    width: Double.random(in: -2...2),
                    height: Double.random(in: -1...1)
                )

                // Settle back after 50ms
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    offset = .zero
                }
            }
    }
}

extension View {
    func microJitter(trigger: Int) -> some View {
        self.modifier(MicroJitterModifier(trigger: trigger))
    }
}

// MARK: - Stateful Cursor Heartbeat States
enum CursorState {
    case idle           // slow pulse ≈1.2s
    case typing         // tight, rapid blink
    case committed      // single long fade → steady on
    case decaying       // >10s silence, pulse decays
}

// MARK: - Film Grain Background
// Near-black with barely visible film grain (1-2% opacity, animated slowly)
struct FilmGrainView: View {
    @State private var noiseOffset: CGFloat = 0
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color(hex: "0B0B0C") // Near-black, not pure black
                .ignoresSafeArea()

            // Film grain layer
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.01),
                            Color.white.opacity(0.02),
                            Color.white.opacity(0.01)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
                .offset(x: noiseOffset, y: noiseOffset)
                .onAppear {
                    // Animate grain very slowly every 8-12s
                    timer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 8...12), repeats: true) { _ in
                        withAnimation(.linear(duration: 0.5)) {
                            noiseOffset = CGFloat.random(in: -2...2)
                        }
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                }
        }
    }
}

// MARK: - Identity Reveal Animation
// When "Christopher Celaya" appears, fade in slower with slight vertical drift
struct IdentityRevealModifier: ViewModifier {
    @State private var opacity: Double = 0.0
    @State private var yOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .offset(y: yOffset)
            .onAppear {
                // Initial state: slightly below with drift
                yOffset = 2

                // Fade in slower than anything else (600ms)
                withAnimation(.easeOut(duration: 0.6)) {
                    opacity = 1.0
                }

                // Subtle upward drift, then lock
                withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                    yOffset = 0
                }
            }
    }
}

extension View {
    func identityReveal() -> some View {
        self.modifier(IdentityRevealModifier())
    }
}

// MARK: - Time-Based Dimming
// Older content dims rather than scrolling away
struct TimeDimmingModifier: ViewModifier {
    let age: TimeInterval // How old is this content
    let maxAge: TimeInterval = 300 // 5 minutes before full dim

    var calculatedOpacity: Double {
        if age < 30 { return 1.0 } // First 30s: full brightness
        if age > maxAge { return 0.3 } // Very old: dim

        // Gradual fade from 1.0 to 0.3
        let progress = (age - 30) / (maxAge - 30)
        return 1.0 - (progress * 0.7)
    }

    func body(content: Content) -> some View {
        content
            .opacity(calculatedOpacity)
    }
}

extension View {
    func timeDimming(age: TimeInterval) -> some View {
        self.modifier(TimeDimmingModifier(age: age))
    }
}

// MARK: - Peripheral Indicator Styling
// State indicators should be peripheral, not central
struct PeripheralIndicatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 9, weight: .regular, design: .monospaced))
            .foregroundColor(Color.white.opacity(0.25))
            .tracking(1.5) // Letter-spacing
    }
}

extension View {
    func peripheralIndicator() -> some View {
        self.modifier(PeripheralIndicatorModifier())
    }
}

// MARK: - Action Boundary Button Style
// COMMIT button should not feel like a button - it's an execution boundary
struct ActionBoundaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    @State private var isExecuting: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(opacity(for: configuration))
            .scaleEffect(isExecuting ? 0.0 : 1.0)
            .onChange(of: configuration.isPressed) { pressed in
                if pressed && isEnabled {
                    // On click: text briefly inverts → disappears for 120ms
                    withAnimation(.linear(duration: 0.05)) {
                        isExecuting = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        isExecuting = false
                    }
                }
            }
    }

    private func opacity(for configuration: Configuration) -> Double {
        if !isEnabled { return 0.2 } // Disabled
        if configuration.isPressed { return 1.0 } // Inverted during press
        return 0.6 // Default enabled state
    }
}

// MARK: - Stateful Cursor Pulse
// Cursor pulses differently based on interaction state
struct CursorPulseModifier: ViewModifier {
    let state: CursorState
    @State private var pulseOpacity: Double = 1.0
    @State private var timer: Timer?

    func body(content: Content) -> some View {
        content
            .opacity(pulseOpacity)
            .onAppear {
                startPulsing()
            }
            .onChange(of: state) { _ in
                timer?.invalidate()
                startPulsing()
            }
            .onDisappear {
                timer?.invalidate()
            }
    }

    private func startPulsing() {
        switch state {
        case .idle:
            // Slow pulse ≈1.2s
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulseOpacity = 0.4
            }

        case .typing:
            // Tight, rapid blink
            withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                pulseOpacity = 0.6
            }

        case .committed:
            // Single long fade → steady on
            pulseOpacity = 0.3
            withAnimation(.easeOut(duration: 0.8)) {
                pulseOpacity = 1.0
            }

        case .decaying:
            // >10s silence, pulse decays slightly
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseOpacity = 0.25
            }
        }
    }
}

extension View {
    func cursorPulse(state: CursorState) -> some View {
        self.modifier(CursorPulseModifier(state: state))
    }
}

// MARK: - Baseline Established Animation
// One-time signature animation on first launch
struct BaselineEstablishedView: View {
    @State private var opacity: Double = 0.0
    @State private var showText: Bool = false
    let onComplete: () -> Void

    var body: some View {
        Group {
            if showText {
                Text("baseline established")
                    .font(.system(size: 11, weight: .light, design: .monospaced))
                    .foregroundColor(Color(hex: "0066FF").opacity(0.6))
                    .opacity(opacity)
                    .tracking(2)
            }
        }
        .onAppear {
            // Wait 2-3 seconds of inactivity
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2.0...3.0)) {
                showText = true

                // Fade in
                withAnimation(.easeIn(duration: 0.8)) {
                    opacity = 1.0
                }

                // Hold for 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Fade out
                    withAnimation(.easeOut(duration: 1.0)) {
                        opacity = 0.0
                    }

                    // Complete callback
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        onComplete()
                    }
                }
            }
        }
    }
}
