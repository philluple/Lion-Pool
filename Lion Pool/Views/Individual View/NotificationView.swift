//
//  NotificationView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/31/23.
//

import SwiftUI
import FirebaseStorage

struct NotificationView: View {
    let request: Request
    let timeUtil = TimeUtils()
    let imageUtil = ImageUtils()
    
    @State private var userImage: Image? // Assuming this is a UIImage
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var requestModel: RequestModel
    @EnvironmentObject var matchModel: MatchModel
    
    var body: some View {
        ZStack {
            Base
            VStack{
                NotificationCircle()
                ProfilePicture()
                
                Text(request.name)
                    .font(.system(size: 16, weight: .semibold))
                Text("To: \(request.airport)")
                    .font(.system(size: 12))
                Text(timeUtil.formattedDate(request.flightDate))
                    .font(.system(size: 12))
                
                HStack(spacing: 10){
                    if let user = userModel.currentUser{
                        Button {
                            requestModel.rejectRequest(request: request, userId: user.id)
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .frame(width:50, height:50)
                                .foregroundColor(Color.red)
                        }
                        Button {
                            requestModel.acceptRequest(request: request, currentUser: user){ result in
                                switch result{
                                case.success:
                                    if var existingMatches = matchModel.matchesConfirmed[request.recieverFlightId]{
                                        existingMatches.append(Match(id: request.id, flightId: request.recieverFlightId, matchFlightId: request.senderFlightId, matchUserId: request.senderUserId, date: request.flightDate, pfp: request.pfp, name: request.name, airport: request.airport))
                                        matchModel.matchesConfirmed[request.recieverFlightId] = existingMatches
                                    }else{
                                        matchModel.matchesConfirmed[request.recieverFlightId] = [Match(id: request.id, flightId: request.recieverFlightId, matchFlightId: request.senderFlightId, matchUserId: request.senderUserId, date: request.flightDate, pfp: request.pfp, name: request.name, airport: request.airport)]
                                    }
                                case.failure:
                                    print("Failed to accept request")
                                }
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width:50, height:50)
                                .foregroundColor(Color.green)
                        }
                    }
                    
                }
                
            }
            
            .onAppear {
                imageUtil.fetchImage(userId: request.senderUserId) { result in
                    switch result {
                    case .success(let image):
                        self.userImage = Image(uiImage: image)
                    case .failure:
                        // Set a placeholder image or handle the error state
                        self.userImage = Image(systemName: "person.circle.fill")
                    }
                }
            }
        }
    }
    
    private var Base: some View{
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 150, height: 225)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("TextOutlineDark"), lineWidth: 1)
            }
    }
    
    @ViewBuilder
    private func NotificationCircle() -> some View{
        if let circle = request.notify{
            if circle{
                Circle()
                    .fill(Color("Gray Blue "))
                    .frame(width:10)
                    .offset(x:60, y: -90)
            }
        }
    }
    @ViewBuilder
    private func ProfilePicture() -> some View{
        if let userImage = userImage{
            userImage
                .resizable()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .foregroundColor(Color.gray)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2) // Add the border with specified color and line width
                )
        }
        
    }
}
