//
//  CreateOwnerView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/20/24.
//

import SwiftUI
import FirebaseAuth

struct CreateOwnerView: View {
    @ObservedObject var authViewModel: UserAuthViewModel
    @ObservedObject var imageViewModel: ImageStoreViewModel
    @ObservedObject var ownerViewModel: OwnerViewModel
    @State private var imageSelected: Bool = false
    @State private var hasProfile: Bool = false
    
    var body: some View {
        if(hasProfile){
            Text("Loading Profile").navigationDestination(isPresented: $hasProfile, destination: {
                ProfileOwnerView(ownerViewModel: OwnerViewModel())
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
                                    Text("What should we call you?")
                                 , content: {
                            VStack{
                                TextField("My name is...", text: $ownerViewModel.owner.name).autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .tint(.black)
                                HStack{
                                    Spacer()
                                    
                                    Button(action: {
                                        imageViewModel.uploadImage(uiImage: UIImage(data: imageViewModel.imageStore.imgData)!)
                                    }, label: {
                                        Text("Next").foregroundStyle(.white)
                                    })
                                    .onChange(of: imageViewModel.success){
                                        ownerViewModel.owner.id = Auth.auth().currentUser!.uid
                                        ownerViewModel.owner.email = Auth.auth().currentUser!.email!
                                        ownerViewModel.owner.avatarUrl = imageViewModel.imageStore.url
                                        ownerViewModel.createOwner()
                                    }
                                    .navigationDestination(isPresented: $ownerViewModel.success, destination: {
                                        ProfileOwnerView(ownerViewModel: OwnerViewModel())
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
                        ownerViewModel.owner.id = Auth.auth().currentUser!.uid
                        Task{
                            hasProfile = await ownerViewModel.getOwner()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CreateOwnerView(authViewModel: UserAuthViewModel(), imageViewModel: ImageStoreViewModel(), ownerViewModel: OwnerViewModel())
}
