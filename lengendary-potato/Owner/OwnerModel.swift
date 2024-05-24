//
//  OwnerModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/14/24.
//

import Foundation
import FirebaseFirestore

struct Owner: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var long: Double
    var lat: Double
    var myDogs: [String]
    var avatarUrl: String
}
