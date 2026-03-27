//
//  CustomLocationViewModel.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Foundation
import Observation

@Observable
final class CustomLocationViewModel {
    
    private let deepLinkService: any DeepLinkServiceProtocol
    
    var latitude: String = ""
    var longitude: String = ""
    var didFailToOpen = false
    
    // MARK: - Text properties
    
    let coordinatesSectionTitle = "Coordinates"
    let latitudeLabel = "Latitude"
    let latitudeAccessibilityHint = "Enter a value between minus 90 and 90"
    let longitudeLabel = "Longitude"
    let longitudeAccessibilityHint = "Enter a value between minus 180 and 180"
    let openButtonTitle = "Open in Wikipedia"
    let navigationTitle = "Custom Location"
    let cancelButtonTitle = "Cancel"
    let alertTitle = "Unable to Open"
    let alertButtonTitle = "OK"
    let alertMessage = "Wikipedia app could not be opened. Please ensure it is installed."
    
    var openButtonAccessibilityHint: String {
        isValid
        ? "Opens the entered location in Wikipedia"
        : "Enter valid coordinates first"
    }
    
    // MARK: - Computed properties
    
    var isValid: Bool {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            return false
        }
        return (-90...90).contains(lat) && (-180...180).contains(lon)
    }
    
    init(deepLinkService: any DeepLinkServiceProtocol) {
        self.deepLinkService = deepLinkService
    }
    
    func openInWikipedia() async {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else { return }
        
        let urlString = "wikipedia://places?latitude=\(lat)&longitude=\(lon)"
        guard let url = URL(string: urlString) else {
            didFailToOpen = true
            return
        }
        
        didFailToOpen = !(await deepLinkService.openDeepLink(url))
    }
}

