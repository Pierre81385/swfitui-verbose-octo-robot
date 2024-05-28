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
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    @State private var startingPoint: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 39.7392,
        longitude: -104.9903
    )
    @State private var endingPoint: CLLocationCoordinate2D?
    
    private var travelTime: String? {
        // Check if there is a route to get the info from
        guard let route else { return nil }
    
        // Set up a date formater
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
    
        // Format the travel time to the format you want to display it
        return formatter.string(from: route.expectedTravelTime)
    }
    
    func getDirections() {
        self.route = nil
        
        // Check if there is a selected result
        guard selectedResult != nil else { return }
        
        // Create and configure the request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.startingPoint))
        request.destination = self.selectedResult
        request.transportType = .automobile
        
        // Get the directions based on the request
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
            
        }
    }

    var body: some View {
        ZStack {
            VStack {
                if let myLocation = locationManager.location {
                    VStack {
                        Text("Latitude: \(myLocation.latitude.formatted(.number.precision(.fractionLength(0)))), Longitude: \(myLocation.longitude.formatted(.number.precision(.fractionLength(0))))".uppercased())
                        MapReader { proxy in
                            
                            Map(position: $region, selection: $selectedResult) {
                                // Adding the marker for the starting point
                                Marker("", systemImage: "dial.low", coordinate: myLocation)
                                Marker("You are here", systemImage: "person", coordinate: myLocation)
                                
                                // Show the route if it is available
                                if let route {
                                    MapPolyline(route)
                                        .stroke(.blue, lineWidth: 5)
                                }
                                if let endingPoint {
                                    Marker(travelTime ?? "", systemImage: "mappin", coordinate: endingPoint)
                                }
                                
                            }
                            .onChange(of: selectedResult){
                                getDirections()
                            }
                            .onTapGesture { position in
                                        if let coordinate = proxy.convert(position, from: .local) {
                                            selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                                            endingPoint = coordinate
                                        }
                                    }
                            .onAppear {
                                self.selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: myLocation))
                                self.startingPoint = myLocation
                                self.region = MapCameraPosition.region(
                                    MKCoordinateRegion(
                                        center: myLocation,
                                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                                    )
                                )
                                self.endingPoint = myLocation
                            }
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
        }.onAppear{
            
        }
    }
}

#Preview {
    MapView()
}
