//
//  SuggestionsView.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import SwiftUI
import FactoryKit

struct SuggestionsView: View {
    
    @ObservedObject var viewModel: HomeViewModel
        
    let suggestions = [
        // 🔹 Species-specific info
        "Tell me about the African Grey Parrot.",
        "What kind of parrot is a Kea?",
        "Tell me about the Eclectus Parrot — are males and females really different?",
        "Is a Budgerigar (Budgie) a good choice for beginners?",
        
        // 🔹 Comparisons
        "Compare Macaws and Rainbow Lorikeets — which is better for families?",
        "Compare Amazon Parrots and African Greys — which one talks more?",
        
        // 🔹 Traits and lifestyle fit
        "Which parrots are the quietest and best for apartments?",
        "Which parrots are playful and energetic?",
        
        // 🔹 Family & beginner fit
        "What’s a friendly parrot breed for families with kids?",
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                icon
                
                suggestionList
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: Views
private extension SuggestionsView {
    var icon: some View {
        Icon.birdSmallIcon.swiftUIImage
            .resizable()
            .frame(width: 150, height: 150)
            .padding(.bottom, 12)
    }
    
    var suggestionList: some View {
        ForEach(suggestions, id: \.self) { suggestion in
            Button {
                withAnimation {
                    viewModel.userInput = suggestion
                    viewModel.sendMessage()
                }
            } label: {
                Text(suggestion)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    @Injected(\.mockHomeUseCase) var mockHomeUseCase
    SuggestionsView(viewModel: HomeViewModel(homeUseCase: mockHomeUseCase))
}

