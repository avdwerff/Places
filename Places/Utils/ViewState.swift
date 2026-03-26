//
//  ViewState.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

nonisolated enum ViewState<T: Sendable>: Sendable {
    case idle
    case loading
    case loaded(T)
    case error(NetworkError)
}

extension ViewState: Equatable where T: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): true
        case (.loading, .loading): true
        case (.loaded(let l), .loaded(let r)): l == r
        case (.error(let l), .error(let r)): l == r
        default: false
        }
    }
}

extension ViewState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var value: T? {
        if case .loaded(let v) = self { return v }
        return nil
    }
    
    var error: NetworkError? {
        if case .error(let e) = self { return e }
        return nil
    }
}
