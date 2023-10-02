//
//  NotificationView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/31/23.
//

import SwiftUI
import FirebaseStorage

struct RequestView: View {
    let request: Request
    let timeUtil = TimeUtils()
    let imageUtil = ImageUtils()
    
    @State private var userImage: Image? // Assuming this is a UIImage
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var requestModel: RequestModel
    @EnvironmentObject var matchModel: MatchModel
    
    var body: some View {
            VStack{
                NotificationCircle()
                ProfilePicture()
                Text(request.name)
                    .font(.system(size: 14, weight: .semibold))
                    .multilineTextAlignment(.center)
                Text("To: \(request.airport)")
                    .font(.system(size: 12))
                Text(timeUtil.formattedDate(request.flightDate))
                    .font(.system(size: 12))
                Text(request.status)
                    .font(.system(size:12, weight: .semibold))
                    .foregroundColor(Color.white)
                    .padding(4)
                    .background(Color("Gold"), in: RoundedRectangle(cornerRadius: 10))
                
            }
            .padding(10)
            .frame(minWidth: 125)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("TextOutlineDark"), lineWidth: 1)
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

struct RequestView_Preview: PreviewProvider {
    static var previews: some View {
        let request = Request(id: UUID(), senderFlightId: UUID(), recieverFlightId: UUID(), recieverUserId: "12345", senderUserId: "45678", flightDate: "March 15, 2000", pfp: "nil", name: "Phillip Le", status: "PENDING", airport: "EWR")
        RequestView(request: request)
            .environmentObject(UserModel())
            .environmentObject(RequestModel())
            .environmentObject(MatchModel())
    }
}
