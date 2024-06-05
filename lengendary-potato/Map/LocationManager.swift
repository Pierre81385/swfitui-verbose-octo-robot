//
//  LocationManager.swift
//  lengendary-potato
//
//  Created by m1_air on 5/28/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocationCoordinate2D?
    @Published var degrees: Double = 0
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    @Published var success: Bool = false

    let manager = CLLocationManager()
    
    func requestLocation() -> CLLocation {
        authStatus = manager.authorizationStatus
        manager.requestLocation()
        return manager.location!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override init() {
        super.init()
        manager.delegate = self
        manager.startUpdatingHeading()
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        degrees = newHeading.trueHeading
    }
    
    func forwardGeocoding(address: String) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Failed to retrieve location")
                    return
                }
                
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                    self.location = coordinate
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        }
}
