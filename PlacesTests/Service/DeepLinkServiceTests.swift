//
//  DeepLinkServiceTests.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

import Testing
import Foundation
@testable import Places

@Suite("DeepLinkService")
@MainActor
struct DeepLinkServiceTests {
    
    // MARK: - Helpers
    
    private func makeSUT(
        canOpen: Bool = true,
        openResult: Bool = true
    ) -> (sut: DeepLinkService, opener: MockURLOpener) {
        let opener = MockURLOpener()
        opener.canOpenResult = canOpen
        opener.openResult = openResult
        let sut = DeepLinkService(urlOpener: opener)
        return (sut, opener)
    }
    
    private var anyURL: URL { URL(string: "maps://?q=52.37,4.89")! }
    
    // MARK: - Success
    
    @Test("Returns true when URL opens successfully")
    func opensSuccessfully() async {
        let (sut, opener) = makeSUT()
        
        let result = await sut.openDeepLink(anyURL)
        
        #expect(result == true)
        #expect(opener.openedURLs == [anyURL])
    }
    
    // MARK: - Failures
    
    @Test("Returns false when URL cannot be opened")
    func cannotOpen() async {
        let (sut, opener) = makeSUT(canOpen: false)
        
        let result = await sut.openDeepLink(anyURL)
        
        #expect(result == false)
        #expect(opener.openedURLs.isEmpty)
    }
    
    @Test("Returns false when opener fails")
    func openFails() async {
        let (sut, _) = makeSUT(openResult: false)
        
        let result = await sut.openDeepLink(anyURL)
        
        #expect(result == false)
    }
}
