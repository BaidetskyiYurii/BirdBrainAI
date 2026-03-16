//
//  AvailabilityView.swift
//  BirdBrainAI Development
//
//  Created by Baidetskyi Yurii on 09.11.2025.
//

import SwiftUI
import FoundationModels

extension SystemLanguageModel.Availability {
    var errorText: String? {
        switch self {
        case .available:
            return nil
        case .unavailable(.modelNotReady):
            return "The model is not ready yet. Please come back later."
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Apple Intelligence is not enabled on this device. Please turn on Apple Intelligence."
        case .unavailable(.deviceNotEligible):
            return "This device is not eligible for Apple Intelligence."
        case .unavailable(let other):
            return "An unknown error occurred: \(other)"
        }
    }
}

struct AvailabilityView: View {
    let availability: SystemLanguageModel.Availability
    
    var body: some View {
        createNotAvailableView(with: availability)
    }
}

// MARK: Private methods
private extension AvailabilityView {
    func createNotAvailableView(with availability: SystemLanguageModel.Availability) -> some View {
        VStack(alignment: .center, spacing: 30) {
            Icon.aiNotAvailable.swiftUIImage
                .resizable()
                .frame(width: 100, height: 100)
            
            Text(availability.errorText ?? "")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AvailabilityView(availability: .unavailable(.appleIntelligenceNotEnabled))
}
