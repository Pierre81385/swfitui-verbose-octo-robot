//
//  DogModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/13/24.
//

import Foundation
import SwiftUI
import MapKit

struct Dog: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var age: Int
    var size: String
    var breed: String
    var gender: String
    var imageUrl: String
    var description: String
    var liked: [String]
    var gallery: [String]
    var messages: [String]
    var missing: Bool
}

class DogModel: ObservableObject {
    
    @Published var aDog: Dog
    @Published var allDogs = [Dog]()
    @Published var status: String
    
    init(aDog: Dog, allDogs: [Dog] = [Dog](), status: String) {
        self.aDog = aDog
        self.allDogs = allDogs
        self.status = status
    }
    
    func getDog() {
        print("Get one Dog.")
    }
    
    func getDogs() {
        print("Get all Dogs.")
    }
    
    func addDog() {
        print("Add new Dog.")
    }
    
    func updateDog() {
        print("Update existing Dog.")
    }
    
    func removeDog() {
        print("Remove existing Dog.")
    }
}
