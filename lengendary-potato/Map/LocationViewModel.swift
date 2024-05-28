//
//  LocationViewModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/28/24.
//

import Foundation
import SwiftUI
import CoreLocationUI
import MapKit

@MainActor
class LocationViewModel: ObservableObject {
    @ObservedObject var locationManager = LocationManager()
    @Published var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var myAddress: String = ""
    
    func getMyLocation() {
        if(locationManager.authStatus == .notDetermined || locationManager.authStatus == .denied || locationManager.authStatus == .restricted) {
            locationManager.requestLocation()
        }
        else {
            self.myLocation = locationManager.location!
        }
    }
}
