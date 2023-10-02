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
                if let image = image{
                    image
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }
                Text(match.name)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(Color("DarkGray"))
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

struct ExpandedMatchView_Previews: PreviewProvider {
    static private var match = Match(id: UUID(), flightId: UUID(), matchFlightId: UUID(), matchUserId: "yMnqGkrVeGVELfzp8oFevQCnLUs2", date: "2023-08-02T12:34:56Z", pfp: "12345.jpg", name: "Phillip Le", airport: "EWR")
    static var previews: some View {
        ExpandedMatchView(match: match)
    }
}
