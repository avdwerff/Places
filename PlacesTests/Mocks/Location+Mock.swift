//
//  Location+Mock.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

@testable import Places

extension Location {
    static let mockAmsterdam = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
    static let mockRotterdam = Location(name: "Rotterdam", latitude: 51.9225, longitude: 4.4792)
    static let mockList: [Location] = [.mockAmsterdam, .mockRotterdam]
}
