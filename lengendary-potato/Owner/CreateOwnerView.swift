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
    @State private var confirmPhotoGalleryAccess: Bool = false
    @State private var confirmLocationServices: Bool = false
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                ImagePickerView(viewModel: ImageStoreViewModel()).shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                Spacer()
                GroupBox(label:
                            Text(ownerViewModel.owner.email).foregroundStyle(.black)
                         
                         , content: {
                    VStack{
                        TextField("Display name...", text: $ownerViewModel.owner.name).autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .tint(.black)
                        Toggle("Allow Photo Access", isOn: $confirmPhotoGalleryAccess).tint(.black)
                        Toggle("Allow Location Services?", isOn: $confirmLocationServices).tint(.black)
                        
                        HStack{
                            Spacer()
                            if(imageViewModel.uploaded && confirmPhotoGalleryAccess && confirmLocationServices) {
                                Button(action: {
                                    authViewModel.CreateUser()
                                    authViewModel.ListenForUserState()
                                    
                                }, label: {
                                    Text("SUBMIT").foregroundStyle(.white)
                                })
                                .navigationDestination(isPresented: $authViewModel.loggedIn, destination: {CreateOwnerView(authViewModel: UserAuthViewModel(), imageViewModel: ImageStoreViewModel(), ownerViewModel: OwnerViewModel())}).foregroundStyle(.black)
                                .frame(width: 100, height: 30)
                                .background(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.black)
                                .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                                .padding(EdgeInsets(top: 8, leading:0, bottom: 0, trailing: 0))
                            }
                            

                        }
                    }
                }).groupBoxStyle(AuthGroupBoxStyle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                    .padding(EdgeInsets(top: 0, leading:20, bottom: 20, trailing: 20))
               
                
            }.ignoresSafeArea()
        }.onAppear{
            ownerViewModel.preFillFromAuth()
        }
    }
}

#Preview {
    CreateOwnerView(authViewModel: UserAuthViewModel(), imageViewModel: ImageStoreViewModel(), ownerViewModel: OwnerViewModel())
}
