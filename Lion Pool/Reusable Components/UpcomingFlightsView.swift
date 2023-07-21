//
//  UpcomingFlightsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct UpcomingFlightsView: View {
    @State var departingAirport: String
    @State var flightDate : Date
    var body: some View {
        VStack{
            HStack(){
                Text(departingAirport)
                    .font(.system(size:25,weight: .bold))
                
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("Gray Blue "))
                    //.clipShape(Circle())
                Spacer()
                
                Text("\(flightDate, style: .date) @ \(flightDate, style: .time)")
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
        let flyDate = Date()
        UpcomingFlightsView(departingAirport: "EWR", flightDate: flyDate)
    }
}
