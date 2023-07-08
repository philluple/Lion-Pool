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

// Publishes UI changes on the main thread
@MainActor
class AuthViewModel: ObservableObject {
    // Firebase user objext
    @Published var userSession: FirebaseAuth.User?
    // Our user object
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            print("User has signed in")
        } catch {
            print("DEBUG: failed to login")
        }
    }
    
    func createUser(withEmail email: String, password: String, firstname: String, lastname: String, UNI: String, phone: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, firstname: firstname, lastname: lastname, email: email, UNI: UNI, phone: phone)
            let encodedUser = try Firestore.Encoder().encode(user)
            // Storing the data
            print("DEBUG: before")
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: could not create account", error.localizedDescription)
        }
    }
    
    func signOut() {
        // take us back to login screen
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print ("DEBUG: Could not sign out user")
        }
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        print("DEBUG: Current user is logged in")
        
    }
}
