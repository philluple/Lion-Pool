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

enum CreateUser{
    case success(String)
    case user(String)
    case system(String)
}

enum LogIn{
    case success
    case failure(String)
}

enum VerificationStatus {
    case verified, pending, newUser
}

// Publishes UI changes on the main thread
@MainActor
class UserModel: ObservableObject {

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentUserProfileImage: Image? = nil
    @Published var verificationStatus: VerificationStatus = .newUser
    var imageUtil = ImageUtils()

    init(){
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
            await fetchPfp()
        }
    }
    
    func resendVerification(){
        if let user = self.userSession{
            user.sendEmailVerification()
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
                    print(user.email!)
                    print(user.isEmailVerified)
                    await self.fetchUser()
                    let isEmailVerified = user.isEmailVerified
                    if isEmailVerified {
                        self.verificationStatus = .verified
                        print("verified 2")
                    } else {
                        self.verificationStatus = .pending
                        print("pending 2")
                    }
                }
            } else {
                // User is signed out, set userSession to nil and reset currentUser data
                self.userSession = nil
                self.currentUser = nil
                self.currentUserProfileImage = nil
            }
        }
    }


    func signIn(withEmail email: String, password: String) async throws-> LogIn{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print(result)
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
            return .success
        } catch {
            print(error)
            if (error.localizedDescription == "There is no user record corresponding to this identifier.The user may have been deleted"){
                return .failure("Hmmm, we couldn't find that account. Try creating one")
            }
            else if (error.localizedDescription == "The password is invalid or the user does not have a password."){
                return .failure("Incorrect password, try again!")
            }
            else{
                return .failure(error.localizedDescription)
            }
        }
    }
    
    func createUser(UNI: String, password: String, firstname: String, lastname: String, pfpLocation: String) async throws -> CreateUser {
        let email = UNI + "@columbia.edu"
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            UserDefaults.standard.set(result.user.uid, forKey: "userId")
            UserDefaults.standard.set(email, forKey: "email")
            let user = User(id: result.user.uid, firstname:
                                firstname, lastname: lastname, email: email, UNI: UNI, pfpLocation: pfpLocation)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            do {
                try await result.user.sendEmailVerification()
                verificationStatus = VerificationStatus.pending
                print("Verification email sent successfully")
                return .success(user.id)
            } catch {
                print("Failed to send verification email:", error.localizedDescription)
                return .system("Sorry, we were not able to create your account. Come back at a later time")
            }
        } catch {
            print("DEBUG: could not create account", error.localizedDescription)
            if (error.localizedDescription == "The email address is already in use by another account."){
                return .user("Your UNI is already associated with another account, try logging in!")
            } else{
                return .user(error.localizedDescription)
            }
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
        print("Fetching image")
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


