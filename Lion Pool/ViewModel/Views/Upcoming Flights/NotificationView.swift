//
//  NotificationView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/31/23.
//

import SwiftUI
import FirebaseStorage

struct NotificationView: View {
    let request: Request?
    let timeUtil = TimeUtils()
    @StateObject private var imageLoader: ImageLoader
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var networkModel: NetworkModel
    
    init(request: Request?) {
        self.request = request
        self._imageLoader = StateObject(wrappedValue: ImageLoader(pfp: request?.pfp))
    }
    
    var body: some View {
        if let request = request {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 150, height: 225)
                    .overlay{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("TextOutlineDark"), lineWidth: 1)
                    }
                if let circle = request.notify{
                    if circle{
                        Circle()
                            .fill(Color("Gray Blue "))
                            .frame(width:10)
                            .offset(x:60, y: -90)
                    }
                }
                VStack{
                    if let image = imageLoader.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .foregroundColor(Color.gray)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2) // Add the border with specified color and line width
                            )
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .clipShape(Circle())
                            .foregroundColor(Color.gray)
                    }
                    Text(request.name)
                        .font(.system(size: 16, weight: .semibold))
                    Text("To: \(request.airport)")
                        .font(.system(size: 12))
                    Text(timeUtil.formattedDate(request.flightDate))
                        .font(.system(size: 12))
                    
                    HStack(spacing: 10){
                        if let user = userModel.currentUser{
                            Button {
                                networkModel.rejectRequest(request: request, userId: user.id)
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .frame(width:50, height:50)
                                    .foregroundColor(Color.red)
                            }
                            Button {
                                networkModel.acceptRequest(request: request, currentUser: user)
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width:50, height:50)
                                    .foregroundColor(Color.green)
                            }
                        }else{
                            Text("Some fuck shit")
                        }
                        
                    }
                    
                }
         
            }
        } else {
            Text("Not working")
        }    }
}

struct NotificationView_Previews: PreviewProvider {
    static var request = Request(id: UUID(), senderFlightId: UUID(), recieverFlightId: UUID(), recieverUserId: "12345", senderUserId: "12345", flightDate: "July 20, 2023", pfp: "https://firebasestorage.googleapis.com:443/v0/b/lion-pool-f5755.appspot.com/o/profile-images%2FyMnqGkrVeGVELfzp8oFevQCnLUs2-pfp.jpg?alt=media&token=29eb6d1e-07ab-4553-ae23-7fc7d6ebcc69", name: "Bitch Cunt", status: "PENDING", airport: "HE", notify: true)
    static var previews: some View {
        NotificationView(request: request)
            .environmentObject(NetworkModel())
            .environmentObject(UserModel())
        
    }
}




