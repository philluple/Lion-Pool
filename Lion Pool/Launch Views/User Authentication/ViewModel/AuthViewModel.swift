//
//  AuthViewModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

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
        print("signIN")
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            // Storing the data
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: could not create account")
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
        print("DEBUG: Current user is logged in \(self.currentUser)")
        
    }
}
