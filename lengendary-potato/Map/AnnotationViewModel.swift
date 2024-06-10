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
import MapKit

struct MyAnnotation: Codable, Identifiable {
    @DocumentID var id: String?
    var lost: Bool
    var found: Bool
    var name: String
    var description: String
    var address: String
    var phone: String
    var email :String
    var long: Double
    var lat: Double
    var imageUrl: String
    var myId: String
}

class MyAnnotationViewModel: ObservableObject {
    @Published var myAnnotation: MyAnnotation = MyAnnotation(lost: true, found: false, name: "", description: "", address: "", phone: "", email: "", long: 0.0, lat: 0.0, imageUrl: "", myId: Auth.auth().currentUser?.uid ?? "")
    @Published var myAnnotations: [MyAnnotation] = []
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
                    self.myAnnotation.lat = coordinate.latitude
                    self.myAnnotation.long = coordinate.longitude
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
                    self.myAnnotation.address = String("\(placemark.thoroughfare ?? ""), \(placemark.subThoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.subAdministrativeArea ?? ""), \(placemark.postalCode ?? "")")
                }
                else
                {
                    print("No Matching Address Found")
                    self.myAnnotation.address = "No Address Found"
                }
            })
        }
    
    func createAnnotation() {
        let docRef = db.collection("annotations").document()
        do {
            try docRef.setData(from: self.myAnnotation)
            self.status = "Success!"
            self.success = true
        } catch {
            self.status = "Error: \(error.localizedDescription)"
            self.success = false
        }
        self.myAnnotation.id = docRef.documentID
    }
    
    func getAnnotation(id: String) async {
        let docRef = db.collection("annotations").document(id)
        do {
            self.myAnnotation = try await docRef.getDocument(as: MyAnnotation.self)
            self.status = "Success!"
            self.success = true
        }
        catch {
            self.status = "Error: \(error.localizedDescription)"
            self.success = false
        }
    }
    
    func getAnnotations() async {
        db.collection("annotations")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    self.status = "Error: \(String(describing: error?.localizedDescription))"
                    self.success = false
                    return
                }
                self.myAnnotations = documents.compactMap { queryDocumentSnapshot -> MyAnnotation? in
                    return try? queryDocumentSnapshot.data(as: MyAnnotation.self)
                }
                self.status = "Success! Found Owners"
                self.success = true
            }
    }
    
    func updateAnnotation() {
        if let id = myAnnotation.id {
           let docRef = db.collection("annotations").document(id)
           do {
             try docRef.setData(from: myAnnotation)
               self.status = "Success!"
               self.success = true
           }
           catch {
               self.status = "Error: \(error.localizedDescription)"
               self.success = false
           }
         }
    }
    
    func deletePetAnnotation() {
        
    }
    
}
