//
//  ImageUploader.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI
import PhotosUI


    
    /// A class that manages an image that a person selects in the Photos picker.
@MainActor final class ImageAttachment: ObservableObject, Identifiable {
  
    @Published var selection = [PhotosPickerItem]() {
        didSet {
            attachments.removeAll()
            // Update the attachments according to the current picker selection.
            _ = selection.map { item in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        attachments.append(data)
                    }
                }
            }
        
        }
    }
    
    /// An array of image attachments for the picker's selected photos.
    @Published var attachments = [Data]()
   
}
