//
//  PhotoGroupboxStyle.swift
//  lengendary-potato
//
//  Created by m1_air on 5/14/24.
//

import Foundation
import SwiftUI

struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.black))
            .overlay(configuration.label.padding(.leading, 4).foregroundStyle(.white), alignment: .topLeading)

    }
}
