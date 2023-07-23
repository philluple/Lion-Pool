//
//  UpcomingFlightsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct UpcomingFlightsView: View {
    @State var flight: Flight
    @State private var needRefreshFromDelete: Bool = false
    @Binding var needRefreshList: Bool
    @State private var popover: Bool = false
    @Environment(\.presentationMode) var presentationMode

    

//    if(needRefreshFromDelete = true, then toddle needRefreshList)
    
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
            Button(action: {popover.toggle()}) {
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
                    Text("\(formattedDate(flight.date))")
                        .font(.system(size:20))

                    Text("@")
                        .font(.system(size:20))

                    Text("\(formattedTime(flight.date))")
                        .font(.system(size:20))
                        .foregroundColor(Color.gray)
                }.padding(.horizontal, 20)
            }
            .accentColor(Color.black)
            .sheet(isPresented: $popover){
                ExpandedFlightView(needRefreshFromExpand: $needRefreshFromDelete, flight: flight)
            }.onChange(of: needRefreshFromDelete){
                success in
                if success{
                    needRefreshList.toggle()
                    //presentationMode.wrappedValue.dismiss()
                    print("DEBUG: In upcoming flights view")
                }
            }
            

            //Divider()
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
