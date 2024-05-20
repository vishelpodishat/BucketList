//
//  EditView+ViewModel.swift
//  BucketList
//
//  Created by Alisher Saideshov on 20.05.2024.
//

import Foundation
import SwiftUI

// Challenge 3
extension EditView {
    @Observable
    class ViewModel {
        var name: String
        var description: String
        var pages = [Page]()
        var location: Location
        var loadingState = LoadingState.loading


        init(location: Location) {
            name = location.name
            description = location.description
            self.location = location
        }

        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else { return }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                let item = try JSONDecoder().decode(Result.self, from: data)

                pages = item.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }

        func saveLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
    }
}





