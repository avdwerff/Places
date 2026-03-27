//
//  PlacesApp.swift
//  Places
//
//  Created by Alexander van der Werff on 24/03/2026.
//

import SwiftUI

@main
struct PlacesApp: App {
    
    @State private var container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            LocationListView(viewModel: container.makeLocationListViewModel())
                .environment(container)
        }
    }
}
