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

@MainActor class ContributorViewModel: ObservableObject {
    @Published var contributor: Contributor = Contributor(id: Auth.auth().currentUser?.uid ?? "", name: "", email: Auth.auth().currentUser?.email ?? "", address: "", long: 0.0, lat: 0.0, markers: [], avatarUrl: "")
    @Published var contributors: [Contributor] = []
    @Published var status: String = ""
    @Published var success: Bool = false
    
    private var db = Firestore.firestore()
    
    func getLocationByAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.contributor.address, completionHandler: { (placemarks, error) in
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
                self.contributor.lat = coordinate.latitude
                self.contributor.long = coordinate.longitude
            }
            else
            {
                print("No Matching Location Found")
            }
        })
    }
    
    func getContributor() async -> Bool {
        let docRef = db.collection("contributors").document(Auth.auth().currentUser?.uid ?? "")
        do {
            self.contributor = try await docRef.getDocument(as: Contributor.self)
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
    
    func getContributor() async {
        db.collection("contributors")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    self.status = "Error: \(String(describing: error?.localizedDescription))"
                    self.success = false
                    return
                }
                self.contributors = documents.compactMap { queryDocumentSnapshot -> Contributor? in
                    return try? queryDocumentSnapshot.data(as: Contributor.self)
                }
                self.status = "Success! Found Owners"
                self.success = true
            }

    }
    
    func createContributor() {
        
        let docRef = db.collection("contributors").document(contributor.id!)
        
        do {
            try docRef.setData(from: self.contributor)
            self.status = "Success!"
            self.success = true
        }
        catch {
            self.status = "Error: \(error.localizedDescription)"
            self.success = false
        }
    }
    
    func updateContributor() {
        if let id = contributor.id {
           let docRef = db.collection("contributors").document(id)
           do {
             try docRef.setData(from: contributor)
               self.status = "Success!"
               self.success = true
           }
           catch {
               self.status = "Error: \(error.localizedDescription)"
               self.success = false
           }
         }
    }
    
    func deleteContributor() {
        
    }
}
