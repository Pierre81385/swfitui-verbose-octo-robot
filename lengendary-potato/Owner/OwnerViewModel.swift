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
    @Published var owner: Owner = Owner(id: "", name: "", email: "", long: 0.0, lat: 0.0, myDogs: [], avatarUrl: "")
    @Published var owners: [Owner] = []
    @Published var status: String = ""
    @Published var isLoading: Bool = false
    
    private var db = Firestore.firestore()
    
    func preFillFromAuth() {
        owner.id = Auth.auth().currentUser?.uid ?? ""
        owner.email = Auth.auth().currentUser?.email ?? ""
    }
    
    func getOwner() async {
        let docRef = db.collection("owners").document(owner.id)
        do {
            owner = try await docRef.getDocument(as: Owner.self)
            self.status = "Success!"
            self.isLoading = false
        }
        catch {
            self.status = "Error: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    func getLocationByAddress(address: String) {
        
    }
    
    func getOwners() {
        
    }
    
    func createOwner() {
        let docRef = db.collection("owners").document(owner.id)
        do {
            try docRef.setData(from: self.owner)
            self.status = "Success!"
            self.isLoading = false
        }
        catch {
            self.status = "Error: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    func updateOwner() {
        
    }
    
    func deleteOwner() {
        
    }
}
