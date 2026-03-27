//
//  LocationItemViewModelTests.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Testing
import Foundation
@testable import Places

@Suite("LocationListItemViewModel")
@MainActor
struct LocationListItemViewModelTests {
    
    private func makeSUT(
        location: Location = Location(name: "Test", latitude: 52.37, longitude: 4.89),
        shouldSucceed: Bool = true
    ) -> (sut: LocationListItemViewModel, service: MockDeepLinkService) {
        let service = MockDeepLinkService()
        service.shouldSucceed = shouldSucceed
        let sut = LocationListItemViewModel(location: location, deepLinkService: service)
        return (sut, service)
    }
    
    // MARK: - Properties
    
    @Test("locationName returns name when present")
    func locationNameWithName() {
        let (sut, _) = makeSUT(location: Location(name: "Amsterdam", latitude: 52.37, longitude: 4.89))
        
        #expect(sut.locationName == "Amsterdam")
    }
    
    @Test("locationName returns fallback when nil")
    func locationNameWithoutName() {
        let (sut, _) = makeSUT(location: Location(name: nil, latitude: 52.37, longitude: 4.89))
        
        #expect(sut.locationName == "No name")
    }
    
    @Test("coordinateDescription delegates to location")
    func coordinateDescription() {
        let location = Location(name: "Test", latitude: 52.3676, longitude: 4.9041)
        let (sut, _) = makeSUT(location: location)
        
        #expect(sut.coordinateDescription == location.coordinateDescription)
    }
    
    @Test("accessibilityDescription delegates to location")
    func accessibilityDescription() {
        let location = Location(name: "Test", latitude: 52.3676, longitude: 4.9041)
        let (sut, _) = makeSUT(location: location)
        
        #expect(sut.accessibilityDescription == location.accessibilityDescription)
    }
    
    @Test("accessibilityHint is set")
    func accessibilityHint() {
        let (sut, _) = makeSUT()
        
        #expect(sut.accessibilityHint == "Opens this location in Wikipedia")
    }
    
    @Test("alertTitle is set")
    func alertTitle() {
        let (sut, _) = makeSUT()
        
        #expect(sut.alertTitle == "Unable to open Wikipedia")
    }
    
    @Test("alertMessage is set")
    func alertMessage() {
        let (sut, _) = makeSUT()
        
        #expect(sut.alertMessage == "Make sure Wikipedia is installed on your device.")
    }
    
    @Test("didFailToOpen is initially false")
    func didFailToOpenInitialState() {
        let (sut, _) = makeSUT()
        
        #expect(sut.didFailToOpen == false)
    }
    
    // MARK: - openInWikipedia
    
    @Test("openInWikipedia constructs correct URL")
    func openInWikipediaURL() async {
        let (sut, service) = makeSUT(location: Location(name: "Test", latitude: 52.37, longitude: 4.89))
        
        await sut.openInWikipedia()
        
        #expect(service.openedURL?.absoluteString == "wikipedia://places?latitude=52.37&longitude=4.89")
    }
    
    @Test("openInWikipedia sets didFailToOpen false on success")
    func openInWikipediaSuccess() async {
        let (sut, _) = makeSUT(shouldSucceed: true)
        
        await sut.openInWikipedia()
        
        #expect(sut.didFailToOpen == false)
    }
    
    @Test("openInWikipedia sets didFailToOpen true on failure")
    func openInWikipediaFailure() async {
        let (sut, _) = makeSUT(shouldSucceed: false)
        
        await sut.openInWikipedia()
        
        #expect(sut.didFailToOpen == true)
    }
}
