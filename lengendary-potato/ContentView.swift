//
//  ContentView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            LoginView(authViewModel: UserAuthViewModel())
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
