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
    @State private var contributorFound: Bool = false
    @State var includePhone: Bool = false
    @ObservedObject var imageViewModel: ImageStoreViewModel
    @ObservedObject var annotationViewModel: MyAnnotationViewModel
    @ObservedObject var contributorViewModel: ContributorViewModel

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
                        TextField("Name", text: $annotationViewModel.myAnnotation.name).tint(.black)
                        TextField("Description", text: $annotationViewModel.myAnnotation.description).tint(.black)
                        Toggle(isOn: $includePhone, label: {
                            Text("Include a number to reach you?")
                        })
                        if(includePhone){
                            TextField("Phone#", text: $annotationViewModel.myAnnotation.phone)
                        }
                        Button("Pin to My Location", action: {
                            let location = myLocation.requestLocation()
                            annotationViewModel.myAnnotation.long = location.coordinate.longitude
                            annotationViewModel.myAnnotation.lat = location.coordinate.latitude
                            showMap = true
                        }).sheet(isPresented: $showMap, content: {
                            Map {
                                Marker("You are here.", coordinate: CLLocationCoordinate2D(latitude: annotationViewModel.myAnnotation.lat, longitude: annotationViewModel.myAnnotation.long))
                            }.ignoresSafeArea()
                        })
                        Button(action: {
                            imageViewModel.uploadImage(uiImage: UIImage(data: imageViewModel.imageStore.imgData)!)
                        }, label: {
                            Text("Next").foregroundStyle(.white)
                        })
                        .onChange(of: imageViewModel.success)
                        {
                            annotationViewModel.myAnnotation.email = Auth.auth().currentUser!.email!
                            annotationViewModel.myAnnotation.imageUrl = imageViewModel.imageStore.url
                            annotationViewModel.myAnnotation.found = true
                            annotationViewModel.myAnnotation.lost = false
                            annotationViewModel.createAnnotation()
                            contributorViewModel.contributor.markers.append(annotationViewModel.myAnnotation.id ?? "")
                            contributorViewModel.updateContributor()
                        }
                        .navigationDestination(isPresented: $contributorViewModel.success, destination: {
                            ProfileContributorView(contributorViewModel: ContributorViewModel())
                        })
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
                contributorViewModel.contributor.id = Auth.auth().currentUser!.uid
                Task{
                    contributorFound = await contributorViewModel.getContributor()
                }
                
            }
        }

    }
}

#Preview {
    AnnotationView(imageViewModel: ImageStoreViewModel(), annotationViewModel: MyAnnotationViewModel(), contributorViewModel: ContributorViewModel())
}
