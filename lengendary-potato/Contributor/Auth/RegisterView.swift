//
//  RegisterView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    
    @ObservedObject var authViewModel: UserAuthViewModel
    @State private var verifyPassword: String = ""
    @State private var hasAccount: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(Color.gray.opacity(0.05))
                VStack{
                    Spacer()
                    Button("I have an account", action: {
                        hasAccount = true
                        
                    })
                    .navigationDestination(isPresented: $hasAccount, destination: {LoginView(authViewModel: UserAuthViewModel()).navigationBarBackButtonHidden(true)}).tint(.black)
                    GroupBox(label:
                                Text("REGISTER").foregroundStyle(.black)
                             
                             , content: {
                        
                        VStack{
                            TextField("email", text: $authViewModel.auth.email).autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .tint(.black)
                            SecureField("password", text: $authViewModel.password).autocorrectionDisabled(true).tint(.black)
                            SecureField("verify password", text: $verifyPassword).autocorrectionDisabled(true).tint(.black)
                            HStack{
                                Spacer()
                                Button(action: {
                                    authViewModel.CreateUser()
                                    authViewModel.ListenForUserState()
                                }, label: {
                                    Text("SUBMIT").foregroundStyle(.white)
                                })
                                .navigationDestination(isPresented: $authViewModel.loggedIn, destination: {CreateContributorView(authViewModel: UserAuthViewModel(), imageViewModel: ImageStoreViewModel(), contributorViewModel: ContributorViewModel()).navigationBarBackButtonHidden(true).tint(.black) }).foregroundStyle(.black)
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
                    print("signing out current user!")
                }
        }
    }
}

struct RegisterViewPreviews: PreviewProvider{
   static var previews: some View {
       RegisterView(authViewModel: UserAuthViewModel())
    }
}

