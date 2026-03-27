//
//  MockURLOpener.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Foundation
@testable import Places

@MainActor
final class MockURLOpener: URLOpening {
    var canOpenResult = true
    var openResult = true
    var openedURLs: [URL] = []
    
    func canOpen(_ url: URL) -> Bool {
        canOpenResult
    }
    
    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return openResult
    }
}
