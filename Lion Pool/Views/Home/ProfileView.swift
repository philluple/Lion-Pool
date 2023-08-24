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

struct ImageWrapper: Identifiable {
    var id: UUID = UUID()
    var image: Image
}

struct ProfileView: View {
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var matchModel : MatchModel
    @EnvironmentObject var requestModel : RequestModel
    @EnvironmentObject var flightModel : FlightModel
    @EnvironmentObject var instagramModel: InstagramAPI
    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var imageLoader = ImageLoader() // Replace with your ViewModel

    let columns: [GridItem] = [
            GridItem(.flexible(), spacing: 2),
            GridItem(.flexible(), spacing: 2),
            GridItem(.flexible())
    ]
    
    var imageUitl = ImageUtils()
    
    @State private var displayedImage: Image?
    
    @State private var changedPfp: Bool = false
    @State private var camera: Bool = false // Add this state
    @State private var library: Bool = false // Add this state
    @State private var selected: Bool = false // Add this state
    @State private var isSheetPresented = false
    @State private var signOutSheet: Bool = false
    @State private var settingSheet: Bool = false
    @State private var isPresentView: Bool = false


    var body: some View {
        VStack{
            AccountInfo
            Divider()
                .padding(.horizontal,40)
                .padding(.bottom, 10)
                .padding(.top, 20)
            AccountStats
            Link(destination: URL(string: "https://api.instagram.com/oauth/authorize?client_id=1326528034640707&redirect_uri=https://lion-pool.com/app/&scope=user_profile,user_media&response_type=code")!)
            {
                Text("Connect your Instagram")
            }
            Divider()
                .padding(.horizontal,40)
                .padding(.top, 10)
                .padding(.bottom, 20)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(instagramModel.posts, id: \.id) { identifiableImage in
                        Image(uiImage: identifiableImage.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100) // Equal width and height
                            .clipped()
                    }
                }
                .padding()
            }
            
            Spacer()

            signOut
            
            .partialSheet(isPresented: $isSheetPresented){
                ChooseImageMedium(camera: $camera, library: $library, selected: $selected, showSheet: $isSheetPresented, changedPfp: $changedPfp)
            }
            .partialSheet(isPresented: $signOutSheet){
                ChoiceView(isPresented: $signOutSheet, firstAction: signOutAction, firstOption: "Sign out", secondOption: "Cancel", title: "Would you like to sign out")
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
    
    private var AccountInfo: some View{
        HStack{
            VStack(alignment: .leading, spacing: 0){
                Button{
                        isSheetPresented.toggle()
                } label: {
                    profilePicture
                }
                VStack(alignment: .leading, spacing: 4){
                    if let name = UserDefaults.standard.string(forKey: "name"){
                            Text(name)
                                .font(.system(size:16, weight: .semibold))
                    } else{
                        Text("Phillip Le")
                            .font(.system(size:16, weight: .semibold))
                    }
//                    if let user = userModel.currentUser{
//                        Label{
//                            Text("\(user.email)")
//                                .font(.system(size:14))
//                                .foregroundColor(Color.gray)
//                                .padding(10)
//                        } icon :{
//                            Image(systemName: "envelope")
//                                .foregroundColor(Color.gray)
//                        }.background(Color("Text Box"), in: Capsule())
//                            .labelStyle(.titleOnly)
//                            .accentColor(Color("DarkGray"))
//                    }else{
//                        Label{
//                            Text("pnl2111@columbia.edu")
//                                .font(.system(size:14))
//                                .foregroundColor(Color.gray)
//                                .padding(10)
//                        } icon :{
//                            Image(systemName: "envelope")
//                                .foregroundColor(Color.gray)
//                        }.background(Color("Text Box"), in: Capsule())
//                            .labelStyle(.titleOnly)
//                            .accentColor(Color("DarkGray"))
//                    }
//                    if let username = UserDefaults.standard.string(forKey: "instagram_user"){
//                        Label{
//                            Text("@\(username)")
//                                .font(.system(size:14))
//                                .foregroundColor(Color.gray)
//                                .padding(10)
//                        } icon :{
//                            Image(systemName: "envelope")
//                                .foregroundColor(Color.gray)
//                        }.background(Color("Text Box"), in: Capsule())
//                            .labelStyle(.titleOnly)
//                            .accentColor(Color("DarkGray"))
//                    }else{
//                        Link(destination: URL(string: "https://api.instagram.com/oauth/authorize?client_id=1326528034640707&redirect_uri=https://lion-pool.com/app/&scope=user_profile,user_media&response_type=code")!)
//                        {
//                            Text("Connect your Instagram")
//                        }
//                    }
                }.padding(.leading, 20)
            }
            Spacer()
        }.padding(.leading, 20)
    }
    
    private var AccountStats: some View{
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
    private var profilePicture: some View {
        Group {
            if let displayedImage = userModel.currentUserProfileImage {
                displayedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(Color("Text Box"), lineWidth: 4))
                    .clipShape(Circle())
                    .padding()
                    .overlay {
                        ZStack(alignment: .topLeading) {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .foregroundColor(Color("Gold"))
                                .frame(width: 20, height: 20)
                                .offset(x: 30, y: 40) // Adjust these values to move the pencil icon
                        }
                    }
            } else {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("Text Box"))
                    .padding()
                    .overlay {
                        Image(systemName: "pawprint.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                            .opacity(0.4)
//                            .offset(x: 100, y: -10) // Adjust these values to move the pawprint icon
                            .overlay(alignment: .topLeading) {
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .foregroundColor(Color("Gold"))
                                    .frame(width: 20, height: 20)
                                    .offset(x: 50, y: 40) // Adjust these values to move the pencil icon
                            }
                    }
            }
        }
    }

    private var signOut: some View{
        HStack{
            Spacer()
            Button {
                signOutSheet.toggle()
            } label: {
                ZStack{
                    Circle()
                        .fill(Color("Gold"))
                        .frame(width: 40)
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.white)
                }
            }
        }.padding(.horizontal)
        

    }
    
    
    private func signOutAction() {
        matchModel.signOut()
        flightModel.signOut()
        requestModel.signOut()
        userModel.signOut()
    }
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for iPhone SE (1st generation)
            NavigationView {
                ProfileView()
                    .environmentObject(UserModel())
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
            
            NavigationView {
                ProfileView()
                    .environmentObject(UserModel())
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))

            // Preview for iPhone 13 Pro Max
            NavigationView {
                ProfileView()
                    .environmentObject(UserModel())
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            
            NavigationView {
                ProfileView()
                    .environmentObject(UserModel())
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
        }
    }
}



