//
//  ProfileCard.swift
//  lengendary-potato
//
//  Created by m1_air on 6/15/24.
//

import SwiftUI

struct ProfileCard: View {
    var profilePic: String = "https://firebasestorage.googleapis.com:443/v0/b/legendary-potato-b346f.appspot.com/o/images%2F4386491840?alt=media&token=66d4a7cc-3b56-4d7f-b384-9ced11eaf7b5"
    
    var body: some View {
        VStack{
            AsyncAwaitImageView(imageUrl: URL(string: profilePic)!)  
                .scaledToFill()
                .frame(width: 350, height: 475)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
        }
    }
}

#Preview {
    ProfileCard()
}
