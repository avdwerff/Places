//
//  MockHTTPClient.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import Foundation
@testable import Places

final class MockHTTPClient: HTTPClientProtocol, @unchecked Sendable {
    var stubbedData: Data?
    var stubbedError: NetworkError?
    
    func stub<T: Encodable>(_ response: T) {
        stubbedData = try? JSONEncoder().encode(response)
        stubbedError = nil
    }
    
    func stubError(_ error: NetworkError) {
        stubbedError = error
        stubbedData = nil
    }
    
    func perform<T: Decodable & Sendable>(
        _ endpoint: Endpoint
    ) async throws(NetworkError) -> T {
        if let error = stubbedError {
            throw error
        }
        
        assert(stubbedData != nil, "No stubbed data..")
        
        do {
            return try JSONDecoder().decode(T.self, from: stubbedData!)
        } catch {
            throw .decodingFailed(description: error.localizedDescription)
        }
    }
}
