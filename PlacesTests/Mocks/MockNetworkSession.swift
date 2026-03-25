//
//  MockNetworkSession.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Foundation
@testable import Places

struct MockNetworkSession: NetworkSession {
    let data: Data
    let response: URLResponse
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        (data, response)
    }
}
