//----------------------------------------------------------------------------
//File:       ProjectCardView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Project card with subtle physics aesthetics
//Version:     2.0.0 - Subtle Physics Edition
//License:     MIT
//Last Update: December 2025
//----------------------------------------------------------------------------

import SwiftUI

struct ProjectCardView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Title (monospaced, subtle)
            Text(project.name)
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .foregroundColor(.white.opacity(0.9))
                .tracking(0.5)

            // Description
            Text(project.description)
                .font(.system(size: 13, weight: .light, design: .monospaced))
                .foregroundColor(Color(hex: "B0B0B0"))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            // Tech tags
            FlowLayout(spacing: 6) {
                ForEach(project.tech, id: \.self) { tech in
                    Text(tech)
                        .font(.system(size: 9, weight: .regular, design: .monospaced))
                        .foregroundColor(Color(hex: "606060"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "0B0B0C"))
                        .cornerRadius(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color(hex: "0066FF").opacity(0.1), lineWidth: 0.5)
                        )
                }
            }

            // Status (peripheral indicator style)
            Divider()
                .background(Color(hex: "1A1A1A"))
                .padding(.vertical, 4)

            Text(project.status)
                .peripheralIndicator()
                .tracking(1)
        }
        .padding(20)
        .background(Color(hex: "0F0F0F"))
        .cornerRadius(2)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color(hex: "1A1A1A"), lineWidth: 0.5)
        )
    }
}

// Simple flow layout for tech tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    ProjectCardView(project: Project(
        name: "CLOS",
        description: "Cognitive Life Operating System - AI-augmented cognitive optimization using voice journaling and multi-modal analysis",
        status: "90-day self-experimentation protocol active",
        tech: ["iOS Shortcuts", "Voice transcription", "Pattern analysis"]
    ))
    .padding()
    .background(Color(hex: "0A0A0A"))
}
