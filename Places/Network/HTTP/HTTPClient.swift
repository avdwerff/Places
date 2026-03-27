//
//  HTTPClient.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Foundation

nonisolated final class HTTPClient: HTTPClientProtocol, Sendable {
    
    private let session: any NetworkSession
    
    init(session: any NetworkSession = URLSession.shared) {
        self.session = session
    }

    func perform<T: Decodable & Sendable>(
        _ endpoint: Endpoint
    ) async throws(NetworkError) -> T {
        let request = try endpoint.urlRequest()
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            throw error.toNetworkError
        } catch {
            throw .other(error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw .invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw .httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw .decodingFailed(description: error.localizedDescription)
        }
    }
}
