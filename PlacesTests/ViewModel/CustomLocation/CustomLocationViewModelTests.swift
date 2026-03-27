//
//  CustomLocationViewModelTests.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Testing
import Foundation
@testable import Places

// MARK: - Mock


// MARK: - Tests

@Suite("CustomLocationViewModel")
@MainActor struct CustomLocationViewModelTests {
    
    private func makeSUT(
        shouldSucceed: Bool = true
    ) -> (sut: CustomLocationViewModel, service: MockDeepLinkService) {
        let service = MockDeepLinkService()
        service.shouldSucceed = shouldSucceed
        let sut = CustomLocationViewModel(deepLinkService: service)
        return (sut, service)
    }
    
    // MARK: - Initial State
    
    @Test("initial state has empty coordinates")
    func initialState() {
        let (sut, _) = makeSUT()
        
        #expect(sut.latitude == "")
        #expect(sut.longitude == "")
        #expect(sut.didFailToOpen == false)
    }
    
    // MARK: - isValid
    
    @Test("isValid returns false when latitude is empty")
    func isValidEmptyLatitude() {
        let (sut, _) = makeSUT()
        sut.longitude = "4.89"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns false when longitude is empty")
    func isValidEmptyLongitude() {
        let (sut, _) = makeSUT()
        sut.latitude = "52.37"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns false when latitude is not a number")
    func isValidInvalidLatitude() {
        let (sut, _) = makeSUT()
        sut.latitude = "abc"
        sut.longitude = "4.89"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns false when longitude is not a number")
    func isValidInvalidLongitude() {
        let (sut, _) = makeSUT()
        sut.latitude = "52.37"
        sut.longitude = "abc"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns false when latitude is out of range")
    @MainActor
    func isValidLatitudeOutOfRange() {
        let (sut, _) = makeSUT()
        sut.latitude = "91"
        sut.longitude = "4.89"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns false when latitude is below range")
    func isValidLatitudeBelowRange() {
        let (sut, _) = makeSUT()
        sut.latitude = "-91"
        sut.longitude = "4.89"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns false when longitude is out of range")
    func isValidLongitudeOutOfRange() {
        let (sut, _) = makeSUT()
        sut.latitude = "52.37"
        sut.longitude = "181"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns false when longitude is below range")
    func isValidLongitudeBelowRange() {
        let (sut, _) = makeSUT()
        sut.latitude = "52.37"
        sut.longitude = "-181"
        
        #expect(sut.isValid == false)
    }
    
    @Test("isValid returns true for valid coordinates")
    func isValidValidCoordinates() {
        let (sut, _) = makeSUT()
        sut.latitude = "52.37"
        sut.longitude = "4.89"
        
        #expect(sut.isValid == true)
    }
    
    @Test("isValid returns true at boundary values")
    func isValidBoundaryValues() {
        let (sut, _) = makeSUT()
        
        sut.latitude = "90"
        sut.longitude = "180"
        #expect(sut.isValid == true)
        
        sut.latitude = "-90"
        sut.longitude = "-180"
        #expect(sut.isValid == true)
    }
    
    // MARK: - openButtonAccessibilityHint
    
    @Test("openButtonAccessibilityHint when valid")
    func accessibilityHintWhenValid() {
        let (sut, _) = makeSUT()
        sut.latitude = "52.37"
        sut.longitude = "4.89"
        
        #expect(sut.openButtonAccessibilityHint == "Opens the entered location in Wikipedia")
    }
    
    @Test("openButtonAccessibilityHint when invalid")
    func accessibilityHintWhenInvalid() {
        let (sut, _) = makeSUT()
        
        #expect(sut.openButtonAccessibilityHint == "Enter valid coordinates first")
    }
    
    // MARK: - openInWikipedia
    
    @Test("openInWikipedia does nothing when coordinates invalid")
    func openInWikipediaInvalidCoordinates() async {
        let (sut, service) = makeSUT()
        
        await sut.openInWikipedia()
        
        #expect(service.openedURL == nil)
        #expect(sut.didFailToOpen == false)
    }
    
    @Test("openInWikipedia constructs correct URL")
    func openInWikipediaURL() async {
        let (sut, service) = makeSUT()
        sut.latitude = "52.37"
        sut.longitude = "4.89"
        
        await sut.openInWikipedia()
        
        #expect(service.openedURL?.absoluteString == "wikipedia://places?latitude=52.37&longitude=4.89")
    }
    
    @Test("openInWikipedia sets didFailToOpen false on success")
    func openInWikipediaSuccess() async {
        let (sut, _) = makeSUT(shouldSucceed: true)
        sut.latitude = "52.37"
        sut.longitude = "4.89"
        
        await sut.openInWikipedia()
        
        #expect(sut.didFailToOpen == false)
    }
    
    @Test("openInWikipedia sets didFailToOpen true on failure")
    func openInWikipediaFailure() async {
        let (sut, _) = makeSUT(shouldSucceed: false)
        sut.latitude = "52.37"
        sut.longitude = "4.89"
        
        await sut.openInWikipedia()
        
        #expect(sut.didFailToOpen == true)
    }
}
