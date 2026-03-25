//
//  NetworkError.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

enum NetworkError: Error, Equatable {
    case timeout
    case noConnection
    case cancelled
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed(description: String)
    case other(String)
}
