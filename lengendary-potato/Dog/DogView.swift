//
//  DogView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/13/24.
//

import Foundation
import SwiftUI

struct DogView: View {
    @ObservedObject var dogInstance = DogModel(aDog: Dog(name: "Oliver", age: 0, size: "large", breed: "pitmix", gender: "male", imageUrl: "https://scontent-den2-1.xx.fbcdn.net/v/t39.30808-6/288386814_10102929320724745_917516006894952137_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=5f2048&_nc_ohc=5AGI2Y7dqb0Q7kNvgGlPgnQ&_nc_ht=scontent-den2-1.xx&oh=00_AYATDMUK_XTSLjD3lyIFjjQ6nMj3A2wzskl04nsradMhHg&oe=664858BC", description: "A fun loving puppy.", liked: [], gallery: [], messages: [], missing: false), allDogs: [
        Dog(name: "Oliver", age: 3, size: "large", breed: "pitmix", gender: "male", imageUrl: "https://scontent-den2-1.xx.fbcdn.net/v/t39.30808-6/288386814_10102929320724745_917516006894952137_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=5f2048&_nc_ohc=5AGI2Y7dqb0Q7kNvgGlPgnQ&_nc_ht=scontent-den2-1.xx&oh=00_AYATDMUK_XTSLjD3lyIFjjQ6nMj3A2wzskl04nsradMhHg&oe=664858BC", description: "A fun loving puppy.", liked: [], gallery: [], messages: [], missing: false),
        Dog(name: "Felt", age: 1, size: "small", breed: "corgi", gender: "female", imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSAbXPhiKh-y02y7XfP-9fGEu0NxxCfHOMn1k1Xg6ZuDtKF9Xok", description: "Good old boy.", liked: [], gallery: [], messages: [], missing: false),
        Dog(name: "Ruffus", age: 2, size: "medium", breed: "lab", gender: "male", imageUrl: "https://img.freepik.com/free-photo/vertical-shot-lovely-chocolate-labrador-puppy-white-wall_181624-44209.jpg?w=740&t=st=1715726338~exp=1715726938~hmac=5473e9bd4faddd2165775149d301d801421b7089f2e67cb7a229bad91bcd9b54", description: "Happy go lucky.", liked: [], gallery: [], messages: [], missing: false)
    
    ], status: "")
    @State var showFull: Bool = false
    
    
    var body: some View {
        if(showFull) {
                DogFullView(dog: $dogInstance.aDog, toggle: $showFull)
        } else {
                DogPreview(dogs: $dogInstance.allDogs, dogSelected: $dogInstance.aDog, toggle: $showFull).transition(.slide)
            
        }
    }
}



#Preview(body: {
    DogView()
})
