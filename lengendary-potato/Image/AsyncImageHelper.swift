//
//  AsyncImageHelper.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            image = UIImage(data: data)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
}

struct AsyncAwaitImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageUrl: URL

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await imageLoader.loadImage(from: imageUrl)
            }
        }
    }
}
