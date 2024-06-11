//
//  AnnotationMapView.swift
//  lengendary-potato
//
//  Created by m1_air on 6/10/24.
//

import SwiftUI
import MapKit

struct AnnotationMapView: View {
    @Binding var homeLat: Double
    @Binding var homeLong: Double
    @State private var useLocation: Bool = false
    @State private var locationType: String = "location.fill"
    @State private var back: Bool = false
    @State private var showSettings: Bool = false
    @State private var position: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.742043, longitude: -104.991531), span: (MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))))
    @State private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.742043, longitude: -104.991531)
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var annotationViewModel: MyAnnotationViewModel
    
    var body: some View {
        
            ZStack{
                Map(position: $position) {
//                    Annotation("Home", coordinate: CLLocationCoordinate2D(latitude: homeLat, longitude: homeLong), content: {
//                        Text("🏠")
//                    })
//                    Annotation("You Are Here", coordinate: currentLocation, content: {
//                            Text("📍")
//                        })
                    
                    ForEach(annotationViewModel.myAnnotations, id: \.id){
                        annotation in
                        Annotation(annotation.name, coordinate: CLLocationCoordinate2D(latitude: annotation.lat, longitude: annotation.long), content: {
                            if(annotation.lost) {
                                Image(systemName: "viewfinder.trianglebadge.exclamationmark").foregroundStyle(.red)
                            }
                            if(annotation.found) {
                                Image(systemName: "scope").foregroundStyle(.green)
                            }
                            if(annotation.spotted) {
                                Image(systemName: "photo").foregroundStyle(.yellow)
                            }
                        })
                    }
                }.mapStyle(.hybrid(elevation: .realistic))
                VStack{
                    GroupBox(content: {
                        HStack{
                                Button(action: {
                                    back = true
                                }, label: {
                                    Image(systemName: "chevron.backward").foregroundStyle(.black)
                                }).navigationDestination(isPresented: $back, destination: {
                                    ProfileContributorView(contributorViewModel: ContributorViewModel()).navigationBarBackButtonHidden(true)
                                })
                                Spacer()
                            Button(action: {
                                useLocation = !useLocation
                                if(useLocation){
                                    locationType = "house.fill"
                                    let location = locationManager.requestLocation()
                                    position = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinate, span:MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                                    currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                                } else {
                                    locationType = "location.fill"
                                    position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: homeLat, longitude: homeLong), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                                    currentLocation = CLLocationCoordinate2D(latitude: homeLat, longitude: homeLong)
                                }
                            }, label: {
                                  Image(systemName: locationType)
                            })
                                Button(action: {
                                    showSettings.toggle()
                                }, label: {
                                    Image(systemName: "gearshape.fill").foregroundStyle(.black)
                                })
                                .sheet(isPresented: $showSettings, content: {
                                    VStack{
                                        Text("map settings")
                                        Button(action: {
                                            showSettings.toggle()
                                        }, label: {
                                            Text("Done")
                                        })
                                    }
                                })
                               }
                    }).shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                        .padding(EdgeInsets(top: 72, leading: 12, bottom: 12, trailing: 12))
                    Spacer()
                }
                
                
            }.ignoresSafeArea()
                .onAppear{
                    let location = locationManager.requestLocation()
                    locationType = "house.fill"
                    position = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinate, span:MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                    currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    Task{
                        await annotationViewModel.getAnnotations()
                    }
                    
                }
    }
}

//#Preview {
//    AnnotationMapView(location: CLLocation(), annotationViewModel: MyAnnotationViewModel())
//}
