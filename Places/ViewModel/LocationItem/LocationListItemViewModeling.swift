//
//  DeepLinkViewModeling.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

protocol LocationListItemViewModeling {
    var didFailToOpen: Bool { get }
    var locationName: String { get }
    var coordinateDescription: String { get }
    var accessibilityDescription: String { get }
    
    func openInWikipedia() async
}
