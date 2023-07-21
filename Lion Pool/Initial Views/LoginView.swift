//
//  NewLogin.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI
import Swift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        NavigationView{

            VStack (){
                //image
                Logo(fontColor: "Dark Blue ", fontSize: 75).padding(.vertical,32)
                
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "UNI@columbia.edu").autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true).autocapitalization(.none)
                }
                Button {
                    Task{
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label : {
                    HStack{
                        Text("LET'S RIDE!")
                            .font(.system(size:18,weight: .bold))
                            .frame(width:UIScreen.main.bounds.width-40, height:52)
                            .accentColor(Color.white)
                    }
                }
                .background(Color("Gold"))
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                }label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                            .accentColor(Color("Dark Blue "))
                        Text("Sign up")
                            .fontWeight(.bold)
                            .accentColor(Color("Gray Blue "))


                    }
                    .font(.system(size:16,weight: .bold))
                }.padding([.bottom])
            }
           
        }
    }
        
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
