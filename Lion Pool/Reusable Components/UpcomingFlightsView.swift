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
    
    private let monthAbbrev: [String: String ] = [
        "January" : "Jan",
        "February" : "Feb",
        "March": "Mar",
        "April": "Apr",
        "August": "Aug",
        "September": "Sept",
        "October": "Oct",
        "November": "Nov",
        "December": "Dev"
    ]
    
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Text(departingAirport)
                    .font(.system(size:25,weight: .bold))
                
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("Gray Blue "))
                    //.clipShape(Circle())
                
                Text("\(formattedDate(flightDate)) @ \(formattedTime(flightDate))")
                    .font(.system(size:20))
                
            }
            Divider()
                .foregroundColor(Color.black)
        }
        .padding(.horizontal)
    }

    private func formattedDate( _ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    
        let monthString = dateFormatter.string(from: date)
        if let abbreviatedMonth = monthAbbrev[monthString] {
            return abbreviatedMonth
        }
        return monthString
    }

    private func formattedTime(_ date: Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

struct UpcomingFlightsView_Previews: PreviewProvider {
    static var previews: some View {
        let flyDate = Date()
        UpcomingFlightsView(departingAirport: "EWR", flightDate: flyDate)
    }
}
