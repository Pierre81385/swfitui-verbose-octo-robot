//
//  OwnerImageView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/22/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileOwnerView: View {
    @ObservedObject var ownerViewModel: OwnerViewModel
    @State private var ownerDocFound: Bool = false
    @State private var locationShared: Bool = false
    @State private var showMapWithAddress: Bool = false
    @State private var addPet: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                if(ownerDocFound){
                    VStack{
                        Spacer()
                        AsyncAwaitImageView(imageUrl: URL(string: ownerViewModel.owner.avatarUrl)!)
                            .scaledToFill()
                            .frame(width: 325, height: 325)
                            .clipShape(Circle())
                        Text(ownerViewModel.owner.name)
                        Text(ownerViewModel.owner.email)
                        Button(action: {
                            addPet = true
                        }, label: {
                            Text("Add MapMarker!")
                        }).navigationDestination(isPresented: $addPet, destination: {
                            AnnotationView(imageViewModel: ImageStoreViewModel(), petAnnotationViewModel: PetAnnotationViewModel(), ownerViewModel: OwnerViewModel())
                        })
                        Spacer()
                    }
                } else {
                    Text("Loading Profile.")
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
}

#Preview {
    ProfileOwnerView(ownerViewModel: OwnerViewModel())
}


