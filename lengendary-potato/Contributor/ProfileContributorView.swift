//
//  OwnerImageView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/22/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileContributorView: View {
    @StateObject var contributorViewModel: ContributorViewModel
    @State private var contributorFound: Bool = false
    @State private var locationShared: Bool = false
    @State private var showMapWithAddress: Bool = false
    @State private var addMarker: Bool = false
    @State private var showGallery: Bool = false
    @State private var logout: Bool = false
    @State private var showMainMap: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                if(contributorFound){
                    VStack{
                        HStack{
                            Button(action: {
                                logout = true
                            }, label: {
                                Image(systemName: "chevron.backward")
                                .tint(.black).padding()
                            }).navigationDestination(isPresented: $logout, destination: {
                                LoginView(authViewModel: UserAuthViewModel()).navigationBarBackButtonHidden(true).foregroundStyle(.black)
                            })
                            .padding()
                            Spacer()
                            Button(action: {
                                showMainMap = true
                            }, label: {
                                Image(systemName: "map.fill").tint(.black).padding()
                            }).navigationDestination(isPresented: $showMainMap, destination: {
                                AnnotationMapView(homeLat: $contributorViewModel.contributor.lat, homeLong: $contributorViewModel.contributor.long, annotationViewModel: MyAnnotationViewModel()
                                ).navigationBarBackButtonHidden(true)
                            })
                            .padding()
                        }
                        Spacer()
                        AsyncAwaitImageView(imageUrl: URL(string: contributorViewModel.contributor.avatarUrl)!)
                            .scaledToFill()
                            .frame(width: 325, height: 325)
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                        Text(contributorViewModel.contributor.name)
                        Text(contributorViewModel.contributor.email)
                        Text(contributorViewModel.contributor.address)
                        Spacer()
                        HStack{
                            Button(action: {
                                showGallery = true
                            }, label: {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .tint(.black)
                                    .padding()
                            }).navigationDestination(isPresented: $showGallery, destination: {
                                AnnotationListView(myAnnotationViewModel: MyAnnotationViewModel()).navigationBarBackButtonHidden(true)
                            }).tint(.black).padding()
                            Spacer()
                            Button(action: {
                                addMarker = true
                            }, label: {
                                Image(systemName: "photo.badge.plus.fill")
                                    .tint(.black)
                                    .padding()
                            }).navigationDestination(isPresented: $addMarker, destination: {
                                AnnotationView(imageViewModel: ImageStoreViewModel(), annotationViewModel: MyAnnotationViewModel(), contributorViewModel: ContributorViewModel()).navigationBarBackButtonHidden(true)
                            }).padding()
                        }
                    }
                } else {
                    Text("Loading Profile.")
                }
            }.onAppear{
                contributorFound = false
                if(Auth.auth().currentUser != nil){
                    contributorViewModel.contributor.id = Auth.auth().currentUser!.uid
                    Task{
                        contributorFound = await contributorViewModel.getContributor()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileContributorView(contributorViewModel: ContributorViewModel())
}


