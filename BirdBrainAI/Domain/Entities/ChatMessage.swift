//
//  ChatMessage.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    
    enum Sender: String, Codable {
        case user, assistant
    }
    
    let id: UUID
    let sender: Sender
    let content: String
    let timestamp: Date
    
    init(sender: Sender,
         content: String,
         timestamp: Date = Date(),
         id: UUID = UUID()) {
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
        self.id = id
    }
}

//MARK: - Previews

extension ChatMessage {
    static var examples: [ChatMessage] {
        [
            ChatMessage(sender: .user,
                        content: "Which parrots are the quietest?"),
            ChatMessage(sender: .assistant,
                        content: "The quietest parrots are Senegal Parrots, Meyer’s Parrots, and Bourke’s Parakeets, followed by Pionus Parrots, Budgerigars (Budgies), and Cockatiels, which are all known for their calm, gentle temperaments and soft vocalizations.")
        ]
    }
}
