//
//  MapView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/28/24.
//

import Foundation
import SwiftUI
import CoreLocationUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var region = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.7392, longitude: -104.9903),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    var body: some View {
        ZStack {
            
                if let myLocation = locationManager.location {
                        MapReader { proxy in
                            Map() {
                                Marker("You", systemImage: "person", coordinate: myLocation)
                            }
                            .onAppear {
                                self.region = MapCameraPosition.region(
                                    MKCoordinateRegion(
                                        center: myLocation,
                                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                                    )
                                )
                            }
                        }
                    
                } else {
                    LocationButton {
                        locationManager.requestLocation()
                    }
                    .labelStyle(.iconOnly)
                    .cornerRadius(20)
                }
        }
    }
}

#Preview {
    MapView()
}
