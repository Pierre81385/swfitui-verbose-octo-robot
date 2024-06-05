//
//  AnnotationView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/28/24.
//

import SwiftUI
import FirebaseAuth
import MapKit

struct AnnotationView: View {
    @State var myLocation = LocationManager()
    @State var showMap: Bool = false
    @State private var ownerDocFound: Bool = false
    @State var includePhone: Bool = false
    @ObservedObject var imageViewModel: ImageStoreViewModel
    @ObservedObject var petAnnotationViewModel: PetAnnotationViewModel
    @ObservedObject var ownerViewModel: OwnerViewModel

    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("Upload a photo.")
                ImagePickerView(imageStoreViewModel: imageViewModel).onChange(of: imageViewModel.imageStore.imgData, {
                })
                Spacer()
                GroupBox(label:
                            Text("Found!")
                         , content: {
                    VStack{
                        TextField("Name", text: $petAnnotationViewModel.petAnnotation.petName).tint(.black)
                        TextField("Breed or Description", text: $petAnnotationViewModel.petAnnotation.petDescription).tint(.black)
                        Toggle(isOn: $includePhone, label: {
                            Text("Include a number to reach you?")
                        })
                        if(includePhone){
                            TextField("Phone#", text: $petAnnotationViewModel.petAnnotation.phoneNumber)
                        }
                        Button("FInd My Location", action: {
                            let location = myLocation.requestLocation()
                            petAnnotationViewModel.petAnnotation.long = location.coordinate.longitude
                            petAnnotationViewModel.petAnnotation.lat = location.coordinate.latitude
                            showMap = true
                        }).sheet(isPresented: $showMap, content: {
                            Map {
                                Marker("You are here.", coordinate: CLLocationCoordinate2D(latitude: petAnnotationViewModel.petAnnotation.lat, longitude: petAnnotationViewModel.petAnnotation.long))
                            }.ignoresSafeArea()
                        })
                        Button(action: {
                            imageViewModel.uploadImage(uiImage: UIImage(data: imageViewModel.imageStore.imgData)!)
                        }, label: {
                            Text("Next").foregroundStyle(.white)
                        })
                        .onChange(of: imageViewModel.success)
                        {
                            petAnnotationViewModel.petAnnotation.email = Auth.auth().currentUser!.email!
                            petAnnotationViewModel.petAnnotation.imageUrl = imageViewModel.imageStore.url
                            petAnnotationViewModel.petAnnotation.found = true
                            petAnnotationViewModel.petAnnotation.lost = false
                            petAnnotationViewModel.createPetAnnotation()
                            ownerViewModel.owner.markers.append(petAnnotationViewModel.petAnnotation.id ?? "")
                            ownerViewModel.updateOwner()
                        }
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                        .padding(EdgeInsets(top: 8, leading:0, bottom: 0, trailing: 0))
                    }
                }).groupBoxStyle(AuthGroupBoxStyle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                    .padding(EdgeInsets(top: 60, leading:20, bottom: 20, trailing: 20))
            }
        }.onAppear{
            if(Auth.auth().currentUser != nil){
                ownerViewModel.owner.id = Auth.auth().currentUser!.uid
                Task{
                    ownerDocFound = await ownerViewModel.getOwner()
                }
                
            }
        }

    }
}

#Preview {
    AnnotationView(imageViewModel: ImageStoreViewModel(), petAnnotationViewModel: PetAnnotationViewModel(), ownerViewModel: OwnerViewModel())
}
