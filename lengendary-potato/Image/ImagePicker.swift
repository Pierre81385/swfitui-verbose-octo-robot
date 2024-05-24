//
//  ImagePicker.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI
import PhotosUI


struct ImagePickerView: View {
    @ObservedObject var imageStoreViewModel: ImageStoreViewModel
    @State private var selectToggle: Bool = true
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var saved: Bool = false

    
    var body: some View {
        ZStack {
           
              
                
                if (selectToggle) {
                   
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Image(systemName: "camera.circle")
                            .resizable()
                            .foregroundStyle(.black)
                            .frame(width: 50, height: 50)
                    }
                    .onChange(of: selectedImage) {
                        newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                imageStoreViewModel.imageStore.imgData = data
                                selectedImageData = data
                                selectToggle = false
                            }
                        }
                    }
                    
                        
                    
                    
                } else {
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        VStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 325, height: 325)
                            .clipShape(Circle())
                    }
                    }
                }
                        
            
        }.onAppear {
        }
    }
}

//#Preview {
//    ImagePickerView(imageStoreViewModel: ImageStoreViewModel())
//}
