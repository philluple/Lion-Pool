//
//  FlightMatch.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import SwiftUI
import FirebaseStorage
import PartialSheet


struct FlightMatch: View {
    let match: Match?
    let imageUtil = ImageUtils()
    @State private var buttonView: Bool = true
    @State private var userImage: Image? // Assuming this is a UIImage
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var requestModel: RequestModel
    @State private var buttonText = "Send request"
    @State private var buttonColor = "Gold"
    @Binding var confirmation: Bool
    
    var body: some View {
        if let match = match{
            HStack{
                if let userImage = userImage{
                    userImage
                        .resizable()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color("TextOutlineDark"), lineWidth: 4))
                        .aspectRatio(contentMode: .fit)
                        .frame(width:100, height:100)
                        .foregroundColor(Color.white)
                }
                VStack{
                    Text(match.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("Dark Blue "))
                    
                    Button {
                        confirmation.toggle()
                        print("toggled")
                        if let user = userModel.currentUser {
                            requestModel.sendRequest(match: match, senderUserId: user.id) { result in
                                switch result {
                                case .success:
                                    withAnimation {
                                        buttonText = "Request sent!"
                                        buttonColor = "Gray Blue "
                                    }
                                case .failure:
                                    print("failed to send request")
                                }
                            }
                        } else{
                            withAnimation {
                                buttonText = "Request sent!"
                                buttonColor = "Gray Blue "
                            }
                        }
                    }label: {
                        Text(buttonText) // Use the buttonText property here
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("DarkGray"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .frame(width: 120, height: 30)
                            .background(Color(buttonColor), in: RoundedRectangle(cornerRadius: 10))
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
            .frame(width: UIScreen.main.bounds.width - 50, height: 175)
            .background(Color("Text Box"), in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

func firstAction(){
    print("hello")
}

struct FlightMatchPreview: PreviewProvider {
    static var previews: some View {
        let match = Match(id: UUID(), flightId: UUID(), matchFlightId: UUID(), matchUserId: "12345", date: "January 12", pfp: "profile-images/2ch5NVLOfecaawnrjGjXnAVhHWy1-pfp.jpg", name: "Phillip Le", airport: "EWR")
        FlightMatch(match: match, confirmation: .constant(false))
            .environmentObject(MatchModel())
            .environmentObject(UserModel())
    }
}
