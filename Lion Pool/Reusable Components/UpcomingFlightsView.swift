//
//  UpcomingFlightsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct UpcomingFlightsView: View {
    @State var flight: Flight
    @State private var popover: Bool = false
    

    
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
        ZStack{
            Button(action: {
                popover.toggle()
            }) {
                VStack{
                    HStack(spacing: 20){
                        Text(flight.airport)
                            .font(.system(size:25,weight: .bold))
                        
                        Image(systemName: "airplane")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Gray Blue "))
                        //.clipShape(Circle())
                        HStack{
                            Text("\(formattedDate(flight.date)) @")
                                .font(.system(size:20))
                            Text("\(formattedTime(flight.date))")
                                .font(.system(size:20))
                                .foregroundColor(Color.gray)
                            
                        }
                        
                        
                    }
                    Divider()
                        .foregroundColor(Color.black)
                }
                .padding(.horizontal)
            }.accentColor(Color.black)
                .sheet(isPresented: $popover){
                    ExpandedFlightView(flight: flight)
                }
        }
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
        let newFlight = Flight(id: UUID(), userId: "123456", date: Date(), airport: "EWR")
        UpcomingFlightsView(flight: newFlight)
    }
}
