//
//  AnnotationMapView.swift
//  lengendary-potato
//
//  Created by m1_air on 6/10/24.
//

import SwiftUI
import MapKit

struct AnnotationMapView: View {
    @ObservedObject var annotationViewModel: MyAnnotationViewModel
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40))
//    @State private var region: MKCoordinateRegion = {
//        var mapCoordinate = CLLocationCoordinate2D.init(latitude: 6.60, longitude: 16.43)
//        var mapZoomLevel = MKCoordinateSpan.init(latitudeDelta: 70.0, longitudeDelta: 70.0)
//        var mapRegion = MKCoordinateRegion.init(center: mapCoordinate, span: mapZoomLevel)
//        return mapRegion
//    }()

    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    
                }
                Spacer()
            }
            Map {
                ForEach(annotationViewModel.myAnnotations, id: \.id){
                    annotation in
                    Annotation(annotation.name, coordinate: CLLocationCoordinate2D(latitude: annotation.lat, longitude: annotation.long), content: {
                        Text("🐾")
                    })
                }
            }
        }.ignoresSafeArea()
            .onAppear{
                Task{
                    await annotationViewModel.getAnnotations()
                }
            }
    }
}

#Preview {
    AnnotationMapView(annotationViewModel: MyAnnotationViewModel())
}
