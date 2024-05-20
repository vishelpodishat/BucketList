//
//  EditView.swift
//  BucketList
//
//  Created by Alisher Saideshov on 19.05.2024.
//

import SwiftUI

enum LoadingState {
    case loading, loaded, failed
}

struct EditView: View {
    @Environment(\.dismiss) var dismiss

    @State private var viewModel: ViewModel

    var onSave: (Location) -> Void
    var onDelete: (Location) -> Void

    var body: some View {
        NavigationStack {
            Form {
                placeDetailsSection
                nearbyPlacesSection
            }
            .navigationTitle("Place details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete") {
                        onDelete(viewModel.location)
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(viewModel.saveLocation())
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }

    private var placeDetailsSection: some View {
        Section {
            TextField("Place name", text: $viewModel.name)
            TextField("Description", text: $viewModel.description)
        }
    }

    private var nearbyPlacesSection: some View {
        Section("Nearby..") {
            switch viewModel.loadingState {
            case .loaded:
                ForEach(viewModel.pages, id: \.pageid) { page in
                    VStack(alignment: .leading) {
                        Text(page.title)
                            .font(.headline)
                        Text(page.description)
                            .italic()
                    }
                }
            case .loading:
                Text("Loading…")
            case .failed:
                Text("Please try again later.")
            }
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void) {
        self.onSave = onSave
        self.onDelete = onDelete

        _viewModel = State(initialValue: ViewModel(location: location))
    }
}
