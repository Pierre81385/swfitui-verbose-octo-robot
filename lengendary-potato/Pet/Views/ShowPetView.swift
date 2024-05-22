//
//  ShowPetView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI

struct ShowPetView: View {
    @Binding var pet: Pet
    
    var body: some View {
        VStack{
            Text(pet.name)
        }
    }
}
