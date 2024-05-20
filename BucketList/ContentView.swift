//
//  ContentView.swift
//  BucketList
//
//  Created by Alisher Saideshov on 19.05.2024.
//

import SwiftUI
import MapKit
import CoreLocation


struct ContentView: View {
    @State private var viewModel = ViewModel()

    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center:  CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))

    var body: some View {
        NavigationStack {
            if viewModel.isUnlocked {
                ZStack {
                    MapReader { proxy in
                        Map(initialPosition: startPosition) {
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            viewModel.selectedPlace = location
                                        }
                                }
                            }
                        }
                        // Challenge 1
                        .mapStyle(viewModel.changingMapMode)
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        .sheet(item: $viewModel.selectedPlace) { place in
                            EditView(location: place) { updateLocation in
                                viewModel.update(location: updateLocation)
                            } onDelete: { deleteLocation in
                                viewModel.delete(location: deleteLocation)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.mapToggle()
                            }, label: {
                                Image(systemName: "map")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            })
                            .padding()
                        }
                    }
                }
            } else {
                Button("Unlock Places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    ContentView()
}
