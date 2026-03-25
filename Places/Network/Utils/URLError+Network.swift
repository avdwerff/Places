//
//  URLError+Network.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Foundation


extension URLError {
    var toNetworkError: NetworkError {
        switch code {
        case .timedOut: .timeout
        case .notConnectedToInternet, .networkConnectionLost: .noConnection
        case .cancelled: .cancelled
        default: .other(localizedDescription)
        }
    }
}
