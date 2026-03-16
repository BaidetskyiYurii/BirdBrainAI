//
//  ChatView.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import SwiftUI
import FoundationModels

struct ChatView: View {
    
    let messages: [ChatMessage]
    let isLoading: Bool
    
    let partial: LanguageModelSession.ResponseStream<String>.Snapshot?
    let partialId: UUID?
    
    var body: some View {
        ScrollView {
            mesagesList
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: Views
private extension ChatView {
    var mesagesList: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(messages) { message in
                MarkdownText(markdown: message.content)
                    .modifier(StreamingViewModifier(sender: message.sender))
            }
            
            if let partial, let id = partialId {
                MarkdownText(markdown: partial.content)
                    .modifier(StreamingViewModifier(sender: .assistant))
                    .contentTransition(.opacity)
                    .animation(.easeInOut(duration: 0.7), value: partial.content)
                    .id(id)
            } else if isLoading {
                ProgressView()
            }
                
        }
        .padding()
        .padding(.bottom, 100)
    }
}

#Preview {
    ChatView(messages: ChatMessage.examples,
             isLoading: false,
             partial: nil,
             partialId: nil)
}
