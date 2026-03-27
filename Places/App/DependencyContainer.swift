//
//  DependencyContainer.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import UIKit
import Foundation

@Observable
final class DependencyContainer {
    
    let httpClient: any HTTPClientProtocol
    let locationService: any LocationServiceProtocol
    let deepLinkService: any DeepLinkServiceProtocol
    
    init() {
        let client = HTTPClient()
        self.httpClient = client
        self.locationService = LocationService(httpClient: client)
        self.deepLinkService = DeepLinkService(urlOpener: AppURLOpener())
    }
    
    func makeLocationListViewModel() -> LocationListViewModel {
        LocationListViewModel(
            locationService: locationService
        )
    }
    
    func makeLocationListItemViewModel(for location: Location) -> LocationListItemViewModel {
        LocationListItemViewModel(
            location: location,
            deepLinkService: deepLinkService
        )
    }
    
    func makeCustomLocationViewModel() -> CustomLocationViewModel {
        CustomLocationViewModel(
            deepLinkService: deepLinkService
        )
    }
}
