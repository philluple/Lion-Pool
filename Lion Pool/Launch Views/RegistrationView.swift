//
//  RegistrationView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI
import iPhoneNumberField

struct RegistrationView: View {
    @State private var email = ""
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var UNI = ""
    @State private var phone = ""
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(){
            Logo()
                .frame(width: UIScreen.main.bounds.width)
                .background(Color("Gray Blue "))
                .padding([.bottom],2)
            
            
            ScrollView{
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
                
                VStack(spacing: 15){
                    Text("Phone Number")
                        .font(.system(size:18,weight: .regular))
                        .frame(width: UIScreen.main.bounds.width-50, alignment:.leading)
                    
                    iPhoneNumberField("(000) 000-0000", text: $phone)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .font(UIFont(size: 20, weight: .light,design: .rounded))
                            .maximumDigits(10)
                            .foregroundColor(Color.gray)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width-50, height: 50)
                                .background(Color("Text Box"))
                                .cornerRadius(5)
                            //.shadow(color: .gray, radius: 10)
                                .padding([.leading, .trailing], 25)

                }
                Spacer()
                Button {
                    Task{
                        try await viewModel.createUser(withEmail: email,
                                    password: password,
                                    firstname: firstname,
                                    lastname: lastname,
                                    UNI: UNI,
                                    phone: phone)
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
