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


// Publishes UI changes on the main thread
@MainActor
class AuthViewModel: ObservableObject {
    // Firebase user objext
    
    @Published var userSession: FirebaseAuth.User?
    // Our user object
    @Published var currentUser: User?
    @Published var currentUserProfileImage: UIImage? = nil

    
    init(){
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
            await retrievePfp()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            await retrievePfp()
            print("User has signed in")
        } catch {
            print("DEBUG: failed to login")
        }
    }
    
    func createUser(withEmail email: String, password: String, firstname: String, lastname: String, UNI: String, phone: String, pfpLocation: String) async throws -> String?{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, firstname: firstname, lastname: lastname, email: email, UNI: UNI, phone: phone, pfpLocation: pfpLocation)
            let encodedUser = try Firestore.Encoder().encode(user)
            // Storing the data
            print("DEBUG: before")
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            await retrievePfp()
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

    func retrievePfp() async{
        guard let pfpLocation = self.currentUser?.pfpLocation else { return }
        let storage = Storage.storage()
        if pfpLocation == ""{
            return
        }
        let httpsReference = storage.reference(forURL: pfpLocation)
        httpsReference.getData(maxSize:350*350){
            data, error in
            if let error = error{
                print("Error retrieving profile picture: \(error.localizedDescription)")
            } else{
                if let data = data, let image = UIImage(data: data){
                    self.currentUserProfileImage = image
                }
            }
        }
    }
}
