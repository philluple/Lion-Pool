//
//  RegistrationView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI
import iPhoneNumberField
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore

struct RegistrationView: View {
    @State private var email = ""
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var UNI = ""
    @State private var phone = ""
    @State private var showImagePicker = false
    // UI prefix means that it comes from kit
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var fileRef: String = ""
    
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: -2){
            Logo(fontColor: "Dark Blue ", fontSize: 65)
                .frame(width: UIScreen.main.bounds.width, height: 90)
                .background(Color("Gray Blue "))
                .padding([.bottom],2)
            
            ScrollView{
                ZStack{
                    Button {
                        showImagePicker.toggle()
                    }label:{
                        if let profileImage = profileImage {
                            profileImage
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width/2.75, height:UIScreen.main.bounds.width/2.75)
                                .clipShape(Circle())
                                .padding(.top)
                            
                        }else{
                            Circle()
                                .frame(width: UIScreen.main.bounds.width/2.75)
                                .foregroundColor(Color("Text Box"))
                                .padding(.top)
                                .overlay(
                                    ZStack{
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(Color.gray)
                                            .padding(.top)
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color("Gold"))
                                            .padding([.leading, .top],110)
                                    }
                                    
                                )
                        }
                        
                        
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage){
                        ImagePicker(selectedImage: $selectedImage)
                    }
                }
                
                InputView(text: $firstname,
                          title: "First Name",
                          placeholder: "Roaree")
                
                InputView(text: $lastname,
                          title: "Last Name",
                          placeholder: "Minouche")
                
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "UNI@columbia.edu").autocapitalization(.none)
                
                InputView(text: $UNI,
                          title: "UNI",
                          placeholder: "").autocapitalization(.none)
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true).autocapitalization(.none)
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isSecureField: true).autocapitalization(.none)
                
                Group{
                    Button {
                        Task{
                            if let newUserId = try await viewModel.createUser(withEmail: email,
                                                                              password: password,
                                                                              firstname: firstname,
                                                                              lastname: lastname,
                                                                              UNI: UNI,
                                                                              pfpLocation: fileRef){
                                if profileImage != nil {
                                    uploadPhoto(userId: newUserId)
                                }
                            }
                        }
                    } label : {
                        HStack{
                            Text("LET'S RIDE!")
                                .font(.system(size:18,weight: .bold))
                                .frame(width:UIScreen.main.bounds.width-40, height:52)
                                .accentColor(.white)
                        }
                    }
                    .background(Color("Gold"))
                    .cornerRadius(10)
                    .padding(.top, 24)
                    
                    Button {
                        dismiss()
                    } label : {
                        HStack(spacing: 3){
                            Text("Already have an account?")
                                .fontWeight(.semibold)
                                .accentColor(Color("Dark Blue "))
                            Text("Sign in")
                                .fontWeight(.bold)
                                .accentColor(Color("Gray Blue "))
                        }
                        .font(.system(size:16,weight: .bold))
                    }.padding([.bottom,.top])
                }
                
                
            }
        }
    }
    func loadImage(){
        guard let selectedImage = selectedImage else { return}
        profileImage = Image(uiImage: selectedImage)
    }

    func uploadPhoto(userId: String) {
        guard let selectedImage = selectedImage else { return }
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        
        // Check if we can turn the image into data
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        
        let fileRef = storageRef.child("profile-images/\(userId)-pfp.jpg")
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                // Handle any errors that occur during the upload
                print("Error uploading image:", error.localizedDescription)
            } else {
                // Image upload successful, get the download URL
                fileRef.downloadURL { url, error in
                    if let downloadURL = url?.absoluteString {
                        // Store the download URL in Firestore
                        db.collection("users").document(userId).setData(["pfpLocation": downloadURL], merge: true)
                    } else {
                        print("Error getting download URL:", error?.localizedDescription ?? "Unknown error")
                    }
                }
            }
        }
    }
}
    
    struct RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
            RegistrationView()
        }
    }

