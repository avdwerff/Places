//
//  LocationsResponse.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

nonisolated struct LocationsResponse: Codable, Sendable {
    let locations: [Location]
}
