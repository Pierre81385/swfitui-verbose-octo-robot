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

class OwnerViewModel: ObservableObject {
    @Published var owner: Owner = Owner(id: Auth.auth().currentUser?.uid ?? "", name: "", email: Auth.auth().currentUser?.email ?? "", long: 0.0, lat: 0.0, myDogs: [], avatarUrl: "")
    @Published var owners: [Owner] = []
    @Published var status: String = ""
    @Published var success: Bool = false
    
    private var db = Firestore.firestore()
    
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
    
    func getLocationByAddress(address: String) {
        
    }
    
    func getOwners() {
        
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
        
    }
    
    func deleteOwner() {
        
    }
}
