//
//  DeepLinkServiceProtocol.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import CoreLocation

protocol DeepLinkServiceProtocol: Sendable {
    func openDeepLink(_ url: URL) async -> Bool
}
