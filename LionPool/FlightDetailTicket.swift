//
//  SwiftUIView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/16/23.
//

import SwiftUI

struct FlightDetaiTicket: View {
    let flight: Flight
    let time = TimeUtils()
    
    let airportCity: [String: String ] = [
        "EWR" : "Newark",
        "JFK" : "New York",
        "LGA": "La Guardia"
    ]
    
    var body: some View {
        HStack{
            Rectangle()
                .frame(width: 10, height: 140)
                .padding(.leading, 10)
                .foregroundColor(Color("Gray Blue "))
            VStack(alignment: .leading){
                Image(systemName: "airplane")
                HStack{
                    Text("\(airportCity[flight.airport] ?? "nil")")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color.black)
                }
                Text("Date: \(time.formattedDate(flight.date))")
                    .font(.system(size: 12, weight: .thin))
                Text("Time: \(time.formattedTime(flight.date))")
                    .font(.system(size: 12, weight: .thin))
                    .foregroundColor(Color.black)
                
            }.padding(.leading)
            Spacer()
            VStack(alignment: .center, spacing: 0){
                Spacer()
                Text(flight.airport)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(Color.white)
                    .frame(width: 65, height: 30)
                    .background(Color.black)
                Text("DEPARTURES")
                    .font(.system(size: 10))
//                VStack{
//                    Text("\(diffs)")
//                        .font(Font.custom("ChicagoFlf", size: 32))
//                }
//
                
//                Image("Barcode")
//                    .resizable()
//                    .frame(width:80, height: 80)
                Spacer()
            }.padding([.top], 10)
            
            Rectangle()
                .frame(width: 10, height: 140)
                .padding(.trailing, 10)
                .foregroundColor(Color("Gray Blue "))
            
        }.frame(width: UIScreen.main.bounds.width-50, height: 150)
            .background(Color.white)
            .cornerRadius(10)

    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static private var flight = Flight(id: UUID(), userId: "12345", airport: "EWR", date: "2023-08-02T12:34:56Z", foundMatch: false)

    static var previews: some View {
        FlightDetaiTicket(flight: flight)
    }
}
