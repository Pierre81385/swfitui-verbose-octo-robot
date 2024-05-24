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
    
    var body: some View {
        ZStack{
            VStack{
                ImagePickerView(imageStoreViewModel: imageViewModel)
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
                                    SuccessView()
                                }).foregroundStyle(.black)
                                .frame(width: 100, height: 30)
                                .background(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.black)
                                .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                                .padding(EdgeInsets(top: 8, leading:0, bottom: 0, trailing: 0))
                            }
                            

                        
                    }
                }).groupBoxStyle(AuthGroupBoxStyle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                    .padding(EdgeInsets(top: 60, leading:20, bottom: 20, trailing: 20))
               
                
            }.ignoresSafeArea()
        }
    }
}

#Preview {
    CreateOwnerView(authViewModel: UserAuthViewModel(), imageViewModel: ImageStoreViewModel(), ownerViewModel: OwnerViewModel())
}
