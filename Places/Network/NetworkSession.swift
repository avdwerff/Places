//
//  NetworkSession.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Foundation

protocol NetworkSession: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
