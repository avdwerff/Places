//
//  LocationListItemView.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import SwiftUI

struct LocationListItemView: View {
    
    @Bindable var viewModel: LocationListItemViewModel
    
    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 24
    @ScaledMetric(relativeTo: .caption) private var padding: CGFloat = 12
    
    var body: some View {
        Button {
            Task { await viewModel.openInWikipedia() }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                
                Text(viewModel.locationName)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text(viewModel.coordinateDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(padding)
            .background(.background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewModel.accessibilityDescription)
        .accessibilityHint(viewModel.accessibilityHint)
        .accessibilityAddTraits(.isButton)
        .alert(viewModel.alertTitle, isPresented: $viewModel.didFailToOpen) {
            Button(viewModel.alertButtonTitle, role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
