//
//  LocationServiceProtocol.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

protocol LocationServiceProtocol: Sendable {
    func fetchLocations() async throws(NetworkError) -> [Location]
}
