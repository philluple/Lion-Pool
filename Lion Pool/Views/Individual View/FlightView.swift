//
//  UpcomingFlightsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI
import FirebaseFirestore

struct FlightView: View {
    let flight: Flight
    let time = TimeUtils()
    @EnvironmentObject var requestModel: RequestModel
    
    var body: some View {
        CustomNavLink(destination: NewFlightDetailView(flight: flight).customNavigationTitle("Flight Details").customNavigationSize(25)) {
            HStack {
                HStack {
                    Text(flight.airport)
                        .font(.system(size: 20, weight: .bold))
                    Image(systemName: "airplane")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("Gray Blue "))
                }
                Spacer()
                Text(time.formattedDate(flight.date))
                    .font(.system(size: 18))
                Text("@")
                    .font(.system(size: 18))
                Text(time.formattedTime(flight.date))
                    .font(.system(size: 18))
                    .foregroundColor(Color.gray)
            }
            .padding(.horizontal, 20)
            .accentColor(Color.black)
        }
    }
}

