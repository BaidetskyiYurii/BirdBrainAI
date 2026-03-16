//
//  MarkdownText.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import SwiftUI

struct MarkdownText: View {
    let markdown: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(parseLines(from: markdown), id: \.self) { line in
                render(line: line)
            }
        }
    }
}

// MARK: Views
private extension MarkdownText {
    @ViewBuilder
    func render(line: String) -> some View {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        
        if trimmed.hasPrefix("- ") {
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                Text(try! AttributedString(markdown: String(trimmed.dropFirst(2))))
            }
        } else {
            Text(try! AttributedString(markdown: trimmed))
        }
    }
}

// MARK: Private methods
private extension MarkdownText {
    func parseLines(from markdown: String) -> [String] {
        markdown.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }
}

#Preview {
    MarkdownText(markdown: """
        Hello world
        *this is* bold and **italic**
        text
        
        **Description**: Poodles are highly intelligent.
        - **Grooming**: Needs brushing
        - **Exercise**: Daily
        """)
}

