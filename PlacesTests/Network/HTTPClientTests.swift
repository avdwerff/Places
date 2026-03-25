//
//  HTTPClientTests.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Testing
import Foundation
@testable import Places

// MARK: - HTTPClient Tests

// needs to be serialized because of MockURLProtocol
@Suite("HTTPClient")
struct HTTPClientTests {
    
    // MARK: - Test model
    
    private struct MockResponse: Codable, Sendable, Equatable {
        let id: Int
        let name: String
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        data: Data = Data(),
        statusCode: Int = 200
    ) -> HTTPClient {
        let response = HTTPURLResponse(
            url: URL(string: "https://any.url")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return HTTPClient(session: MockNetworkSession(
            data: data,
            response: response
        ))
    }
    
    private let endpoint = Endpoint(url: "https://api.example.com/test")
    
    // MARK: - Success
    
    @Test("Decodes valid JSON response")
    func successfulDecode() async throws {
        let expected = MockResponse(id: 1, name: "Test")
        let data = try JSONEncoder().encode(expected)
        let sut = makeSUT(data: data)
        
        let result: MockResponse = try await sut.perform(endpoint)
        
        #expect(result == expected)
    }
    
    @Test("Decodes array response")
    func decodesArray() async throws {
        let expected = [MockResponse(id: 1, name: "A"), MockResponse(id: 2, name: "B")]
        let data = try JSONEncoder().encode(expected)
        let sut = makeSUT(data: data)
        
        let result: [MockResponse] = try await sut.perform(endpoint)
        
        #expect(result.count == 2)
        #expect(result == expected)
    }
    
    // MARK: - HTTP Errors
    
    @Test("Throws httpError for non-2xx status codes", arguments: [400, 401, 403, 404, 500, 503])
    func httpErrors(statusCode: Int) async {
        let sut = makeSUT(statusCode: statusCode)
        
        do {
            let _: MockResponse = try await sut.perform(endpoint)
            Issue.record("Expected NetworkError.httpError")
        } catch {
            #expect(error == .httpError(statusCode: statusCode))
        }
    }
    
    @Test("Accepts all 2xx status codes", arguments: [200, 201, 204])
    func successStatusCodes(statusCode: Int) async throws {
        let data = try JSONEncoder().encode(MockResponse(id: 1, name: "OK"))
        let sut = makeSUT(data: data, statusCode: statusCode)
        
        let result: MockResponse = try await sut.perform(endpoint)
        
        #expect(result.id == 1)
    }
    
    // MARK: - Decoding Errors
    
    @Test("Throws decoding Failed for malformed JSON")
    func malformedJSON() async {
        let sut = makeSUT(data: Data("not json".utf8))
        
        do {
            let _: MockResponse = try await sut.perform(endpoint)
            Issue.record("Expected NetworkError.decodingFailed")
        } catch {
            guard case .decodingFailed = error else {
                Issue.record("Wrong error: \(error)")
                return
            }
        }
    }
    
    @Test("Throws decoding Failed for wrong JSON structure")
    func wrongStructure() async {
        let sut = makeSUT(data: Data(#"{"wrong": "keys"}"#.utf8))
        
        do {
            let _: MockResponse = try await sut.perform(endpoint)
            Issue.record("Expected NetworkError.decodingFailed")
        } catch {
            guard case .decodingFailed = error else {
                Issue.record("Wrong error: \(error)")
                return
            }
        }
    }
    
    // MARK: - Invalid Endpoint
    
    @Test("Throws invalidURL for bad URL")
    func invalidURL() async {
        let badEndpoint = Endpoint(url: "h ttp://example.com")
        
        let sut = makeSUT()
        
        do {
            let _: MockResponse = try await sut.perform(badEndpoint)
            Issue.record("Expected NetworkError.invalidURL")
        } catch {
            #expect(error == .invalidURL)
        }
    }
}
