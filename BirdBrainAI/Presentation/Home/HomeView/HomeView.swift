//
//  HomeView.swift
//  BirdBrainAI
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI
import FactoryKit
import FoundationModels

struct HomeView: View {
    @EnvironmentObject var appCoordinator: Navigation<AppCoordinator>
    @EnvironmentObject var coordinator: Navigation<HomeFlowCoordinator>
    
    @StateObject private var viewModel: HomeViewModel
    @State private var showHistory: Bool = false
    
    init(homeUseCase: HomeUseCaseProtocol) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(
                homeUseCase: homeUseCase))
    }
    
    var body: some View {
        content
            .toolbar {
                if viewModel.model.availability == .available {
                    Button("Restart") {
                        withAnimation {
                            viewModel.reset()
                        }
                    }
                }
            }
            .onReceive(viewModel.$error) { error in
                guard let error else { return }
                
                coordinator().alert(LS.Common.error, message: error.localizedDescription) {
                    Button(LS.Common.ok) {
                        viewModel.error = nil
                    }
                }
            }
            .loadingOverlay($viewModel.isLoading)
    }
}

// MARK: Private UI
private extension HomeView {
    @ViewBuilder
    var content: some View {
        if viewModel.model.availability != .available {
            AvailabilityView(availability: viewModel.model.availability)
        } else {
            showAvailableContent
        }
        
    }
    
    var showAvailableContent: some View {
        VStack {
            if viewModel.messages.isEmpty {
                SuggestionsView(viewModel: viewModel)
                    .frame(maxHeight: .infinity)
            } else {
                ChatView(messages: viewModel.messages,
                         isLoading: viewModel.isResponding,
                         partial: viewModel.partial,
                         partialId: viewModel.partialId)
                
            }
            
            textFieldSection
        }
    }
    
    var textFieldSection: some View {
        VStack(alignment: .center, spacing: 0) {
            Divider()
            
            HStack {
                TextField("Write a question here...", text: $viewModel.userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        withAnimation {
                            viewModel.sendMessage()
                        }
                    }
                Button("Send") {
                    withAnimation {
                        viewModel.sendMessage()
                    }
                }
                .disabled(viewModel.isResponding)
            }
            .padding()
        }
      
    }
}

#Preview {
    @Injected(\.mockHomeUseCase) var mockHomeUseCase
    HomeView(homeUseCase: mockHomeUseCase)
}
