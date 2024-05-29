//
//  AnnotationViewModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

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
        
    }
    
}
