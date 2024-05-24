//
//  ImageStoreModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/17/24.
//

import Foundation
import PhotosUI

struct ImageStore: Codable, Equatable, Identifiable {
    var id = UUID().uuidString
    var imgData: Data
    var url: String
}
