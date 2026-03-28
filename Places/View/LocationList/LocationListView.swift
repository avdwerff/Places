//
//  LocationListView.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import SwiftUI

struct LocationListView: View {
    
    @Environment(DependencyContainer.self) private var container
    @Bindable private var viewModel: LocationListViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private enum Constants {
        static let gridSpacing: CGFloat = 16
    }
    
    init(viewModel: LocationListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(viewModel.navigationTitle)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.showingCustomLocation = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel(viewModel.addButtonAccessibilityLabel)
                        .accessibilityHint(viewModel.addButtonAccessibilityHint)
                    }
                }
                .refreshable { await viewModel.refresh().value }
                .task { viewModel.loadLocations() }
                .sheet(isPresented: $viewModel.showingCustomLocation) {
                    CustomLocationSheet(viewModel: container.makeCustomLocationViewModel())
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView(viewModel.loadingMessage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityLabel(viewModel.loadingAccessibilityLabel)
            
        case .loaded(let locations):
            if locations.isEmpty {
                ContentUnavailableView(
                    viewModel.emptyTitle,
                    systemImage: viewModel.emptySystemImage,
                    description: Text(viewModel.emptyDescription)
                )
            } else {
                locationGrid(locations)
            }
            
        case .error(let error):
            ContentUnavailableView {
                Label(viewModel.errorLabel, systemImage: viewModel.errorSystemImage)
            } description: {
                Text(error.localizedDescription)
            } actions: {
                Button(viewModel.retryButtonTitle) { viewModel.loadLocations() }
                    .buttonStyle(.bordered)
            }
            .accessibilityElement(children: .combine)
            .accessibilityHint(viewModel.errorAccessibilityHint)
        }
    }
    
    private func locationGrid(_ locations: [Location]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
                ForEach(locations, id: \.self) { location in
                    LocationListItemView(
                        viewModel: container.makeLocationListItemViewModel(for: location)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
        }
    }
}
