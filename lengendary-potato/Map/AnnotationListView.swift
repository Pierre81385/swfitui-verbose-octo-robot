//
//  AnnotationListView.swift
//  lengendary-potato
//
//  Created by m1_air on 6/10/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct AnnotationListView: View {
    @State private var back: Bool = false
    @State private var authenticatedUser = Auth.auth().currentUser
    @ObservedObject var myAnnotationViewModel: MyAnnotationViewModel
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            back = true
                        }, label: {
                            Image(systemName: "chevron.backward").foregroundStyle(.black).padding()
                        }).navigationDestination(isPresented: $back, destination: { ProfileContributorView(contributorViewModel: ContributorViewModel()).navigationBarBackButtonHidden(true).foregroundStyle(.black)})
                            .padding()
                        Spacer()
                    }
                    List(myAnnotationViewModel.myAnnotations, id: \.id) {
                        annotation in
                        if(annotation.myId == authenticatedUser?.uid) {
                            
                                GroupBox(annotation.name, content: {
                                    VStack{
                                            AsyncAwaitImageView(imageUrl: URL(string: annotation.imageUrl)!)
                                                .scaledToFill()
                                                .frame(width: 325, height: 325)
                                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                                .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                                            VStack{
                                                HStack{
                                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                                        Image(systemName: "trash.fill").foregroundStyle(.black)
                                                    }).padding()
                                                    Spacer()
                                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                                        Image(systemName: "location.fill.viewfinder").foregroundStyle(.black)
                                                    }).padding()
                                                }
                                                HStack{
                                                    Text(annotation.description)
                                                }
                                            }
                                        
                                        
                                    }
                                })
                               
                            
                        }
                    }.scrollContentBackground(.hidden)
                        .background(Color.white)
                }
            }.onAppear{
                Task{
                    await myAnnotationViewModel.getAnnotations()
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
