//
//  LocationListViewModeling.swift
//  Places
//
//  Created by Alexander van der Werff on 27/03/2026.
//

protocol LocationListViewModeling {
    var state: ViewState<[Location]> { get }
    var showingCustomLocation: Bool { get set }
    
    @discardableResult
    func loadLocations() -> Task<Void, Never>
    
    @discardableResult
    func refresh() -> Task<Void, Never>
}
