//
//  ParrotInfo.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import Foundation
import FoundationModels

@Generable()
struct ParrotInfo: Codable, Identifiable {
    let id: String
    let speciesName: String
    let origin: String
    let size: String
    let lifespan: String
    let talkingAbility: String
    let temperament: String
    let diet: [String]
    let careLevel: String
    let traits: [Trait]
    let careRecommendations: CareRecommendations
    let matchTerms: [String]
}

@Generable()
struct Trait: Codable {
    let trait: String
    let explanation: String
}

@Generable()
struct CareRecommendations: Codable {
    let cageSize: String
    let toysNeeded: String
    let socialNeeds: String
    let commonChallenges: [String]
    let tips: [String]
}
