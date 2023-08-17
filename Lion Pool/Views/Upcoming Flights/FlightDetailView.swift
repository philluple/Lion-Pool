//
//  FlightDetailVie.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/23/23.
//

import SwiftUI
import MapKit

struct FlightDetailView: View {
    let flight : Flight
    let time =  TimeUtils()
    //Objects to apply logic
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var requestModel: RequestModel
    @EnvironmentObject var flightModel: FlightModel
    @Environment(\.presentationMode) var presentationMode
    @State var findMatches: Bool = false
    @State private var displayFind = false

    


    let airportCity: [String: String ] = [
        "EWR" : "Newark",
        "JFK" : "New York",
        "LGA": "La Guardia"
    ]

//     Calculate the difference in days and return a formatted string
    var diffs: Int {
        if let date = time.dateFromISOString(flight.date) {
            let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
            return components.day ?? 0
        } else{
            return 0
        }
    }
    
    var formattedDateString: String {
            return time.formattedDate(flight.date)
        }

    var formattedTimeString: String {
            return time.formattedTime(flight.date)
    }
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .center){
                    dateTime
                    airportPlane
                    Spacer()
                    Group{
                        if requestModel.inRequests[flight.id]?.isEmpty ?? true,
                           requestModel.requests[flight.id] == nil {
                            // Display the "Find Matches" button
                            findMatchesButton
                        }else{
                            if let inRequestArray = requestModel.inRequests[flight.id] {
                                Spacer()
                                VStack(spacing: 0) {
                                    // Remove the white rectangle here, we'll use only the Text with background color
                                    HStack {
                                        Text("Incoming requests")
                                            .font(.custom("DECTERM", size: 20))

//                                            .font(.system(size: 22, weight: .medium))
                                            .padding(.leading, 15)
                                        Spacer()
                                    }.frame(width: UIScreen.main.bounds.width - 20)
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack(spacing: 10) { // Use HStack and ForEach here
                                            ForEach(inRequestArray) { inRequest in
                                                NotificationView(request: inRequest)
                                            }
                                        }
                                    }.padding([.leading, .top])
                                }.frame(width:UIScreen.main.bounds.width-20, height: 300)
                            }
                            if let outRequest = requestModel.requests[flight.id]{
                                VStack (alignment: .leading){
                                    HStack {
                                        Text("Requests you sent")
                                            .font(.system(size: 22, weight: .medium))
                                            .padding(.leading, 15)
                                        Spacer()
                                    }.frame(width: UIScreen.main.bounds.width - 20)
                                    RequestView(request: outRequest)
                                        .padding(.leading)
                                }.frame(width:UIScreen.main.bounds.width-20, height: 300)
                            }
                            
                        }
                    }
                    
                    if let user = userModel.currentUser{
                        NavigationLink(destination: FindingMatchView(flightId: flight.id, airport: flight.airport, userId: user.id, date: time.dateFromISOString(flight.date) ?? Date()), isActive: $findMatches){
                            EmptyView()
                        }
                    }
                    
                    
                    
                }
                .background(Color("Text Box"))
                    .ignoresSafeArea()
                .onAppear{
                    if let user = userModel.currentUser{
                        requestModel.updateNotify(flightId: flight.id, userId: user.id)
                    }
                }

            } .background(Color("Text Box"))
                .ignoresSafeArea()
        }
    }
    
    private var findMatchesButton: some View{
        VStack{
            Spacer()
//            HStack{
//                Spacer()
//                Text("for now, you are on your own...")
//                    .font(.system(size: 15))
//                    .padding([.top, .leading])
//                Spacer()
//            }
//            Spacer()
            Button {
                findMatches.toggle()
            } label: {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("Gold"))
                    Text("Find matches")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 130, height: 40)
                        .accentColor(Color.black)
                }
            }
            Spacer()
        }.frame(width: UIScreen.main.bounds.width-50, height: 150)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var airportPlane: some View{
        ZStack{
            VStack(alignment: .leading){
                Text("\(airportCity[flight.airport] ?? "nil")")
                    .font(.custom("DECTERM", size: 20))
                    .foregroundColor(Color.black)
                Text("\(flight.airport)")
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundColor(Color.black)
                    .offset(y:-10)
                
            }
            .offset(x:-100, y: 100)
            
            Image("plane")
                .resizable()
                .frame(width: 500, height: 300)
            
            
        }.padding(.horizontal)
    }
    private var dateTime: some View{
        HStack{
            VStack(alignment: .center){
                Text(time.formattedTime(flight.date))
                    .font(.system(size: 20, weight: .thin))
                    .foregroundColor(Color.black)
                    .padding(.horizontal)
            }.frame(width: 110, height: 50)
                .background(Color("Gray Blue "))
                .cornerRadius(10)
                .offset(x:-20)
            Text(time.formattedDate(flight.date))
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(Color("DarkGray"))
        }.frame(width:300, height:50)
            .background(Color.white)
            .cornerRadius(10)
            .offset(y: 60)
    }
    
    private var pageHeader: some View{
        Text("\(diffs) days until...")
            .font(.system(size: 45, weight: .bold))
            .foregroundColor(SwiftUI.Color("Dark Blue "))
            .padding([.top, .bottom])
            .frame(width:UIScreen.main.bounds.width, height: 70)
            .background(SwiftUI.Color("Gray Blue "))
    }
    
    private var deleteFlightButton: some View{
        Button {
            Task{
                if let user = userModel.currentUser{
                    flightModel.deleteFlight(userId: user.id, flightId: flight.id,  airport: flight.airport){ result in
                        switch result {
                        case .success:
                            presentationMode.wrappedValue.dismiss()
                        case .failure:
                            print("could not delete")
                        }
                        
                        
                    }
                }
                
            }
        }label: {
            HStack{
                Image(systemName: "trash")
                    .resizable()
                    .frame(width:20,height:20)
                    .foregroundColor(Color.white)
                Text("Delete")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.white)
            }.frame(width: 100, height: 40)
                .background(Color("Dark Blue "))
                .cornerRadius(10)
            
        }
    }
    
}


//struct FlightDetailView_Previews: PreviewProvider {
//    static private var flight = Flight(id: UUID(), userId: "12345", airport: "EWR", date: "2023-08-02T12:34:56Z", foundMatch: false)
//    static var previews: some View {
//        FlightDetailView(flight: flight)
//            .environmentObject(RequestModel())
//            .environmentObject(FlightModel())
//            .environmentObject(UserModel())
//    }
//}
