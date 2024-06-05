//
//  OwnerModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/14/24.
//

import Foundation
import FirebaseFirestore

struct Owner: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var address: String
    var long: Double
    var lat: Double
    var markers: [String]
    var avatarUrl: String
}
