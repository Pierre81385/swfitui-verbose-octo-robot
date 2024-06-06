//
//  CreateOwnerView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/20/24.
//

import SwiftUI
import FirebaseAuth
import MapKit

struct CreateOwnerView: View {
    @ObservedObject var authViewModel: UserAuthViewModel
    @ObservedObject var imageViewModel: ImageStoreViewModel
    @ObservedObject var contributorViewModel: ContributorViewModel
    @State var myLocation = LocationManager()
    @State private var imageSelected: Bool = false
    @State private var hasProfile: Bool = false
    @State private var showMap: Bool = false
    
    var body: some View {
        if(hasProfile){
            Text("Loading Profile").navigationDestination(isPresented: $hasProfile, destination: {
                ProfileContributorView(contributorViewModel: ContributorViewModel())
            })
        }
        else {
            NavigationStack{
                ZStack{
                    VStack{
                        Spacer()
                        ImagePickerView(imageStoreViewModel: imageViewModel).onChange(of: imageViewModel.imageStore.imgData, {
                            imageSelected = true
                        })
                        if(imageSelected){
                            Text("Nice.")
                        } else {
                            Text("Add a photo of yourself.")
                        }
                        Spacer()
                        GroupBox(label:
                                    Text("Profile")
                                 , content: {
                            VStack{
                                TextField("My name is...", text: $contributorViewModel.contributor.name).autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .tint(.black)
                                TextField("Address", text: $contributorViewModel.contributor.address).autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .tint(.black)
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        contributorViewModel.getLocationByAddress()
                                        showMap = true
                                    }, label: {
                                        Image(systemName: "magnifyingglass")
                                    }).sheet(isPresented: $showMap, content: {
                                            Map {
                                                Marker(contributorViewModel.contributor.address, coordinate: CLLocationCoordinate2D(latitude: contributorViewModel.contributor.lat, longitude: contributorViewModel.contributor.long))
                                            }.ignoresSafeArea()
                                        
                                    })
                                }
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        imageViewModel.uploadImage(uiImage: UIImage(data: imageViewModel.imageStore.imgData)!)
                                    }, label: {
                                        Text("Next").foregroundStyle(.white)
                                    })
                                    .onChange(of: imageViewModel.success){
                                        contributorViewModel.contributor.id = Auth.auth().currentUser!.uid
                                        contributorViewModel.contributor.email = Auth.auth().currentUser!.email!
                                        contributorViewModel.contributor.avatarUrl = imageViewModel.imageStore.url
                                        contributorViewModel.createContributor()
                                    }
                                    .navigationDestination(isPresented: $contributorViewModel.success, destination: {
                                        ProfileContributorView(contributorViewModel: ContributorViewModel())
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
                        
                        
                    }.ignoresSafeArea()
                }.onAppear{
                    if(Auth.auth().currentUser != nil){
                        contributorViewModel.contributor.id = Auth.auth().currentUser!.uid
                        Task{
                            hasProfile = await contributorViewModel.getContributor()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CreateOwnerView(authViewModel: UserAuthViewModel(), imageViewModel: ImageStoreViewModel(), contributorViewModel: ContributorViewModel())
}
