//
//  StartView.swift
//  LionPool
//
//  Created by Phillip Le on 6/10/22.
//

import SwiftUI


struct StartScreenView: View {
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .center, spacing: -24){
                    Text("Lion Pool")
                        .font(.system(size:75,weight: .bold))
                        .foregroundColor(Color("Dark Blue "))
                    Text("safer together")
                        .font(.system(size:35,weight: .bold))
                        .foregroundColor(Color("Dark Blue "))
                }
                Spacer()
                    .frame(height:24)
            
                //Create Account Button
                CustomNavLink(destination: signupView()) {
                    Text("Create Account")
                        .font(.system(size:17,weight: .medium))
                        .foregroundColor(Color.white)
                        .frame(width:275, height:52)
                        .background(Color("Gray Blue "))
                        .cornerRadius(10)
                }
            
            //Create Account Button
                NavigationLink(destination: LoginView()) {
                    Text("Sign In")
                    .font(.system(size:17,weight: .medium))
                    .foregroundColor(Color.black)
                    .cornerRadius(10)
                }
            
            }
        }
    }
    
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView()
    }
}

