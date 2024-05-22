//
//  LoginView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject var authViewModel: UserAuthViewModel
    @State private var newAccount: Bool = false
    @State private var loginSucces: Bool = false


    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    Spacer()
                    Button("Create a new account", action: {
                        newAccount = true
                        
                    })
                    .navigationDestination(isPresented: $newAccount, destination: {RegisterView(authViewModel: UserAuthViewModel()).navigationBarBackButtonHidden(true)}).tint(.black)
                    
                    GroupBox(label:
                                Text("LOGIN").foregroundStyle(.black)
                             
                             , content: {
                        
                        VStack{
                            TextField("email", text: $authViewModel.auth.email).autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .tint(.black)
                            SecureField("password", text: $authViewModel.password).autocorrectionDisabled(true).tint(.black)
                            HStack{
                                Button("I forgot my password!", action: {
                                    authViewModel.SendPasswordReset()
                                }).tint(.black)
                                Spacer()
                                Button(action: {
                                    authViewModel.SignInWithEmailAndPassword()
                                    authViewModel.ListenForUserState()
                                }, label: {
                                    Text("SUBMIT").foregroundStyle(.white)
                                })
                                .navigationDestination(isPresented: $authViewModel.loggedIn, destination: {CreateOwnerView(authViewModel: UserAuthViewModel(), imageViewModel: ImageStoreViewModel(), ownerViewModel: OwnerViewModel()).navigationBarBackButtonHidden(true)}).foregroundStyle(.black)
                                .frame(width: 100, height: 30)
                                .background(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.black)
                                .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                            }
                        }
                        
                    }).groupBoxStyle(AuthGroupBoxStyle())
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                        .padding(EdgeInsets(top: 0, leading:20, bottom: 20, trailing: 20))
                }
            }.ignoresSafeArea()
                .onAppear{
                    authViewModel.SignOut()
                }
        }.ignoresSafeArea()
    }
}

struct LoginViewPreviews: PreviewProvider{
   static var previews: some View {
       LoginView(authViewModel: UserAuthViewModel())
    }
}
