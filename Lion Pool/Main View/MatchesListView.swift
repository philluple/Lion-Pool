//
//  FoundMatchesView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import SwiftUI

struct MatchesListView: View {

    let date: Date
    let airport: String
    let matches: [match]
    
    var body: some View {
        
        VStack{
            Text("Matches")
                .font(.system(size: 45, weight: .bold))
                .foregroundColor(SwiftUI.Color("Dark Blue "))
                .padding([.top, .bottom])
                .frame(width:UIScreen.main.bounds.width, height: 50)
                .background(SwiftUI.Color("Gray Blue "))
            
            Text("\(date, style: .date) @ \(date, style: .time)")
                .font(.system(size: 16, weight: .semibold))
            Text("From: \(airport)")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            ScrollView{
                ForEach(matches, id: \.userId) { match in
                    FlightMatch(match: match).padding([.vertical],5)
                }
            }
                        
        }
    }
}


//struct FoundMatchesView_Previews: PreviewProvider {
//    static var previews: some View {
//        @StateObject var network = Network()
//        let date = Date()
//        let airport = "EWR"
//        FoundMatchesListView(date: date, airport: airport)
//            .environmentObject(network)
//    }
//}
