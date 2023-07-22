//
//  ExpandedFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/21/23.
//

import SwiftUI

struct ExpandedFlightView: View {
    @Binding var needRefreshFromExpand: Bool
    @StateObject private var flightViewModel = FlightViewModel()
    
    var flight: Flight
    var cities = ["EWR": "NEWARK",
                  "JFK": "NEW YORK",
                  "LGA": "NEW YORK"]
    
    var body: some View {
        ZStack{
            Color("Text Box")
            // Two vertical pillars
            HStack{
                Rectangle()
                    .frame(width: 40, height: UIScreen.main.bounds.height-230)
                    .foregroundColor(Color("Gray Blue "))
                    .padding(.leading)
                Spacer()
                Rectangle()
                    .frame(width: 40, height: UIScreen.main.bounds.height-230)
                    .foregroundColor(Color("Dark Blue "))
                    .padding(.trailing)
            }
            //Two Barcodes
            VStack{
                Image("Barcode")
                    .resizable()
                    .frame(maxWidth:UIScreen.main.bounds.width - 150, maxHeight: 55)
                    .padding(.top, 60)
                Spacer()
                Image("Barcode")
                    .resizable()
                    .frame(maxWidth:UIScreen.main.bounds.width - 150, maxHeight: 55)
                    .padding(.bottom, 60)
            }.ignoresSafeArea()
            //Airplane
            ZStack{
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width:90,height:90)
                    .foregroundColor(Color("DarkGray"))
                    .padding(.leading, 190)
                    .padding(.bottom, UIScreen.main.bounds.height-400)
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width:90,height:90)
                    .foregroundColor(Color.gray)
                    .padding(.leading, 210)
                    .padding(.top,10)
                    .padding(.bottom, UIScreen.main.bounds.height-400)
            }
            //Change to buttons later
            HStack(spacing: 20){
                
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width:60,height:60)
                    .foregroundColor(Color("Gold"))
                
                Button {
                    Task{
                        let result = try await flightViewModel.deleteFlight(flight: flight)
                        if result == 1{
                            print("DEBUG: user deleted flight")
                            needRefreshFromExpand.toggle()
                        }
                    }
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .frame(width:60,height:60)
                        .foregroundColor(Color.red)
                }
                
            }
            .padding(.leading, 150)
            .padding(.top, 550)
            

        }
        .ignoresSafeArea()
        .overlay{
            HStack{
                VStack(alignment:.leading){
                    VStack(alignment:.leading, spacing: 1){
                        Text("\(cities[flight.airport]!)")
                            .font(.system(size:30, weight: .semibold))
                            .foregroundColor(Color("DarkGray"))

                        Group{
                            Rectangle()
                            .frame(width: 230, height:100)
                            .foregroundColor(Color("DarkGray"))
                            .overlay{
                                Text("\(flight.airport)")
                                    .font(.system(size: 100, weight: .thin))
                                    .foregroundColor(Color.white)
                                    .padding(.leading,5)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing:-2){
                        Text("DATE:")
                            .font(.system(size: 20, weight: .thin))
                        Text("\(flight.date, style: .date)")
                            .font(.system(size: 42))
                    }.padding(.top,20)
                    VStack(alignment: .leading, spacing:-2){
                        Text("TIME:")
                            .font(.system(size: 20, weight: .thin))
                        Text("\(flight.date, style: .time)")
                            .font(.system(size: 42))
                    }
                    
                }.padding(.leading, 60)
                Spacer()
            }
            
            
        }
    }
}

//struct ExpandedFlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        let newFlight = Flight(id: UUID(), userId: "123456", date: Date(), airport: "EWR")
//        ExpandedFlightView(flight: newFlight)
//    }
//}
