//
//  PetView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI

struct PetView: View {
    @ObservedObject var viewModel: PetViewModel
    
    var body: some View {
        VStack{
            if(viewModel.isLoading || viewModel.pets.isEmpty) {
                Text("Searching for pets!")
            } else {
                ShowPetView(pet: $viewModel.pet)
            }
            if(!viewModel.pets.isEmpty)
            {
                ListPetsView(pets: $viewModel.pets)
            }
        }
    }
}

struct PetViewPreviews: PreviewProvider{
   static var previews: some View {
       PetView(viewModel: PetViewModel())
    }
}



