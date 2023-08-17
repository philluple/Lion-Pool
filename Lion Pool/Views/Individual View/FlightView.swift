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
    @State private var popover: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var requestModel: RequestModel
    
    
    var body: some View {
        VStack{
            Button {
                popover.toggle()
                requestModel.fetchRequests(userId: flight.userId)
                
            } label: {
                HStack{
                    HStack{
                        Text(flight.airport)
                            .font(.system(size:25,weight: .bold))
                        Image(systemName: "airplane")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Gray Blue "))
                    }
                    Spacer()
//                    Text("\(formattedDate(flight.date.dateValue()))")
                    Text(time.formattedDate(flight.date))
                        .font(.system(size:20))

                    Text("@")
                        .font(.system(size:20))

//                    Text("\(formattedTime(flight.date.dateValue()))")
                    Text(time.formattedTime(flight.date))
                        .font(.system(size:20))
                        .foregroundColor(Color.gray)
                }.padding(.horizontal, 20)
            }
            .accentColor(Color.black)
            .sheet(isPresented: $popover){
                NewFlightDetailView(flight: flight)
            }
        }
        
    }
    
}
