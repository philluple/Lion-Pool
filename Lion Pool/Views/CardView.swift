//
//  CardView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/2/23.
//

import SwiftUI

struct CardView: View {
    let flight: Flight
    let time = TimeUtils()
    @EnvironmentObject var requestModel: RequestModel
    @EnvironmentObject var matchModel: MatchModel
    var diffs: Int {
        if let date = time.dateFromISOString(flight.date) {
            let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
            return components.day ?? 0
        } else{
            return 0
        }
    }
    
    var body: some View {
        ZStack{
            Color("Text Box")
                .ignoresSafeArea()
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment: .leading){
                        Text(flight.airport)
                            .font(.system(size:40,weight: .bold))
                        Text(time.formattedDate(flight.date))
                            .font(.system(size:18))
                        Text(time.formattedTime(flight.date))
                            .font(.system(size:18))
                            .foregroundColor(Color.gray)
                    }.padding(.horizontal)
                    Spacer()
                    VStack{
                        Text("\(diffs) DAYS")
                            .font(.system(size:40,weight: .bold))
                            .foregroundColor(Color.white)
                    }.frame(width: 200, height:100)
                    .background(Color("Gold"))
                    .offset(x:20)

                    Spacer()
                }.frame(width:UIScreen.main.bounds.width-30, height: 100)
                .background(Color("Gray Blue "))
                
                VStack{
                    if flight.foundMatch{
                        //this will basically always evaluate to true
                        if let confirmedMatchArray = matchModel.matchesConfirmed[flight.id]{
                            ForEach(confirmedMatchArray, id: \.id) { match in
                                ConfirmedMatchView(match: match)
                            }
                        }
                    }else{
                        Text("Hello there")
//                        if let inRequestArray = requestModel.inRequests[flight.id]{
//                            ForEach(inRequestArray, id: \.id) { inRequest in
//                                NotificationView(request: inRequest)
//                            }
//                        }
                    }
                    
                }
                
               Spacer()
            }.frame(width: UIScreen.main.bounds.width-30, height: 400)
                .background(Color.white)
                .cornerRadius(10)
        }
        
           
    }
}

//struct CardView_Previews: PreviewProvider {
//    static private var flight = Flight(id: UUID(), userId: "12345", airport: "EWR", date: "2023-08-02T12:34:56Z", foundMatch: true)
//
//    static var previews: some View {
//        CardView(flight: flight)
//            .environmentObject(MatchModel())
//    }
//}
