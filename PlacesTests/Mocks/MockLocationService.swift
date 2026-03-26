//
//  MockLocationService.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import Foundation
@testable import Places

final class MockLocationService: LocationServiceProtocol, @unchecked Sendable {
    var stubbedLocations: [Location] = []
    var stubbedError: NetworkError?
    private(set) var fetchCallCount = 0
    
    func fetchLocations() async throws(NetworkError) -> [Location] {
        fetchCallCount += 1
        if let error = stubbedError {
            throw error
        }
        return stubbedLocations
    }
}
