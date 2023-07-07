//
//  RegistrationView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            Logo().padding(.vertical,32)
            
            VStack(spacing: 24){
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Roaree The Cunt")
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "UNI@columbia.edu").autocapitalization(.none)
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true).autocapitalization(.none)
                
                InputView(text: $confirmPassword,
                          title: "Password",
                          placeholder: "Confirm your password",
                          isSecureField: true).autocapitalization(.none)
            }
            Button {
                Task{
                    try await viewModel.createUser(withEmail: email,                    password: password,
                                     fullname: fullname)
                }
            } label : {
                HStack{
                    Text("LET'S RIDE!")
                        .font(.system(size:18,weight: .bold))
                        .frame(width:UIScreen.main.bounds.width-40, height:52)
                }
            }
            .background(Color("Gold"))
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            Button {
                dismiss()
            } label : {
                HStack(spacing: 3){
                    Text("Already have an account?")
                        .fontWeight(.semibold)
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size:16,weight: .bold))
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
