//
//  DogFullView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/14/24.
//

import Foundation
import SwiftUI

struct DogFullView: View {
    @Binding var dog: Dog
    @Binding var toggle: Bool
    @State private var showSheet: Bool = true
    
    var body: some View {
        GeometryReader { proxy in
            
                
            
            ZStack{
                AsyncImage(url: URL(string: dog.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: proxy.size.width, minHeight: proxy.size.height)
                        
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        // Since the AsyncImagePhase enum isn't frozen,
                        // we need to add this currently unused fallback
                        // to handle any new cases that might be added
                        // in the future:
                        EmptyView()
                    }
                }
                VStack{
                    HStack{
                        
                        Spacer()
                       
                        Image(systemName: "info.circle")
                            .padding()
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                showSheet.toggle()
                            }
                            .sheet(isPresented: $showSheet, content: {
                            ScrollView(content: {
                                VStack{
                                    Text(dog.name).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Text("age \(dog.age)")
                                    HStack{
                                        Spacer()
                                        Image(systemName: "message.fill").foregroundColor(.green)
                                        Spacer()
                                        Image(systemName: "location.fill").foregroundColor(.blue)
                                        Spacer()
                                        Image(systemName: "heart.fill").foregroundColor(.red)
                                        Spacer()
                                    }.padding()
                                }.padding()
                            }).presentationDetents([.medium, .large])
                        })
                    }.padding()
                    Spacer()
                   
                }
            }
            .ignoresSafeArea()
            .onTapGesture {
                toggle.toggle()
            }
            
        }
    }
}

