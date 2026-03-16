//
//  HomeFlowCoordinator.swift
//  BirdBrainAI
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI
import FactoryKit

final class HomeFlowCoordinator {
    @Injected(\.homeUseCase) private var homeUseCase
}

// MARK: - NavigationCoordinator
extension HomeFlowCoordinator: NavigationCoordinator {
    
    // screens available for navigation
    enum Screen: ScreenProtocol {
        case home
    }
    
    // view for each screen
    func destination(for screen: Screen) -> some View {
        switch screen {
        case .home: HomeView(homeUseCase: homeUseCase)
        }
    }
}
