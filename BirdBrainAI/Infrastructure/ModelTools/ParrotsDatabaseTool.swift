//
//  ParrotsDatabaseTool.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 11.11.2025.
//

import Foundation
import FoundationModels

final class ParrotsDatabaseTool {
    
    let name = "searchParrotDatabase"
    let description = "Search for parrot species based on name, or get details about a specific parrot."
    
    private let parrots: [ParrotInfo]
    
    init() {
        self.parrots = loadParrotsInfo()
    }
    
    @Generable
    struct Arguments {
        @Guide(description: "The exact parrot species name to retrieve details for, if available.")
        let speciesName: String?
    }
}

// MARK: Tool protocol implementation
extension ParrotsDatabaseTool: Tool {
    func call(arguments: Arguments) async -> GeneratedContent {
        // 🦜 Search by parrot name
        if let name = arguments.speciesName {
            return await handleNameArgument(name)
        }
        // ❌ No arguments provided
        else {
            return GeneratedContent(properties: [
                "fallback": "No information was found in the local parrot database. Please try again with a different search term."
            ])
        }
    }
}
 
// MARK: Private methods
private extension ParrotsDatabaseTool {
    func handleNameArgument(_ name: String) async -> GeneratedContent {
        guard let result = parrots.first(where: { parrot in
            parrot.speciesName.localizedCaseInsensitiveContains(name) ||
            name.localizedCaseInsensitiveContains(parrot.speciesName) ||
            parrot.matchTerms.contains(where: {
                $0.localizedCaseInsensitiveContains(name) || name.localizedCaseInsensitiveContains($0)
            })
        }) else {
            return GeneratedContent(properties: [
                "fallback": "No parrots with the name '\(name)' found in the local database. Please try again with a different search term."
            ])
        }
        
        return GeneratedContent(properties: [
            "speciesName": result.speciesName,
            "origin": result.origin,
            "size": result.size,
            "lifespan": result.lifespan,
            "talkingAbility": result.talkingAbility,
            "temperament": result.temperament,
            "diet": result.diet,
            "careLevel": result.careLevel,
        
            "careRecommendations": GeneratedContent(properties: [
                "cageSize": result.careRecommendations.cageSize,
                "toysNeeded": result.careRecommendations.toysNeeded,
                "socialNeeds": result.careRecommendations.socialNeeds,
                "commonChallenges": result.careRecommendations.commonChallenges,
                "tips": result.careRecommendations.tips
            ])
        ])
    }
}
