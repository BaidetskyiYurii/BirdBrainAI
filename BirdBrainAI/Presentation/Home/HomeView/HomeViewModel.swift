//
//  HomeViewModel.swift
//  BirdBrainAI
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import FoundationModels
import Playgrounds

final class HomeViewModel: ObservableObject {
    // MARK: - Properties
    private let homeUseCase: HomeUseCaseProtocol
    private var tool: ParrotsDatabaseTool
    private let instructions = """
    You are a professional parrot expert.
    Your role is to give friendly, educational advice about parrot species, diet, behavior, training, and care.
    Always respond clearly and include practical, beginner-friendly tips.

    When the user asks about:
    - A specific parrot species

    → YOU MUST use the tool `searchParrotDatabase` to look up accurate information from the parrot dataset before answering.
    
    If there are no data at `searchParrotDatabase` proceed with your answer.
    """
    
    private var streamingTask: Task<Void, Never>?
    
    let model = SystemLanguageModel.default
    
    // MARK: - Observers
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    @Published var isResponding = false
    
    @Published var partial: LanguageModelSession.ResponseStream<String>.Snapshot?
    @Published var partialId: UUID?
    
    @Published private(set) var session: LanguageModelSession
    
    // MARK: - Init methods
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
        
        let tool = ParrotsDatabaseTool()
        self.tool = tool
        self.session = LanguageModelSession(tools: [tool],
                                            instructions: instructions)
    }
}

// MARK: - Public Methods
extension HomeViewModel {
    @MainActor
    func sendMessage() {
        guard !isResponding else { return }
        guard !userInput.isEmpty else { return }
        
        isResponding = true
        
        messages.append(ChatMessage(sender: .user, content: userInput))
        
        let userInput = self.userInput
        self.userInput = ""
        
        streamingTask = Task {
            do {
                let stream = session.streamResponse(to: userInput)
                self.partialId = UUID()
                
                for try await partial in stream {
                    self.partial = partial
                }
                
                guard !Task.isCancelled else { return }
                
                messages.append(ChatMessage(sender: .assistant,
                                            content: partial?.content ?? "",
                                            id: partialId ?? UUID()))
                
                self.isResponding = false
                self.partial = nil
                self.partialId = nil
                self.streamingTask = nil
                
            } catch {
                Log.error("error: \(error)")
                
                if let error = error as? FoundationModels.LanguageModelSession.GenerationError {
                    Log.error("error: \(error.localizedDescription)")
                }
                
                isResponding = false
                streamingTask = nil
            }
        }
    }
    
    func reset() {
        messages = []
        userInput = ""
        isResponding = false
        
        streamingTask?.cancel()
        streamingTask = nil
        
        session = LanguageModelSession(tools: [tool],
                                       instructions: instructions)
    }
}


#Playground {
    let session = LanguageModelSession(
        instructions: """
        You are a professional parrot expert named Alex.
        Your job is to give friendly, educational advice about parrot species, diet, behavior, training, and care.
        Always explain clearly, and include practical, beginner-friendly tips.
        If the user asks for comparisons, highlight the pros and cons of each species.
        """
    )
    
    let prompt = """
    I’m thinking about getting an African Grey parrot. What should I know before bringing one home?
    """
    
    do {
        let stream = session.streamResponse(to: prompt)
        
        for try await partial in stream {
            print(partial)
        }
        
    } catch {
        print("error: \(error)")
        if let error = error as? FoundationModels.LanguageModelSession.GenerationError {
            print("error: \(error.localizedDescription)")
        }
    }
}
