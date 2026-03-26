//
//  LocationListViewModelTests.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import Testing
import Foundation
@testable import Places

@Suite("LocationListViewModel")
@MainActor
struct LocationListViewModelTests {
    
    // MARK: - Helpers
    
    private func makeSUT(
        service: MockLocationService = MockLocationService()
    ) -> LocationListViewModel {
        LocationListViewModel(locationService: service)
    }
    
    // MARK: - Initial State
    
    @Test("Initial state is idle")
    func initialState() {
        let sut = makeSUT()
        #expect(sut.state == .idle)
    }
    
    // MARK: - Loading
    
    @Test("Transitions to loaded on success")
    func loadSuccess() async {
        let service = MockLocationService()
        service.stubbedLocations = Location.mockList
        let sut = makeSUT(service: service)
        
        await sut.loadLocations().value
        
        #expect(sut.state == .loaded(Location.mockList))
    }
    
    @Test("Transitions to error on failure")
    func loadError() async {
        let service = MockLocationService()
        service.stubbedError = .noConnection
        let sut = makeSUT(service: service)
        
        await sut.loadLocations().value
        
        #expect(sut.state == .error(.noConnection))
    }
    
    @Test("Handles empty response")
    func emptyResponse() async {
        let service = MockLocationService()
        service.stubbedLocations = []
        let sut = makeSUT(service: service)
        
        await sut.loadLocations().value
        
        #expect(sut.state == .loaded([]))
    }
    
    // MARK: - Cancellation
    
    @Test("New load cancels previous")
    func cancelsOnReload() async {
        let service = MockLocationService()
        service.stubbedLocations = Location.mockList
        let sut = makeSUT(service: service)
        
        sut.loadLocations()
        await sut.loadLocations().value
        
        #expect(sut.state == .loaded(Location.mockList))
    }
    
    // MARK: - Refresh
    
    @Test("Refresh resets state and reloads")
    func refresh() async {
        let service = MockLocationService()
        service.stubbedLocations = Location.mockList
        let sut = makeSUT(service: service)
        await sut.loadLocations().value
        
        await sut.refresh().value
        
        #expect(sut.state == .loaded(Location.mockList))
        #expect(service.fetchCallCount == 2)
    }
}
