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
    
    let user = User(id: "Test", firstname: "Test", lastname: "Test", email: "user", UNI: "test", phone: "test", pfpLocation: "")
    var body: some View {
        if let user = viewModel.currentUser {
            //let imageURLString = user.pfpLocation
            VStack (spacing:10){
                // Profile Image
                if user.pfpLocation.count == 0{
                    Circle()
                        .frame(width: 120, height: 120)
                        .padding()
                } else {
                    if let image = profileImage { // 2. Use the profileImage here
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())// Set the appropriate size for the image
                            .padding()
                        
                    } else {
                        Circle()
                            .frame(width: 150, height: 150)
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
                        .font(.system(size:16,weight: .semibold))
                        .frame(width: UIScreen.main.bounds.width-10, height: 40)
                        .background(Color.red)
                }
                //                List {
                //                        VStack{
                //
                //                            //Email
                //                            Divider()
                //                            //UNI
                //                            HStack{
                //
                //                                Text("UNI")
                //                                    .font(.subheadline)
                //                                    .accentColor(.gray)
                //
                //                                Spacer()
                //                                Text("\(user.UNI)")
                //                                    .foregroundColor(Color("Dark Blue "))
                //
                //                            }
                //                            Divider()
                //                            //Phone Number
                //                            HStack{
                //
                //                                Text("Phone Number")
                //                                    .font(.subheadline)
                //                                    .accentColor(.gray)
                //
                //                                Spacer()
                //                                Text("\(user.phone)")
                //                                    .foregroundColor(Color("Dark Blue "))
                //
                //                            }
                //                        }
                //
                //                    Section("General"){
                //                        HStack{
                //
                //                            Image(systemName: "gearshape")
                //                                .font(.subheadline)
                //                                .accentColor(.gray)
                //
                //                            Text("Version")
                //
                //                            Spacer()
                //
                //                            //Text("\(User.MOCK_USER.phone)")
                //                                .foregroundColor(Color("Dark Blue "))
                //
                //                        }
                //
                //                    }
                //
                //                }
                //            }.onAppear {
                //                // Load the profile picture when the view appears
                //                retrievePfp(imageURLString: imageURLString)
                //
                //            }
            }
        }
    }
    func retrievePfp(imageURLString: String) {
            DispatchQueue.global(qos: .background).async {
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let httpsReference = storage.reference(forURL: "\(imageURLString)")
                httpsReference.getData(maxSize: 320*320) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print("Error retrieving profile picture: \(error.localizedDescription)")
                    } else {
                        // Data for "images/island.jpg" is returned
                        if let data = data, let image = UIImage(data: data) {
                            // Update the profileImage State variable (on the main thread)
                            DispatchQueue.main.async {
                                self.profileImage = image
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
            .environmentObject(AuthViewModel())
    }
}

