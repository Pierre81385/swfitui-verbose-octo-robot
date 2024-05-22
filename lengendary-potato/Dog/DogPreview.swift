//
//  DogPreview.swift
//  lengendary-potato
//
//  Created by m1_air on 5/14/24.
//

import Foundation
import SwiftUI

struct DogPreview: View {
    @Binding var dogs: [Dog]
    @Binding var dogSelected: Dog
    @Binding var toggle: Bool
    
    var body: some View {
       
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(dogs) {
                        dog  in
                        VStack{
                            Text(dog.name).fontWeight(.heavy)
                            Text("age, \(dog.age)").fontWeight(.light)
                            GroupBox(content: {
                                ZStack{
                                    AsyncImage(url: URL(string: dog.imageUrl)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(maxWidth: 250, maxHeight: 250)
                                            
                                        case .failure:
                                            Image(systemName: "photo")
                                        @unknown default:
                                            // Since the AsyncImagePhase enum isn't frozen,
                                            // we need to add this currently unused fallback
                                            // to handle any new cases that might be added
                                            // in the future:
                                            EmptyView()
                                        }
                                    }.clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                                    VStack{
                                        HStack{
                                            Image(systemName: "heart.fill").foregroundColor(.red)
                                                    .padding()
                                            Spacer()
                                        }
                                        Spacer()
                                    }.frame(width: 250, height: 250)
                                }
                            })
                            .groupBoxStyle(TransparentGroupBox())
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            .shadow(color: .gray.opacity(0.6), radius: 8, x: 15, y: 15)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 30, trailing: 15))
                            Text(dog.gender)
                        }
                        .onTapGesture {
                            dogSelected = dog
                            toggle.toggle()
                        }
                    }
                    
                }
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
}
