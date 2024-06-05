//
//  AnnotationViewModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

struct PetAnnotation: Codable, Identifiable {
    @DocumentID var id: String?
    var lost: Bool
    var found: Bool
    var petName: String
    var petDescription: String
    var petAddress: String
    var phoneNumber: String
    var email :String
    var long: Double
    var lat: Double
    var imageUrl: String
    var myId: String
}

class PetAnnotationViewModel: ObservableObject {
    @Published var petAnnotation: PetAnnotation = PetAnnotation(lost: true, found: false, petName: "", petDescription: "", petAddress: "", phoneNumber: "", email: "", long: 0.0, lat: 0.0, imageUrl: "", myId: Auth.auth().currentUser?.uid ?? "")
    @Published var petAnnotations: [PetAnnotation] = []
    @Published var status: String = ""
    @Published var success: Bool = false
    private var db = Firestore.firestore()
    
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
                    self.petAnnotation.lat = coordinate.latitude
                    self.petAnnotation.long = coordinate.longitude
                    print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                }
                else
                {
                    print("No Matching Location Found")
                }
            })
        }
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Failed to retrieve address")
                    return
                }
                
                if let placemarks = placemarks, let placemark = placemarks.first {
                    print(placemarks)
                }
                else
                {
                    print("No Matching Address Found")
                }
            })
        }
    
    func createPetAnnotation() {
        let docRef = db.collection("petAnnotations").document()
        do {
            try docRef.setData(from: self.petAnnotation)
            self.status = "Success!"
            self.success = true
        } catch {
            self.status = "Error: \(error.localizedDescription)"
            self.success = false
        }
        self.petAnnotation.id = docRef.documentID
    }
    
    func getPetAnnotation(id: String) {
        let docRef = db.collection("petAnnotations").document()
    }
    
}
