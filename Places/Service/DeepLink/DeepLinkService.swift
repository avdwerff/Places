//
//  DeepLinkService.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import UIKit
import Foundation
import CoreLocation

final class DeepLinkService: DeepLinkServiceProtocol, Sendable {
    
    private let urlOpener: any URLOpening
    
    init(urlOpener: any URLOpening) {
        self.urlOpener = urlOpener
    }
    
    func openDeepLink(_ url: URL) async -> Bool {
        guard urlOpener.canOpen(url) else {
            print("Can't open the url: \(url)")
            return false
        }
        
        return await urlOpener.open(url)
    }
}
