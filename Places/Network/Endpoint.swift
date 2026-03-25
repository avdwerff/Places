//
//  Endpoint.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Foundation

nonisolated struct Endpoint: Sendable {
    let url: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]
    let timeoutInterval: TimeInterval
    
    init(
        url: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        timeoutInterval: TimeInterval = 30
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.timeoutInterval = timeoutInterval
    }
    
    func urlRequest() throws(NetworkError) -> URLRequest {
        guard var components = URLComponents(string: url) else {
            throw .invalidURL
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw .invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
