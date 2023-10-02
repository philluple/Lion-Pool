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
        VStack{
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
                            .frame(width:35, height:35)
                            .foregroundColor(Color("Red"))
                    }
                    Button {
                        requestModel.acceptRequest(request: request, currentUser: user){ result in
                            switch result{
                            case.success(let match):
                                DispatchQueue.main.async {
                                    matchModel.matchesConfirmed[request.recieverFlightId] = match
                                }
                            case.failure:
                                print("Failed to accept request")
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width:35, height:35)
                            .foregroundColor(Color.green)
                    }
                }else{
                    HStack{
                        Button {
                            print("bye")
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .frame(width:35, height:35)
                                .foregroundColor(Color("Red"))
                        }
                        Button {
                            print("hello")
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width:35, height:35)
                                .foregroundColor(Color("Green"))
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
        .padding(10)
        .frame(minWidth: 125)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
        .overlay{
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("TextOutlineDark"), lineWidth: 1)
        }
//            .accentColor(Color("DarkGray"))
        
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
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                .foregroundColor(Color.gray)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2) // Add the border with specified color and line width
                )
        }
        
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let request = Request(id: UUID(), senderFlightId: UUID(), recieverFlightId: UUID(), recieverUserId: "1234", senderUserId: "2ch5NVLOfecaawnrjGjXnAVhHWy1", flightDate: "March 15,2022", pfp: "2ch5NVLOfecaawnrjGjXnAVhHWy1-pfp.jpg", name: "Geneva Ng", status: "REJECTED", airport: "EWR")
            // Preview for iPhone SE (1st generation)
            NavigationView {
                NotificationView(request: request)
                    .environmentObject(UserModel())
                    .environmentObject(RequestModel())
                    .environmentObject(MatchModel())
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
        }
    }
}
