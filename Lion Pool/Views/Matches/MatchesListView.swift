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
    @State var dismiss: Bool = false

    @EnvironmentObject var networkModel: NetworkModel
    var body: some View {
        NavigationView{
            VStack{
                Text("Matches")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(SwiftUI.Color("Dark Blue "))
                    .padding([.top, .bottom])
                    .frame(width:UIScreen.main.bounds.width, height: 50)
                    .background(SwiftUI.Color("Gray Blue "))
                
                Text("\(date, style: .date) @ \(date, style: .time)")
                    .font(.system(size: 16, weight: .semibold))
                Text("To: \(airport)")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                ScrollView{
                    ForEach(Array(networkModel.matches.values.flatMap { $0 }), id: \.id) { match in
                        FlightMatch(match: match).padding(.vertical, 5)
                    }

                }
                Button {
                    dismiss.toggle()
                } label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("Gray Blue "))
                }

                NavigationLink(destination: HomeView(), isActive: $dismiss) {
                    EmptyView()
                }.navigationBarBackButtonHidden()

            
            }.navigationBarBackButtonHidden()
        }.navigationBarBackButtonHidden()

    }
}

