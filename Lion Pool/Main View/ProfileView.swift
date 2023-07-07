//
//  ProfileView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            var components = User.MOCK_USER.fullname.components(separatedBy: " ")
            let firstName = components.removeFirst()
            VStack (spacing:0){
                HStack{
                    Text("Hey, \(firstName) ")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color("Dark Blue "))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        //.padding([.leading],UIScreen.main.bounds.width)
                        .background(Color("Gray Blue "))
                }

                List {
                    Section ("Your Account"){
                        VStack{
                            //Email
                            HStack{
                                Text("Email")
                                    .font(.subheadline)
                                    .accentColor(.gray)
                                
                                Spacer()
                                Text("\(User.MOCK_USER.email)")
                                    .foregroundColor(Color("Dark Blue "))
                                
                            }
                            Divider()
                            //UNI
                            HStack{
                                
                                Text("UNI")
                                    .font(.subheadline)
                                    .accentColor(.gray)
                                
                                Spacer()
                                //Text("\(User.MOCK_USER.UNI)")
                                    .foregroundColor(Color("Dark Blue "))
                                
                            }
                            Divider()
                            //Phone Number
                            HStack{
                                
                                Text("Phone Number")
                                    .font(.subheadline)
                                    .accentColor(.gray)
                                
                                Spacer()
                                //Text("\(User.MOCK_USER.phone)")
                                    .foregroundColor(Color("Dark Blue "))
                                
                            }
                        }
                    }
                    Section("General"){
                        HStack{
                            
                            Image(systemName: "gearshape")
                                .font(.subheadline)
                                .accentColor(.gray)
                            
                            Text("Version")
                            
                            Spacer()
                            
                            //Text("\(User.MOCK_USER.phone)")
                                .foregroundColor(Color("Dark Blue "))
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

