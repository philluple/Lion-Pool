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


struct ProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var profileImage: UIImage? = nil
    
    //let user = User(id: "Test", firstname: "Jane", lastname: "Doe", email: "jane_doe@columbia.edu", UNI: "jane2134", phone: "(310)848-7944", pfpLocation: "")
    var body: some View {
    if let user = viewModel.currentUser {
        let imageURLString = user.pfpLocation
            VStack (spacing:10){
                // Profile Image
                if user.pfpLocation.count == 0{
                    Circle()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color("Text Box"))
                        .padding()
                } else {
                    if let image = viewModel.currentUserProfileImage { // 2. Use the profileImage here
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .overlay(Circle().stroke(Color("Text Box"), lineWidth: 4))
                            .clipShape(Circle())
                            .padding()
                        
                    } else {
                        Circle()
                            .frame(width: 120, height: 120)
                            .foregroundColor(Color("Text Box"))
                            .padding()
                            .overlay{
                                Image(systemName: "pawprint.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40 )
                                    .foregroundColor(Color.gray)
                                    .opacity(0.4)
                            }
                    }
                }
                // Rest of the shit
                UserDataView(title: "Email", userInfo: user.email)
                UserDataView(title: "UNI", userInfo: user.UNI)
                UserDataView(title: "Phone", userInfo: user.phone)
                Spacer()
                
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign out")
                        .font(.system(size:18,weight: .bold))
                        .frame(width:UIScreen.main.bounds.width-40, height:52)
                        .accentColor(.white)
                }.background(Color("Gold"))
                .cornerRadius(10)
                .padding()
                .accentColor(Color.white)
                
            }.onAppear {
                print("hello")
            }
        }
    }
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = AuthViewModel()
        ProfileView()
            .environmentObject(mockViewModel)
    }
}

