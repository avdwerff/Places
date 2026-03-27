//
//  LocationListView+Preview.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import SwiftUI


// MARK: - Preview Mocks

private struct MockLocationService: LocationServiceProtocol {
    var locations: [Location] = []
    var error: NetworkError?
    var delay: Duration = .milliseconds(100)
    
    func fetchLocations() async throws(NetworkError) -> [Location] {
        try? await Task.sleep(for: delay)
        if let error { throw error }
        return locations
    }
}

private struct MockDeepLinkService: DeepLinkServiceProtocol {
    func openDeepLink(_ url: URL) async -> Bool { true }
}

extension DependencyContainer {
    static var preview: DependencyContainer { DependencyContainer() }
}

// MARK: - Previews

#Preview("Loaded") {
    let container = DependencyContainer.preview
    let viewModel = LocationListViewModel(
        locationService: MockLocationService(locations: [
            Location(name: "Amsterdam Centraal", latitude: 52.3791, longitude: 4.9003),
            Location(name: "Rijksmuseum", latitude: 52.3600, longitude: 4.8852),
            Location(name: "Anne Frank House", latitude: 52.3752, longitude: 4.8840),
            Location(name: "Vondelpark", latitude: 52.3579, longitude: 4.8686),
            Location(name: "NEMO Science Museum", latitude: 52.3738, longitude: 4.9123),
            Location(name: "Royal Palace Amsterdam", latitude: 52.3731, longitude: 4.8913),
            Location(name: "Van Gogh Museum", latitude: 52.3584, longitude: 4.8811),
            Location(name: "Heineken Experience", latitude: 52.3579, longitude: 4.8918),
            Location(name: "Artis Zoo", latitude: 52.3660, longitude: 4.9166),
            Location(name: "A'DAM Lookout", latitude: 52.3843, longitude: 4.9024),
            Location(name: "Jordaan", latitude: 52.3747, longitude: 4.8839),
            Location(name: "De Wallen", latitude: 52.3726, longitude: 4.8981),
        ])
    )
    
    LocationListView(viewModel: viewModel)
        .environment(container)
}

