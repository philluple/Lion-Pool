//
//  ProfileView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import PartialSheet


struct ProfileView: View {
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var matchModel : MatchModel
    @EnvironmentObject var requestModel : RequestModel
    @EnvironmentObject var flightModel : FlightModel
    @Environment(\.presentationMode) var presentationMode
    var imageUitl = ImageUtils()
    
    @State private var displayedImage: Image?
    
    @State private var changedPfp: Bool = false
    @State private var camera: Bool = false // Add this state
    @State private var library: Bool = false // Add this state
    @State private var selected: Bool = false // Add this state
    @State private var isSheetPresented = false
    @State private var signOutSheet: Bool = false


    var body: some View {
        VStack (){
            HStack(spacing: 50){
                Button{
                    isSheetPresented.toggle()
                } label: {
                    profilePicture
                }
              
                accountStats
            }
            nameEmail
            Spacer()
            signOut
            .partialSheet(isPresented: $isSheetPresented){
                ChooseImageMedium(camera: $camera, library: $library, selected: $selected, showSheet: $isSheetPresented, changedPfp: $changedPfp)
            }
            
            .partialSheet(isPresented: $signOutSheet){
                ChoiceView(isPresented: $signOutSheet, onConfirm: signOutAction, firstOption: "Sign out", secondOption: "Cancel", title: "Would you like to sign out")
            }
            
            .onChange(of: changedPfp) { newValue in
                if newValue {
                    Task {
                        await userModel.fetchPfp()
                        displayedImage = userModel.currentUserProfileImage // Assign the fetched image to displayedImage
                    }
                }
            }


        }
    }
        

    private var nameEmail: some View {
        HStack{
            VStack(alignment: .leading, spacing:5){
                if let name = UserDefaults.standard.string(forKey: "name"){
                    Text(name)
                        .font(.system(size:16, weight: .semibold))
                } else{
                    Text("Phillip Le")
                        .font(.system(size:15, weight: .semibold))
                }
                
                if let user = userModel.currentUser{
                    Label{
                        Text("\(user.email)")
                            .font(.system(size:14))
                            .foregroundColor(Color.gray)
                            .padding(10)
                    } icon :{
                        Image(systemName: "envelope")
                            .foregroundColor(Color.gray)
                    }.background(Color("Text Box"), in: Capsule())
                        .labelStyle(.titleOnly)
                        .accentColor(Color("DarkGray"))
                }else{
                    Label{
                        Text("pnl2111@columbia.edu")
                            .font(.system(size:14))
                            .foregroundColor(Color.gray)
                            .padding(10)
                    } icon :{
                        Image(systemName: "envelope")
                            .foregroundColor(Color.gray)
                    }.background(Color("Text Box"), in: Capsule())
                        .labelStyle(.titleOnly)
                        .accentColor(Color("DarkGray"))
                }
                
            }
            Spacer()
        }.padding(.leading, UIScreen.main.bounds.width/10)
    }
    
    private var signOut: some View{
        Button {
            signOutSheet.toggle()
        } label: {
            Text("Sign out")
                .font(.system(size:18,weight: .bold))
                .frame(width:UIScreen.main.bounds.width-40, height:52)
                .accentColor(.white)
        }.background(Color("Gold"))
            .cornerRadius(10)
            .padding()
            .accentColor(Color.white)
    }
    
    private var accountStats: some View{
        HStack(spacing: 40){
            VStack{
                Group{
                    if let flightCount = UserDefaults.standard.value(forKey: "flights") as? Int {
                        Text("\(flightCount)")
                            .font(.system(size:16, weight: .semibold))
                    }else{
                        Text("0")
                            .font(.system(size:16, weight: .semibold))
                    }
                }
                Text("Flights")
                    .font(.system(size:14))
                
            }
            
            VStack{
                Group{
                    if let matchCount = UserDefaults.standard.value(forKey: "matches") as? Int {
                        Text("\(matchCount)")
                            .font(.system(size:16, weight: .semibold))
                        
                    }else{
                        Text("0")
                            .font(.system(size:16, weight: .semibold))
                    }
                }
                Text("Matches")
                    .font(.system(size:14))
                
            }
            
            
        }
    }
    
    private func signOutAction() {
        matchModel.signOut()
        flightModel.signOut()
        requestModel.signOut()
        userModel.signOut()
    }
    
    private var profilePicture: some View {
        ZStack(alignment: .bottomTrailing){
            if let displayedImage = userModel.currentUserProfileImage { // 2. Use the profileImage here
                ZStack(alignment: .bottomTrailing){
                    displayedImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color("Text Box"), lineWidth: 4))
                        .clipShape(Circle())
                            .alignmentGuide(.bottom) { dimension in
                                dimension[.bottom]
                            }
                            .alignmentGuide(.trailing) { dimension in
                                dimension[.trailing]
                            }
                        .padding()
                        
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .foregroundColor(Color("Gold"))
                        .frame(width: 20, height: 20)
                        .padding(4)
                }
            } else {
                ZStack(alignment: .bottomTrailing){
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color("Text Box"))
                        .alignmentGuide(.bottom) { dimension in
                            dimension[.bottom]
                        }
                        .alignmentGuide(.trailing) { dimension in
                            dimension[.trailing]
                        }
                        .padding()
                        .overlay{
                            Image(systemName: "pawprint.fill")
                                .resizable()
                                .frame(width: 40, height: 40 )
                                .foregroundColor(Color.gray)
                                .opacity(0.4)
                        }
                        
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .foregroundColor(Color("Gold"))
                        .frame(width:20, height: 20)
                        .padding(4)

                }
                
            }
            
        }
           
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileView()
                .environmentObject(UserModel())
        }.attachPartialSheetToRoot()
    }
}


