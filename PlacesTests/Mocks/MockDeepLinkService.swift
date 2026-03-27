//
//  MockDeepLinkService.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Foundation
@testable import Places

final class MockDeepLinkService: DeepLinkServiceProtocol, @unchecked Sendable {
    var openedURL: URL?
    var shouldSucceed = true
    
    func openDeepLink(_ url: URL) async -> Bool {
        openedURL = url
        return shouldSucceed
    }
}
