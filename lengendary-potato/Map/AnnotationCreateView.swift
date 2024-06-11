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
    @State private var back: Bool = false
    @State private var myLocation = LocationManager()
    @State private var myLocationSelected: Bool = false
    @State private var myHouseSelected: Bool = false
    @State private var showMap: Bool = false
    @State private var contributorFound: Bool = false
    @State private var includePhone: Bool = false
    @ObservedObject var imageViewModel: ImageStoreViewModel
    @ObservedObject var annotationViewModel: MyAnnotationViewModel
    @ObservedObject var contributorViewModel: ContributorViewModel

    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        back = true
                    }, label: {
                        Image(systemName: "chevron.backward").foregroundStyle(.black).padding()
                    }).navigationDestination(isPresented: $back, destination: { ProfileContributorView(contributorViewModel: ContributorViewModel()).navigationBarBackButtonHidden(true).foregroundStyle(.black)})
                        .padding()
                    Spacer()
                }
                ImagePickerView(imageStoreViewModel: imageViewModel).onChange(of: imageViewModel.imageStore.imgData, {
                })                        .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)

                Spacer()
            }
            VStack{
                Spacer()
                GroupBox(label:
                            Text("Map Marker Details")
                         , content: {
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                annotationViewModel.myAnnotation.lost = true
                                annotationViewModel.myAnnotation.found = false
                                annotationViewModel.myAnnotation.spotted = false
                            }, label: {
                                VStack{
                                    Image(systemName: "viewfinder.trianglebadge.exclamationmark").foregroundStyle(annotationViewModel.myAnnotation.lost ? .green : .black)
                                    Text("Lost")
                                }
                            })
                            Spacer()
                            Button(action: {
                                annotationViewModel.myAnnotation.lost = false
                                annotationViewModel.myAnnotation.found = true
                                annotationViewModel.myAnnotation.spotted = false
                            }, label: {
                                VStack{
                                    Image(systemName: "scope").foregroundStyle(annotationViewModel.myAnnotation.found ? .green : .black)
                                    Text("Found")
                                }
                            })
                            Spacer()
                            Button(action: {
                                annotationViewModel.myAnnotation.lost = false
                                annotationViewModel.myAnnotation.found = false
                                annotationViewModel.myAnnotation.spotted = true
                            }, label: {
                                VStack{
                                    Image(systemName: "photo").foregroundStyle(annotationViewModel.myAnnotation.spotted ? .green : .black)
                                    Text("Spotted")
                                }
                            })
                            Spacer()
                        }.padding()
                        TextField("Name", text: $annotationViewModel.myAnnotation.name).tint(.black)
                        TextField("Description", text: $annotationViewModel.myAnnotation.description).tint(.black)
                        Toggle(isOn: $includePhone, label: {
                            Text("Include a number to reach you?")
                        })
                        if(includePhone){
                            TextField("Phone#", text: $annotationViewModel.myAnnotation.phone)
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                myHouseSelected.toggle()
                                annotationViewModel.myAnnotation.long = contributorViewModel.contributor.long
                                annotationViewModel.myAnnotation.lat = contributorViewModel.contributor.lat
                                annotationViewModel.reverseGeocoding(latitude: contributorViewModel.contributor.lat, longitude: contributorViewModel.contributor.long)
                                if(myHouseSelected){
                                    myLocationSelected = false
                                }
                            }, label: {
                                VStack{
                                    Image(systemName: "house.fill").foregroundStyle(myHouseSelected ? .green : .black)
                                    Text("My Address")
                                }
                            })
                            Spacer()
                            Button(action: {
                                myLocationSelected.toggle()
                                let location = myLocation.requestLocation()
                                annotationViewModel.myAnnotation.long = location.coordinate.longitude
                                annotationViewModel.myAnnotation.lat = location.coordinate.latitude
                                if(myLocationSelected){
                                    myHouseSelected = false
                                }
                                showMap = true
                            }, label: {
                                VStack{
                                    Image(systemName: "location.circle.fill").foregroundStyle(myLocationSelected ? .green : .black)
                                    Text("My Location")
                                }
                            }).sheet(isPresented: $showMap, content: {
                                Map {
                                    Marker(annotationViewModel.myAnnotation.address, coordinate: CLLocationCoordinate2D(latitude: annotationViewModel.myAnnotation.lat, longitude: annotationViewModel.myAnnotation.long))
                                }.onAppear{
                                    annotationViewModel.reverseGeocoding(latitude: annotationViewModel.myAnnotation.lat, longitude: annotationViewModel.myAnnotation.long)
                                }
                                .ignoresSafeArea()
                            })
                            Spacer()
                        }.padding()
                        Button(action: {
                            imageViewModel.uploadImage(uiImage: UIImage(data: imageViewModel.imageStore.imgData)!)
                        }, label: {
                            Text("Next").foregroundStyle(.white)
                        })
                        .onChange(of: imageViewModel.success)
                        {
                            annotationViewModel.myAnnotation.email = Auth.auth().currentUser!.email!
                            annotationViewModel.myAnnotation.imageUrl = imageViewModel.imageStore.url
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
        }
        .onAppear{
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
