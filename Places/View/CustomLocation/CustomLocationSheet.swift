//
//  CustomLocationSheet.swift
//  Places
//
//  Created by Alexander van der Werff on 26/03/2026.
//

import SwiftUI

struct CustomLocationSheet: View {
    
    @Bindable var viewModel: CustomLocationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(viewModel.coordinatesSectionTitle) {
                    TextField(viewModel.latitudeLabel, text: $viewModel.latitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel(viewModel.latitudeLabel)
                        .accessibilityHint(viewModel.latitudeAccessibilityHint)
                    
                    TextField(viewModel.longitudeLabel, text: $viewModel.longitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel(viewModel.longitudeLabel)
                        .accessibilityHint(viewModel.longitudeAccessibilityHint)
                }
                
                Section {
                    Button(viewModel.openButtonTitle) {
                        Task {
                            await viewModel.openInWikipedia()
                        }
                    }
                    .disabled(!viewModel.isValid)
                    .accessibilityHint(viewModel.openButtonAccessibilityHint)
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(viewModel.cancelButtonTitle) { dismiss() }
                }
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.didFailToOpen) {
                Button(viewModel.alertButtonTitle, role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}
