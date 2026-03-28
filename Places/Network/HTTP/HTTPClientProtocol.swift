//
//  HTTPClientProtocol.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Foundation

protocol HTTPClientProtocol: Sendable {
    func perform<T: Decodable & Sendable>(
        _ endpoint: Endpoint
    ) async throws(NetworkError) -> T
}
