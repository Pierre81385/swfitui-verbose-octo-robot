//
//  OwnerImageView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/22/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileContributorView: View {
    @ObservedObject var contributorViewModel: ContributorViewModel
    @State private var contributorFound: Bool = false
    @State private var locationShared: Bool = false
    @State private var showMapWithAddress: Bool = false
    @State private var addPet: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                if(contributorFound){
                    VStack{
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("View Map")
                        })
                        AsyncAwaitImageView(imageUrl: URL(string: contributorViewModel.contributor.avatarUrl)!)
                            .scaledToFill()
                            .frame(width: 325, height: 325)
                            .clipShape(Circle())
                        Text(contributorViewModel.contributor.name)
                        Text(contributorViewModel.contributor.email)
                        Button(action: {
                            addPet = true
                        }, label: {
                            Text("Add MapMarker!")
                        }).navigationDestination(isPresented: $addPet, destination: {
                            AnnotationView(imageViewModel: ImageStoreViewModel(), annotationViewModel: MyAnnotationViewModel(), contributorViewModel: ContributorViewModel())
                        })
                        Spacer()
                    }
                } else {
                    Text("Loading Profile.")
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
}

#Preview {
    ProfileContributorView(contributorViewModel: ContributorViewModel())
}


