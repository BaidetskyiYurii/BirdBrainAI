//
//  LoadHelper.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import Playgrounds
import Foundation

func loadParrotsInfo(from filename: String = "parrots") -> [ParrotInfo] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
        print("❌ Could not find \(filename).json in bundle.")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let breeds = try decoder.decode([ParrotInfo].self, from: data)
        return breeds
    } catch {
        print("❌ Failed to decode parrots info: \(error)")
        return []
    }
}

#Playground {
    let parrotInfo = loadParrotsInfo()
    Log.debug(parrotInfo)
}
