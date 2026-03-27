//
//  LocationListItemViewModel.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Foundation
import CoreLocation

@Observable
final class LocationListItemViewModel {
    private let location: Location
    private let deepLinkService: any DeepLinkServiceProtocol
    
    var didFailToOpen = false
    var locationName: String { location.name ?? "No name" }
    var coordinateDescription: String { location.coordinateDescription }
    var accessibilityDescription: String { location.accessibilityDescription }
    
    let accessibilityHint = "Opens this location in Wikipedia"
    let alertTitle = "Unable to open Wikipedia"
    let alertMessage = "Make sure Wikipedia is installed on your device."
    let alertButtonTitle = "OK"
    
    init(location: Location, deepLinkService: any DeepLinkServiceProtocol) {
        self.location = location
        self.deepLinkService = deepLinkService
    }
    
    func openInWikipedia() async {
        let urlString = "wikipedia://places?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)"
        guard let url = URL(string: urlString) else {
            didFailToOpen = true
            return
        }
        didFailToOpen = !(await deepLinkService.openDeepLink(url))
    }
}
