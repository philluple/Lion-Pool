//
//  FlightMatch.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import SwiftUI
import FirebaseStorage


struct FlightMatch: View {
    let match: Match?
    let imageUtil = ImageUtils()
    @Binding var hitRequestButton: Bool
    @State private var userImage: Image? // Assuming this is a UIImage
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var requestModel: RequestModel
    
    
    var body: some View {
        if let match = match{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("Text Box"))
                .frame(width: UIScreen.main.bounds.width - 50, height: 200)
                .overlay{
                    HStack{
                        if let userImage = userImage{
                            userImage
                                .resizable()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color("TextOutlineDark"), lineWidth: 4))
                                .aspectRatio(contentMode: .fit)
                                .frame(width:150, height:150)
                        }
                        VStack{
                            Text(match.name)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color("Dark Blue "))
                            Text("CC '24")
                            Button {
                                if let user = userModel.currentUser{
                                    requestModel.sendRequest(match: match, senderUserId: user.id){ result in switch result{
                                    case.success:
                                        hitRequestButton.toggle()
                                        print("Nice")
                                    case.failure:
                                        //load a sheet
                                        print("Oh no")
                                    }
                                    }
                                }
                            }label: {
                                RoundedRectangle(cornerRadius:10)
                                    .fill(Color("Gold"))
                                    .frame(width: 150, height:30)
                                    .overlay{
                                        Text(" Send request")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color("DarkGray"))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                    }
                            }
                            
                        }
                        
                        
                    }
                }
                .onAppear{
                    imageUtil.fetchImage(userId: match.matchUserId){ result in
                        switch result {
                        case .success(let uiImage):
                            self.userImage = Image(uiImage: uiImage)
                        case .failure:
                            // Set a placeholder image or handle the error state
                            self.userImage = Image(systemName: "person.circle.fill")
                        }
                    }
                }
        }
    }
}
