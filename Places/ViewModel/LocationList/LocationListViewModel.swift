//
//  LocationListViewModel.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import Foundation
import CoreLocation

@Observable
final class LocationListViewModel {
    
    private(set) var state: ViewState<[Location]> = .idle
    
    private let locationService: any LocationServiceProtocol
    private var loadTask: Task<Void, Never>?
    
    var showingCustomLocation = false
    var customLatitude = ""
    var customLongitude = ""
    
    var navigationTitle = "Places"
    let addButtonAccessibilityLabel = "Add custom location"
    let addButtonAccessibilityHint = "Opens a form to enter coordinates"
    let loadingMessage = "Loading locations…"
    let loadingAccessibilityLabel = "Loading locations"
    let emptyTitle = "No locations"
    let emptyDescription = "No locations available."
    let emptySystemImage = "map"
    let errorLabel = "Something went wrong"
    let errorSystemImage = "exclamationmark.triangle"
    let retryButtonTitle = "Try Again"
    let errorAccessibilityHint = "Tap try again to reload"
    
    
    init(
        locationService: any LocationServiceProtocol
    ) {
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
        state = .loading
        return loadLocations()
    }
    
    var isCustomLocationValid: Bool {
        guard
            let lat = Double(customLatitude),
            let lon = Double(customLongitude)
        else { return false }
        return (-90...90).contains(lat) && (-180...180).contains(lon)
    }
}
