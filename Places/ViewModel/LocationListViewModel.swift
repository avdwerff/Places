//
//  LocationListViewModel.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import Foundation

@Observable
final class LocationListViewModel {
    
    private(set) var state: ViewState<[Location]> = .idle
    
    private let locationService: any LocationServiceProtocol
    private var loadTask: Task<Void, Never>?
    
    init(locationService: any LocationServiceProtocol) {
        self.locationService = locationService
    }
    
    @discardableResult
    func loadLocations() -> Task<Void, Never> {
        loadTask?.cancel()
        let task = Task {
            state = .loading
            
            do throws(NetworkError) {
                let locations = try await locationService.fetchLocations()
                guard !Task.isCancelled else { return }
                state = .loaded(locations)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error)
            }
        }
        loadTask = task
        return task
    }

    @discardableResult
    func refresh() -> Task<Void, Never> {
        state = .idle
        return loadLocations()
    }
}
