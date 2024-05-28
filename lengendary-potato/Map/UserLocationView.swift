//
//  UserLocationView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/21/24.
//

import SwiftUI
import MapKit
import _CoreLocationUI_SwiftUI

struct UserLocationView: View {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var locationViewModel: LocationViewModel = LocationViewModel()
    @State private var addressInput: String = ""
    
    var body: some View {
        ZStack{
            Map() {
                Marker("You are here", systemImage: "person", coordinate: locationViewModel.myLocation)
            }
            VStack{
                
                    GroupBox(label:
                                Label("Address", systemImage: "map")
                             , content: {
                        VStack{
                            HStack{
                                TextField("123 A Street, City, State, 10001", text: $locationViewModel.myAddress)
                                Button(action: {
                                    //get address coordinates
                                }, label: {
                                    Image(systemName: "chevron.right.circle.fill")
                                })
                            }.padding(EdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8))
                            HStack{
                                Text("or find my location,")
                                LocationButton {
                                    locationManager.requestLocation()
                                    locationViewModel.myLocation = locationManager.location ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                                }
                                .labelStyle(.iconOnly)
                                .tint(.white)
                                .cornerRadius(20)
                            }
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

//LocationButton {
//    locationManager.requestLocation()
//}
//.labelStyle(.iconOnly)
//.cornerRadius(20)
