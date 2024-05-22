//
//  ListPetsView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI

struct ListPetsView: View {
    @Binding var pets: [Pet]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ForEach(pets) { pet in
                Text(pet.name)
            }
        }
    }
}
