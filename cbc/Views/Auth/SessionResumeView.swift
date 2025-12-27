//----------------------------------------------------------------------------
//File:       SessionResumeView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Session resume screen matching reference images
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

#if os(iOS)
import SwiftUI

struct SessionResumeView: View {
    @Binding var accessKeyText: String
    let isLogin: Bool
    let onSubmit: () -> Void
    let onBack: () -> Void
    let onCancel: () -> Void
    
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            // Background matching chat page
            Color(hex: "0A0A0A")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Title section
                VStack(spacing: 12) {
                    Text(isLogin ? "RESUME SESSION" : "SECURE IDENTITY")
                        .font(.system(size: 12, weight: .semibold, design: .default))
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.6))
                        .textCase(.uppercase)
                    
                    // Horizontal separator matching chat style
                    Rectangle()
                        .fill(Color(hex: "2A2A2A").opacity(0.6))
                        .frame(height: 1)
                        .frame(maxWidth: 200)
                }
                .padding(.bottom, 64)
                
                // Input field (secure) styled like chat input
                SecureField("ACCESS KEY", text: $accessKeyText)
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.characters)
                    .focused($isInputFocused)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "151515"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(isInputFocused ? Color(hex: "0066FF").opacity(0.5) : Color(hex: "2A2A2A"), lineWidth: 2)
                            )
                    )
                    .onSubmit {
                        if !accessKeyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSubmit()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                // Navigation buttons
                HStack(spacing: 16) {
                    // Back button (left)
                    Button(action: onBack) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("BACK")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                        }
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(hex: "151515"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color(hex: "2A2A2A"), lineWidth: 2)
                                )
                        )
                    }
                    
                    Spacer()
                    
                    // Connect button (right) styled like chat send button
                    Button(action: {
                        if !accessKeyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSubmit()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text("CONNECT")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(
                            Group {
                                if accessKeyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color(hex: "1A1A1A"))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(Color(hex: "2A2A2A"), lineWidth: 2)
                                        )
                                } else {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(hex: "0066FF"),
                                                    Color(hex: "0052CC")
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                            }
                        )
                        .shadow(
                            color: accessKeyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.clear : Color(hex: "0066FF").opacity(0.4),
                            radius: 12,
                            x: 0,
                            y: 4
                        )
                    }
                    .disabled(accessKeyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 64)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            // Cancel button (top-right) matching chat style
            VStack {
                HStack {
                    Spacer()
                    Button(action: onCancel) {
                        Text("CANCEL")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundColor(.white.opacity(0.4))
                            .textCase(.uppercase)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .padding(.top, 40)
                    .padding(.trailing, 24)
                }
                Spacer()
            }
        }
        .onAppear {
            // Auto-focus input field
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isInputFocused = true
            }
        }
    }
}

#Preview {
    SessionResumeView(
        accessKeyText: .constant(""),
        isLogin: true,
        onSubmit: {},
        onBack: {},
        onCancel: {}
    )
}
#endif
