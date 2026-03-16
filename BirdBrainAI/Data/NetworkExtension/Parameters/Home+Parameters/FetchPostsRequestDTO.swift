//
//  FetchPostsRequestDTO.swift
//  BirdBrainAI
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

struct FetchPostsRequestDTO: @MainActor Parameterable {
    let query: String?
}
