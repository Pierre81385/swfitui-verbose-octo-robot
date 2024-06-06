//
//  Style.swift
//  lengendary-potato
//
//  Created by m1_air on 6/5/24.
//

import Foundation
import SwiftUI

struct AuthGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        .background(Color(.white))
        .foregroundColor(.black)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
