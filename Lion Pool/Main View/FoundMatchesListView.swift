//
//  FoundMatchesView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import SwiftUI

struct FoundMatchesListView: View {
    @EnvironmentObject var network: Network
    let date: Date
    let airport: String
    
    var body: some View {
        NavigationView{
            NavigationLink(destination: HomeView()) {
                Text("Matches")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color("Dark Blue "))
                    .frame(width: UIScreen.main.bounds.width)
                    .padding([.bottom, .top], 10)
                    .background(Color("Gray Blue "))
            }.navigationBarBackButtonHidden()
            
            VStack{
                Text("\(date, style: .date) @ \(date, style: .time)")
                    .font(.system(size: 16, weight: .semibold))
                Text("From: \(airport)")
                    .font(.system(size: 16, weight: .semibold))
            }
            
            ScrollView{
                ForEach(network.matches, id: \.userId) { match in
                    FlightMatch(match: match).padding([.vertical],5)
                }
            }
        }
    }
}


struct FoundMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var network = Network()
        let date = Date()
        let airport = "EWR"
        FoundMatchesListView(date: date, airport: airport)
            .environmentObject(network)
    }
}
