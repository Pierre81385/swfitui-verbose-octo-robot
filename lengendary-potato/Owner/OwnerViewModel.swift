//
//  OwnerViewModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import MapKit

@MainActor class OwnerViewModel: ObservableObject {
    @Published var owner: Owner = Owner(id: Auth.auth().currentUser?.uid ?? "", name: "", email: Auth.auth().currentUser?.email ?? "", address: "", long: 0.0, lat: 0.0, markers: [], avatarUrl: "")
    @Published var owners: [Owner] = []
    @Published var status: String = ""
    @Published var success: Bool = false
    
    private var db = Firestore.firestore()
    
    func getLocationByAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.owner.address, completionHandler: { (placemarks, error) in
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
                self.owner.lat = coordinate.latitude
                self.owner.long = coordinate.longitude
            }
            else
            {
                print("No Matching Location Found")
            }
        })
    }
    
    func getOwner() async -> Bool {
        let docRef = db.collection("owners").document(Auth.auth().currentUser?.uid ?? "")
        do {
            self.owner = try await docRef.getDocument(as: Owner.self)
            self.status = "Success!"
            self.success = true
            return true
        }
        catch {
            self.status = "Error: \(error.localizedDescription)"
            self.success = false
            return false
        }
    }
    
    func getOwners() async {
        db.collection("owners")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    self.status = "Error: \(String(describing: error?.localizedDescription))"
                    self.success = false
                    return
                }
                self.owners = documents.compactMap { queryDocumentSnapshot -> Owner? in
                    return try? queryDocumentSnapshot.data(as: Owner.self)
                }
                self.status = "Success! Found Owners"
                self.success = true
            }

    }
    
    func createOwner() {
        
        let docRef = db.collection("owners").document(owner.id!)
        
        do {
            try docRef.setData(from: self.owner)
            self.status = "Success!"
            self.success = true
        }
        catch {
            self.status = "Error: \(error.localizedDescription)"
            self.success = false
        }
    }
    
    func updateOwner() {
        if let id = owner.id {
           let docRef = db.collection("owners").document(id)
           do {
             try docRef.setData(from: owner)
               self.status = "Success!"
               self.success = true
           }
           catch {
               self.status = "Error: \(error.localizedDescription)"
               self.success = false
           }
         }
    }
    
    func deleteOwner() {
        
    }
}
