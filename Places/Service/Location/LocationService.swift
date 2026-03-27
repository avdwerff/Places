//
//  LocationService.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

nonisolated final class LocationService: LocationServiceProtocol, Sendable {
    
    private let httpClient: any HTTPClientProtocol
    
    init(httpClient: any HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func fetchLocations() async throws(NetworkError) -> [Location] {
        let response: LocationsResponse = try await httpClient.perform(.locations)
        return response.locations
    }
}

extension Endpoint {
    static let locations = Endpoint(
        url: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    )
}
