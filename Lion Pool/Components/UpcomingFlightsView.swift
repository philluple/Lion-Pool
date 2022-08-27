//
//  UpcomingFlightsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct UpcomingFlightsView: View {
    var body: some View {
        VStack{
            HStack(spacing:20){
                Text("JFK")
                    .font(.system(size:25,weight: .bold))
                
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("Gray Blue "))
                    //.clipShape(Circle())
                
                Text("LAX")
                    .font(.system(size:25,weight: .bold))
                
                Text("Oct 10 @ 10:30PM ")
                    .font(.system(size:20))
                
            }
            Divider()
                .foregroundColor(Color.black)
        }
        .padding(.horizontal)
    }
}

struct UpcomingFlightsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingFlightsView()
    }
}
