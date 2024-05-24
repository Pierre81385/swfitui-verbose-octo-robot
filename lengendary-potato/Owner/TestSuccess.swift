//
//  OwnerImageView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/22/24.
//

import SwiftUI
import FirebaseAuth

struct SuccessView: View {
    @ObservedObject var ownerViewModel: OwnerViewModel
    @State private var ownerDocFound: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                if(ownerDocFound){
                    VStack{
                        Spacer()
                        AsyncAwaitImageView(imageUrl: URL(string: ownerViewModel.owner.avatarUrl)!)
                        Text(ownerViewModel.owner.name)
                        Text(ownerViewModel.owner.email)
                        
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
    SuccessView(ownerViewModel: OwnerViewModel())
}


