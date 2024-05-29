//
//  AnnotationView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/28/24.
//

import SwiftUI
import FirebaseAuth

struct AnnotationView: View {
    @State var myLocation = LocationManager()
    @ObservedObject var imageViewModel: ImageStoreViewModel
    @ObservedObject var petAnnotationViewModel: PetAnnotationViewModel
    
    var body: some View {
        VStack{
            Text("Tell us about your pet!")
            ImagePickerView(imageStoreViewModel: imageViewModel).onChange(of: imageViewModel.imageStore.imgData, {
            })
            GroupBox(label:
                        Text("My Pet")
                     , content: {
                VStack{
                    TextField("Name", text: $petAnnotationViewModel.petAnnotation.petName)
                    TextField("Short Description", text: $petAnnotationViewModel.petAnnotation.petDescription)
                    TextField("Home Address", text: $petAnnotationViewModel.petAnnotation.petAddress)
                    
                    Button("Find my Address", action: {
                        
                    })
                    Text("or")
                    Button("Use My Location", action: {
                        let location = myLocation.requestLocation()
                        petAnnotationViewModel.petAnnotation.long = location.coordinate.longitude
                        petAnnotationViewModel.petAnnotation.lat = location.coordinate.latitude
                    })
                    Text(String(describing: petAnnotationViewModel.petAnnotation.long))
                    Text(String(describing: petAnnotationViewModel.petAnnotation.lat))
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            imageViewModel.uploadImage(uiImage: UIImage(data: imageViewModel.imageStore.imgData)!)
                        }, label: {
                            Text("Next").foregroundStyle(.white)
                        })
                        .onChange(of: imageViewModel.success){
                            petAnnotationViewModel.petAnnotation.id = Auth.auth().currentUser!.uid
                            petAnnotationViewModel.petAnnotation.email = Auth.auth().currentUser!.email!
                            petAnnotationViewModel.petAnnotation.imageUrl = imageViewModel.imageStore.url
                            petAnnotationViewModel.createPetAnnotation()
                        }
                        .navigationDestination(isPresented: $petAnnotationViewModel.success, destination: {
                           
                        }).foregroundStyle(.black)
                            .frame(width: 100, height: 30)
                            .background(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                            .padding(EdgeInsets(top: 8, leading:0, bottom: 0, trailing: 0))
                    }
                    
                    
                    
                }
            }).groupBoxStyle(AuthGroupBoxStyle())
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                .padding(EdgeInsets(top: 60, leading:20, bottom: 20, trailing: 20))
        }
    }
}

#Preview {
    AnnotationView(imageViewModel: ImageStoreViewModel(), petAnnotationViewModel: PetAnnotationViewModel())
}
