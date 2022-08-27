//
//  SwiftUIView.swift
//  LionPool
//
//  Created by Phillip Le on 6/10/22.
//

import SwiftUI

struct LoginView : View{
    @State private var userName: String = ""
    @State private var pw: String = ""
    let tfHeight = (CGFloat)(50)

    var body : some View {
        VStack(spacing: 24){
            mainLogo
            signin
            rideButton
        }
    }
}

extension LoginView{
    private var mainLogo : some View {
        VStack(alignment: .center, spacing: -24){
            Text("Lion Pool")
                .font(.system(size:75,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
            Text("safer together")
                .font(.system(size:35,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
        }
    }
    
    private var signin : some View {
        Group{
            TextField("Username", text: $userName)
                .padding(.all)
                .font(.system(size:18,weight: .regular))
                .frame(width: UIScreen.screenWidth-40, height:tfHeight)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                .disableAutocorrection(true)
                
            TextField("Password", text: $pw)
                .padding(.all)
                .font(.system(size:18,weight: .regular))
                .frame(width: UIScreen.screenWidth-40, height:tfHeight)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                .disableAutocorrection(true)
        }
    }
    
    private var rideButton : some View{
        NavigationLink(destination: ContentView()){
            Text("Let's Ride")
                .font(.system(size:18,weight: .bold))
                .foregroundColor(Color.white)
                .frame(width:UIScreen.screenWidth-40, height:52)
                .background(Color("Gold "))
                .cornerRadius(10)
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

