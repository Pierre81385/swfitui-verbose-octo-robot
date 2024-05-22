//
//  UserLocationView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/21/24.
//

import SwiftUI
import MapKit

struct UserLocationView: View {
    @State private var addressInput: String = ""
    
    var body: some View {
        ZStack{
            Map()
            VStack{
                GroupBox(label:
                            Label("Address", systemImage: "map")
                         , content: {
                    
                    HStack{
                        TextField("123 A Street, City, State, 10001", text: $addressInput)
                        Button(action: {
                            //get address coordinates
                        }, label: {
                            Image(systemName: "chevron.right.circle.fill")
                        })
                    }
                    
                    
                }).groupBoxStyle(AuthGroupBoxStyle())
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                    .padding(EdgeInsets(top: 0, leading:20, bottom: 20, trailing: 20))
                Spacer()
            }
        }
    }
}

#Preview {
    UserLocationView()
}
