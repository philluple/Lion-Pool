//
//  AuthViewModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
import SwiftUI


// Publishes UI changes on the main thread
@MainActor
class UserModel: ObservableObject {

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentUserProfileImage: Image? = nil
    

    let imageUtil = ImageUtils()
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
            await fetchPfp()
        }
    }
    
    func checkUserSession() {
        // Add an observer to the Firebase Authentication state
        print("in here")
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if let user = user {
                self.userSession = user
            
                Task {
                    await self.fetchUser()
//                    await self.retrievePfp()
                }
            } else {
                // User is signed out, set userSession to nil and reset currentUser data
                self.userSession = nil
                self.currentUser = nil
                self.currentUserProfileImage = nil
            }
        }
    }

    func signIn(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            await fetchPfp()
            if let userId = self.currentUser?.id,
               let firstname = self.currentUser?.firstname,
               let lastname = self.currentUser?.lastname {
                   let name = "\(firstname) \(lastname)"
                   UserDefaults.standard.set(userId, forKey: "userId")
                   UserDefaults.standard.set(name, forKey: "name")
            }

            print("SUCCESS: User has signed in")
        } catch {
            print("DEBUG: failed to login")
        }
    }
    
    func createUser(withEmail email: String, password: String, firstname: String, lastname: String, UNI: String, pfpLocation: String) async throws -> String?{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, firstname: firstname, lastname: lastname, email: email, UNI: UNI, pfpLocation: pfpLocation)
            let encodedUser = try Firestore.Encoder().encode(user)
            // Storing the data
            print("DEBUG: before")
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            await fetchPfp()
            print("SUCCESS: \(user.id) has been created")
            if let userId = self.currentUser?.id,
               let firstname = self.currentUser?.firstname,
               let lastname = self.currentUser?.lastname {
                   let name = "\(firstname) \(lastname)"
                   UserDefaults.standard.set(userId, forKey: "userId")
                   UserDefaults.standard.set(name, forKey: "name")
            }
            return user.id
        } catch {
            print("DEBUG: could not create account", error.localizedDescription)
            return nil
        }
    }
    
    func signOut() {
        // take us back to login screen
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.currentUserProfileImage = nil
            print ("SUCCESS: User has signed out")
        } catch {
            print ("DEBUG: Could not sign out user")
        }
    }
    
    func fetchUser() async {
        print("Fetching user")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        if let userId = self.currentUser?.id,
           let firstname = self.currentUser?.firstname,
           let lastname = self.currentUser?.lastname {
               let name = "\(firstname) \(lastname)"
               UserDefaults.standard.set(userId, forKey: "userId")
               UserDefaults.standard.set(name, forKey: "name")
        }
        print("SUCCESS: Fetched the user")
    }
    
    func fetchPfp() async {
        print("Fetching")
        guard let pfp = self.currentUser?.pfpLocation else{
            return
        }
        guard let id = self.currentUser?.id else{
            return
        }
        if pfp == "" {
            return
        }
        DispatchQueue.main.async{
            self.imageUtil.fetchImage(userId: id){ result in
                switch result {
                case .success(let uiImage):
                    self.currentUserProfileImage = Image(uiImage: uiImage)
                case .failure:
                    print("Failed")
                }
            }
        }

    }
}
