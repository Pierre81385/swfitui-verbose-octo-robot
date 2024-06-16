//
//  AnnotationScrollView.swift
//  lengendary-potato
//
//  Created by m1_air on 6/14/24.
//

import SwiftUI
import FirebaseAuth

struct AnnotationScrollView: View {
    
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
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 0){
                            ForEach(myAnnotationViewModel.myAnnotations, id: \.id) {
                                annotation in
                                if(annotation.myId == authenticatedUser?.uid) {
                                    
                                    VStack{
                                        Text(annotation.name).fontWeight(.semibold)
                                        Text("5 miles away").fontWeight(.ultraLight)
                                        AsyncAwaitImageView(imageUrl: URL(string: annotation.imageUrl)!)
                                            .scaledToFill()
                                            .frame(width: 350, height: 475)
                                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                            .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 30)
                                            .containerRelativeFrame(.horizontal)
                                            .scrollTransition(.animated, axis: .horizontal) {content, phase in content.opacity(phase.isIdentity ? 1.0 : 0.8)
                                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                            }
                                        Text(annotation.description).fontWeight(.thin)
                                        Spacer()
                                    }
                                }
                            }
                    }.scrollTargetBehavior(.paging)
                        }
                    Spacer()
                    }
                }
            }.onAppear{
                Task{
                    await myAnnotationViewModel.getAnnotations()
                }
            }
            //.ignoresSafeArea(.all, edges: .bottom)
        }
    }


#Preview {
    AnnotationScrollView(myAnnotationViewModel: MyAnnotationViewModel())
}
