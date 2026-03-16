//
//  StreamingViewModifier.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import SwiftUI

struct StreamingViewModifier: ViewModifier {
    
    let sender: ChatMessage.Sender
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(sender == .user ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
            .cornerRadius(12)
            .padding(sender == .user ? .leading : .trailing, 20)
            .frame(maxWidth: .infinity,
                   alignment: sender == .user ? .trailing : .leading)
    }
}
