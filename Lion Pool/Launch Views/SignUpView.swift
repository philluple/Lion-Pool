//
//  ContentView.swift
//  LionPool
//
//  Created by Phillip Le on 6/4/22.
//

import SwiftUI
import UIKit

struct signupView : View{
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAd: String = ""
    @State private var phoneNo: String = ""
    @State private var UNI: String = ""

    @State private var passWord: String = ""
    @State private var confirmPassowrd: String = ""
    
    @State private var buttonCount = 0
    
    @State var changeProfileImage = false
    @State var openCameraRoll = false
    @State var imageSelected = UIImage()
    @State var pwConfirmed = false

    let fontSize = (CGFloat)(18)
    let tfHeight = (CGFloat)(50)
        

    var body : some View {
        //CustomNavView{
        ScrollView{
            VStack(spacing: 15){
                Spacer()
                pfpView
                fNameView
                lNameView
                uniView
                emailAdView
                phoneNoView
                Spacer()
                ridebButton
            }
        }
    }
}

extension signupView{
    
    private var fNameView: some View {
        Group{
            Text("First Name")
                .font(.system(size:fontSize,weight: .regular))
                .frame(width: UIScreen.screenWidth-50, alignment:.leading)
            TextField("", text: $firstName)
                .padding(.all)
                .frame(width: UIScreen.screenWidth-40, height:tfHeight)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
        }
    }
    
    private var lNameView: some View{
        Group{
            Text("Last Name")
                .font(.system(size:fontSize,weight: .regular))
                .frame(width: UIScreen.screenWidth-50, alignment:.leading)
            
            TextField("", text: $lastName)
                .padding(.all)
                .frame(width: UIScreen.screenWidth-40, height:tfHeight)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
        }
        
    }
    
    private var emailAdView: some View{
        Group{
            Text("Email Address")
                .font(.system(size:fontSize,weight: .regular))
                .frame(width: UIScreen.screenWidth-50, alignment:.leading)

            TextField("", text: $emailAd)
                .padding(.all)
                .frame(width: UIScreen.screenWidth-40, height:tfHeight)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                .disableAutocorrection(true)
        }
    }
    
    private var phoneNoView: some View{
        Group{
            Text("Phone Number")
            .   font(.system(size:fontSize,weight: .regular))
                .frame(width: UIScreen.screenWidth-50, alignment:.leading)
        
            TextField("", text: $phoneNo)
                .padding(.all)
                .frame(width: UIScreen.screenWidth-40, height:tfHeight)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                .disableAutocorrection(true)
        }
    }
    
    private var uniView: some View{
        Group{
            Text("UNI")
                .font(.system(size:fontSize,weight: .regular))
                .frame(width: UIScreen.screenWidth-50, alignment:.leading)
        
            TextField("", text: $UNI)
                .padding(.all)
                .frame(width: UIScreen.screenWidth-40, height:tfHeight)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                .disableAutocorrection(true)
        }
    }
    

    
    private var pfpView: some View {
        ZStack(alignment: .bottomTrailing){
            Button(action: {
                changeProfileImage = true
                openCameraRoll = true
                
            }, label: {
                if changeProfileImage {
                    Image(uiImage: imageSelected)
                        .resizable()
                        .frame(width:150, height:150, alignment:.center)
                        .clipShape(Circle())

                }else {
                    Rectangle()
                        //.resizable()
                        .frame(width:150, height:150, alignment:.center)
                        .clipShape(Circle())
                        .foregroundColor(Color("Text Box"))
                }
               
            })
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("Gold"))
        }.sheet(isPresented:$openCameraRoll){
            ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
            
        }
    }
    
    private var password: some View{
        Group{
         
            Text("Password")
                .font(.system(size:18,weight: .regular))
                .frame(width: UIScreen.screenWidth-50, alignment:.leading)
            
            SecureField("", text: $passWord)
                .padding(.all)
                .frame(width: UIScreen.screenWidth-40, height:50)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Text("Confirm Password ")
                .font(.system(size:18,weight: .regular))
                .frame(width: UIScreen.screenWidth-50, alignment:.leading)
            
            SecureField("", text: $confirmPassowrd)
                .padding(.all)
                .frame(width: UIScreen.screenWidth-40, height:50)
                .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
    
    private var ridebButton: some View{
        Button(action: {
            if(passWord==confirmPassowrd){
                pwConfirmed = true;
            }
            buttonCount+=1
        }, label: {
         Text("Let's ride!")
                .font(.system(size:18,weight: .bold))
                .foregroundColor(Color.black)
                .frame(width: UIScreen.screenWidth-40, height:52)
                .background(Color("Gold"))
                .cornerRadius(10)
        })
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size

}

struct signupContView_Previews: PreviewProvider {
    static var previews: some View {
        signupView()
    }
}




