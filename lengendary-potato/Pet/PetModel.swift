//
//  PetModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI

enum petType: Codable {
    case dog
    case cat
}

enum size: Codable {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
}

enum gender: Codable {
    case male
    case female
    case unknown
}

struct Pet: Codable, Identifiable {
    var id: String = UUID().uuidString
    var owner: String
    var type: petType
    var name: String
    var age: Int
    var size: size
    var breed: String
    var gender: gender
    var mainImageUrl: String
    var gallery: [String] //array of urls
    var savedBy: [String] //array of user_ids
}
