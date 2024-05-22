//
//  UserAuthViewModel.swift
//  lengendary-potato
//
//  Created by m1_air on 5/15/24.
//

import Foundation
import FirebaseAuth

class UserAuthViewModel: ObservableObject {
    @Published var auth: UserAuth = UserAuth()
    @Published var password: String = ""
    @Published var success: Bool = false
    @Published var status: String = ""
    @Published var loggedIn: Bool = false
    
    func CreateUser() {
         Auth.auth().createUser(withEmail: auth.email, password: password) { (result, error) in
              if error != nil {
                  self.success = false
                  self.status = error?.localizedDescription ?? ""
              } else {
                  self.success = true
                  self.status = "User created!"
              }
          }
        }
    
    func ListenForUserState() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            switch user {
            case .none:
                print("USER NOT FOUND IN CHECK AUTH STATE")
                self.loggedIn = false
            case .some(let user):
                print("setting avatar for user: \(user.uid)")
                self.loggedIn = true
            }
        }
    }
    
    func GetCurrentUser() -> Bool {
        if Auth.auth().currentUser != nil {
            self.success = true
            self.status = "Found user uid: \(String(describing: Auth.auth().currentUser?.uid))"
            self.loggedIn = true
            return self.loggedIn
        } else {
            self.success = false
            self.status = "User not found!"
            self.loggedIn = false
            return self.loggedIn
        }
    }
    
    func SignInWithEmailAndPassword() {
        
        Auth.auth().signIn(withEmail: auth.email, password: password) { (result, error) in
                   if error != nil {
                       self.success = false
                       self.status = error?.localizedDescription ?? ""
                   } else {
                       self.success = true
                       self.status = "Successfully signed in!"
                   }
               }
           
    }
    
    func SendEmailVerfication(){
        Auth.auth().currentUser?.sendEmailVerification { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Email verification sent!"
            }
        }
    }
    
    func UpdateEmail(newEmail: String) {
        Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Email updated!"
            }
        }
    }
    
    func UpdatePassword(newPassword: String) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Password updated!"
            }
        }
    }
    
    func SendPasswordReset(){
        Auth.auth().sendPasswordReset(withEmail: auth.email) { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Password reset sent to \(self.auth.email)!"
            }
        }
    }
    
    func DeleteCurrentUser() {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "User deleted!"
            }
        }
    }
    
    func SignOut(){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.success = true
            self.status = "Signed out!"
        } catch let signOutError as NSError {
            self.success = false
            self.status = signOutError.description
        }
    }
}
