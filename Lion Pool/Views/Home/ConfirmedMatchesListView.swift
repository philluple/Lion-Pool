//
//  RequestListView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/29/23.
//

import SwiftUI

struct ConfirmedMatchesListView: View {
    @EnvironmentObject var matchModel: MatchModel
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        VStack{
            HStack{
                Text("Confirmed Matches")
                    .font(.system(size:22,weight: .medium))
                Spacer()
            }.position(x:200, y: 20)
            
            ScrollView(.horizontal, showsIndicators: true){
                HStack{
                    ForEach(Array(matchModel.matchesConfirmed.values), id: \.self) { matches in
                        ForEach(matches) { match in
                            ConfirmedMatchView(match: match)
                            Divider().frame(height: 100)
                        }
                        
                    }
                }
            }
        }.frame(width:UIScreen.main.bounds.width-20,height: 260)
        .background(Color.white)
        .cornerRadius(10)
        
        .onAppear{
            if let user = userModel.currentUser{
                matchModel.fetchMatches(userId: user.id)
            }
        }
    }
}


struct ConfirmedMatchesListView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ConfirmedMatchesListView()
                .environmentObject(UserModel())
                .environmentObject(MatchModel())
        }
        
    }
}

