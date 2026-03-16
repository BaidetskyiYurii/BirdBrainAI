//
//  BirdBrainAIApp.swift
//  BirdBrainAI
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import SwiftUI

@main
struct BirdBrainAIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView
        }
    }
}
