//----------------------------------------------------------------------------
//File:       WatchProjectCardView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Project card view for watchOS
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

import SwiftUI

struct WatchProjectCardView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(project.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            if let description = project.description {
                Text(description)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "A0A0A0"))
                    .lineLimit(2)
            }
            
            if let status = project.status {
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor(for: status))
                        .frame(width: 4, height: 4)
                    
                    Text(status)
                        .font(.caption2)
                        .foregroundColor(Color(hex: "A0A0A0"))
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "1A1A1A"))
        )
        .padding(.top, 4)
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "active", "in progress":
            return Color(hex: "0066FF")
        case "completed", "done":
            return .green
        case "on hold", "paused":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    WatchProjectCardView(
        project: Project(
            name: "CLOS System",
            description: "Cognitive optimization system",
            status: "Active",
            tech: ["Swift", "SwiftUI"]
        )
    )
    .background(Color(hex: "0A0A0A"))
}
