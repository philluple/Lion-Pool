//
//  ExpandedMatchView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/3/23.
//
import SwiftUI

struct ExpandedMatchView: View {
    // ... (same as your existing code)
    let match: Match?
    let imageUtil = ImageUtils()
    @State private var image: Image?
    @State private var imageVisible: Bool = true
    @EnvironmentObject var userModel: UserModel
    
    
    var body: some View {
        if let match = match{
            VStack(alignment: .center){

                if let image = image {
                    VStack{
                        Text("A match made in low <3")
                            .font(.system(size: 30, weight: .semibold))
                            .opacity(imageVisible ? 1 : 0)
                            .foregroundColor(Color("Dark Blue "))
                        HStack(spacing: 20) {
                            image
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .opacity(imageVisible ? 1 : 0) // Apply opacity based on visibility
                                .animation(.easeInOut(duration: 0.3)) // Apply animation
                            
                            if let currentUser = userModel.currentUserProfileImage {
                                currentUser
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .opacity(imageVisible ? 1 : 0) // Apply opacity based on visibility
                                    .animation(.easeInOut(duration: 0.3)) // Apply animation
                            } else {
                                // To maintain the spacing, add an empty view with the same frame as the second image
                                Color.clear
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .frame(width: imageVisible ? UIScreen.main.bounds.width : 0, height: imageVisible ? UIScreen.main.bounds.height : 0)
                    .background(imageVisible ? Color("Gray Blue ") : Color.white).ignoresSafeArea()
                    if !imageVisible {
                        image
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())

                        Color.clear
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .zIndex(-1) // Send the first image to the back
                    }
                    
                }
                
            }
            .onAppear {
                imageUtil.fetchImage(userId: match.matchUserId) { result in
                    switch result {
                    case .success(let uiImage):
                        self.image = Image(uiImage: uiImage)
                    case .failure:
                        self.image = Image(systemName: "person.circle.fill")
                    }
                    
                    // Show the second image and rest of the content after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.imageVisible = false
                        }
                    }
                }
            }
        }
        }
    
}
//
//
//import SwiftUI
//
//struct ExpandedMatchView: View {
//    // ... (same as your existing code)
//    let match: Match?
//    let imageUtil = ImageUtils()
//    @State private var image: Image?
//    @State private var imageVisible: Bool = true
//    @EnvironmentObject var userModel: UserModel
//
//    var body: some View {
//        if let match = match{
//            VStack {
//                Text("A match made in low <3")
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundColor(Color("Dark Blue "))
//                    .padding(.vertical)
//
//                if let image = image {
//                    HStack(spacing: 20) {
//                        image
//                            .resizable()
//                            .frame(width: 150, height: 150)
//                            .clipShape(Circle())
//
//                        if let currentUser = userModel.currentUserProfileImage {
//                            currentUser
//                                .resizable()
//                                .frame(width: 150, height: 150)
//                                .clipShape(Circle())
//                                .opacity(imageVisible ? 1 : 0) // Apply opacity based on visibility
//                                .animation(.easeInOut(duration: 0.3)) // Apply animation
//                        } else {
//                            // To maintain the spacing, add an empty view with the same frame as the second image
//                            Color.clear
//                                .frame(width: 150, height: 150)
//                                .clipShape(Circle())
//                        }
//                    }
//                }
//
//                // Content that will appear after 2 seconds
//                if imageVisible {
//                    Text("A match made in low <3")
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(Color("Dark Blue "))
//                        .padding(.vertical)
//
//                    // Add the rest of the content here
//                    // ...
//                }
//            }
//            .onAppear {
//                imageUtil.fetchImage(userId: match.matchUserId) { result in
//                    switch result {
//                    case .success(let uiImage):
//                        self.image = Image(uiImage: uiImage)
//                    case .failure:
//                        self.image = Image(systemName: "person.circle.fill")
//                    }
//
//                    // Show the second image and rest of the content after 2 seconds
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        withAnimation {
//                            self.imageVisible = false
//                        }
//                    }
//                }
//            }
//        }
//
//    }
//
//    // ...
//}


//import SwiftUI
//
//struct ExpandedMatchView: View {
//    let match: Match
//    let imageUtil = ImageUtils()
//    @State private var image: Image?
//    @State private var imageVisible: Bool = true
//    @EnvironmentObject var userModel: UserModel
//
//    var body: some View {
//        VStack{
//            Text("A match made in low <3")
//                .font(.system(size: 20, weight: .semibold))
//                .foregroundColor(Color("Dark Blue "))
//                .padding(.vertical)
//            if let image = image{
//                HStack(spacing: 20){
//                    image
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                        .clipShape(Circle())
//                    Image(systemName: "")
//                    if let currentUser = userModel.currentUserProfileImage{
//                        currentUser
//                            .resizable()
//                            .frame(width: 150, height: 150)
//                            .clipShape(Circle())
//                            .opacity(imageVisible ? 1 : 0) // Apply opacity based on visibility
//                            .animation(.easeInOut(duration: 0.3))
//                    }
//                }.opacity(imageVisible ? 1 : 0) // Apply opacity to the entire HStack
//                    .animation(.easeInOut(duration: 0.3))
//            }
//        }
//
//            .onAppear{
//                imageUtil.fetchImage(userId: match.matchUserId){ result in
//                    switch result{
//                    case .success (let uiImage):
//                        self.image = Image(uiImage: uiImage)
//
//                    case .failure:
//                        self.image = Image(systemName: "person.circle.fill")
//                    }
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self.imageVisible = false
//                }
//            }
//    }
//
//}

struct ExpandedMatchView_Previews: PreviewProvider {
    static private var match = Match(id: UUID(), flightId: UUID(), matchFlightId: UUID(), matchUserId: "yMnqGkrVeGVELfzp8oFevQCnLUs2", date: "2023-08-02T12:34:56Z", pfp: "12345.jpg", name: "Phillip Le", airport: "EWR")
    static var previews: some View {
        ExpandedMatchView(match: match)
    }
}
