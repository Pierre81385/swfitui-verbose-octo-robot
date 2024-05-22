//
//  PetViewModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI

class PetViewModel: ObservableObject {
    @Published var pet: Pet = Pet(owner: "", type: petType.cat, name: "", age: 0, size: size.extraLarge, breed: "", gender: gender.female, mainImageUrl: "", gallery: [], savedBy: [])
    @Published var pets: [Pet] = []
    @Published var status: String = ""
    @Published var isLoading: Bool = false
    
    func getPet() {
        
    }
    
    func getPets() {
        
    }
    
    func newPet() {
        
    }
    
    func updatePet() {
        
    }
    
    func deletePet() {
        
    }
}
