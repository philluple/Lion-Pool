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
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var UNI = ""
    @State private var school = ""
    @State private var phone = ""
    @State private var showImagePicker = false
    // UI prefix means that it comes from kit
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var fileRef: String = ""
    @State private var errorMsg: String = ""
    var imageUtil = ImageUtils()
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: UserModel
    
    @State private var isCameraSource = false // Add this state

    
    enum School: String, CaseIterable, Identifiable {
        case CC, Barnard, SEAS, GS
        var id: Self { self }
    }
    
    var body: some View {
        VStack(spacing: -2){
            Logo(fontColor: "Dark Blue ", fontSize: 30)
                .frame(width: UIScreen.main.bounds.width)
                .background(Color("Gray Blue "))
                .padding([.bottom],2)
            
            ScrollView{
                ImagePicker
                
                InputView(text: $UNI,
                          title: "UNI",
                          placeholder: "").autocapitalization(.none)
                
                InputView(text: $firstname,
                          title: "First Name",
                          placeholder: "Roaree")
                
                InputView(text: $lastname,
                          title: "Last Name",
                          placeholder: "Minouche")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true).autocapitalization(.none)
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isSecureField: true).autocapitalization(.none)
                
                if errorMsg != ""{
                    Text(errorMsg)
                        .font(.system(size:14, weight:.semibold))
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width-50)
                        .foregroundColor(Color.red)
                        .padding(.vertical)
                }
                Group{
                    SignUpButton
                    LoginButton
                }
            }
        }
    }
    
    private var ImagePicker: some View{
        ZStack{
            Button {
                showImagePicker.toggle()
            }label:{
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top)
                    
                }else{
                    Circle()
                        .frame(width: 100)
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
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("Gold"))
                                    .padding([.leading, .top],110)
                            }
                            
                        )
                }
                
                
            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage){
                Lion_Pool.ImagePicker(selectedImage: $selectedImage, isCameraSource: $isCameraSource)
            }
        }
    }
    
    
    private var SignUpButton: some View{
        Button {
            if password == confirmPassword {
                errorMsg = ""
                Task{
                    if let result = try? await viewModel.createUser( UNI: UNI, password: password, firstname: firstname, lastname: lastname, pfpLocation: fileRef){
                        switch result {
                        case .success(let userId):
                            if profileImage != nil {
                                Task{
                                    await imageUtil.uploadPhoto(userId: userId, selectedImage: selectedImage)
                                }
                            }
                        case .system(let error):
                            self.errorMsg = error
                        case .user(let error):
                            self.errorMsg = error
                        }
                    }
                }
            } else {
                errorMsg = "Passwords don't match"
            }
        } label: {
            Text("LET'S RIDE!")
                .font(.system(size: 18, weight: .bold))
                .frame(width: UIScreen.main.bounds.width - 40, height: 52)
                .accentColor(.white)
        } .background(Color("Gold"))
            .cornerRadius(10)
            .padding(.top, 24)
    }

    
    private var LoginButton: some View{
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
    
    func loadImage(){
        guard let selectedImage = selectedImage else { return}
        profileImage = Image(uiImage: selectedImage)
    }
}
    
    struct RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
            RegistrationView()
        }
    }

