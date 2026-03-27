//
//  URLOpening.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import UIKit

protocol URLOpening: Sendable {
    func canOpen(_ url: URL) -> Bool
    func open(_ url: URL) async -> Bool
}

final class AppURLOpener: URLOpening {
    
    func canOpen(_ url: URL) -> Bool {
        UIApplication.shared.canOpenURL(url)
    }
    
    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url, options: [:])
    }
}
