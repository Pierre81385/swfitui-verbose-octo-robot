//
//  ImagePickerViewModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/17/24.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

class ImageStoreViewModel: ObservableObject {
    @Published var imageStore: ImageStore = ImageStore(url: "")
    @Published var isLoading: Bool = false
    @Published var uploaded: Bool = false
    @Published var status: String = ""
    
    let storage = Storage.storage()
    private var db = Firestore.firestore()
    
    func uploadImage(uiImage: UIImage) {
        isLoading = true
        let storageRef = storage.reference().child("images/\(uiImage.hash)")
        let data = uiImage.jpegData(compressionQuality: 0.3)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        if let data = data {
            storageRef.putData(data, metadata: metadata) {
                (metadata, error) in
                    if let error = error {
                        self.status = String(describing: error.localizedDescription)
                        self.uploaded = false
                    }
                
                if let metadata = metadata {
                    self.status = String(describing: metadata)
                }
                
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                      return
                    }
                    self.imageStore.url = downloadURL.absoluteString
                    self.saveImageURL()
                  }
            }
        }
        
    }
    
    func saveImageURL() {
           let docRef = db.collection("images").document()
           do {
               try docRef.setData(from: self.imageStore)
               self.status = "Success!"
               self.isLoading = false
               self.uploaded = true
           }
           catch {
               self.status = "Error: \(error.localizedDescription)"
               self.isLoading = false
               self.uploaded = false
           }
       }
}
