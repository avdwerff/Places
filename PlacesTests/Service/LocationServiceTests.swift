//
//  LocationServiceTests.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import Testing
import Foundation
@testable import Places

@Suite("LocationService")
struct LocationServiceTests {
    
    // MARK: - Helpers
    
    private func makeSUT(
        client: MockHTTPClient = MockHTTPClient()
    ) -> LocationService {
        let service = LocationService(httpClient: client)
        return service
    }
    
    // MARK: - Success
    
    @Test("Returns decoded locations on success")
    func fetchLocationsSuccess() async throws {
        let client = MockHTTPClient()
        let expected = [
            Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041),
            Location(name: "Rotterdam", latitude: 51.9225, longitude: 4.4792),
        ]
        client.stub(LocationsResponse(locations: expected))
        let sut = makeSUT(client: client)
        
        let result = try await sut.fetchLocations()
        
        #expect(result.count == 2)
        #expect(result.first?.name == "Amsterdam")
        #expect(result.last?.name == "Rotterdam")
    }
    
    @Test("Returns empty array when no locations")
    func fetchLocationsEmpty() async throws {
        let client = MockHTTPClient()
        client.stub(LocationsResponse(locations: []))
        let sut = makeSUT(client: client)
        
        let result = try await sut.fetchLocations()
        
        #expect(result.isEmpty)
    }
    
    @Test("Handles locations with nil name")
    func fetchLocationsNilName() async throws {
        let client = MockHTTPClient()
        client.stub(LocationsResponse(locations: [
            Location(name: nil, latitude: 52.0, longitude: 4.0)
        ]))
        let sut = makeSUT(client: client)
        
        let result = try await sut.fetchLocations()
        
        #expect(result.first?.description == "52.0, 4.0")
    }
    
    // MARK: - Errors
    
    @Test("Propagates network error")
    func fetchLocationsNetworkError() async {
        let client = MockHTTPClient()
        client.stubError(.noConnection)
        let sut = makeSUT(client: client)
        
        do {
            _ = try await sut.fetchLocations()
            Issue.record("Expected NetworkError")
        } catch {
            #expect(error == .noConnection)
        }
    }
    
    @Test("Propagates decoding error")
    func fetchLocationsDecodingError() async {
        let client = MockHTTPClient()
        client.stubError(.decodingFailed(description: "Invalid format"))
        let sut = makeSUT(client: client)
        
        do {
            _ = try await sut.fetchLocations()
            Issue.record("Expected NetworkError")
        } catch {
            guard case .decodingFailed = error else {
                Issue.record("Wrong error: \(error)")
                return
            }
        }
    }
}
