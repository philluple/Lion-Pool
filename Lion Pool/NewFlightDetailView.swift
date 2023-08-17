//
//  NewFlightDetailView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/9/23.
//

import SwiftUI

struct NewFlightDetailView: View {
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
    
    var body: some View{
        NavigationView{
            ScrollView(.vertical){
                Group{
                    if requestModel.inRequests[flight.id]?.isEmpty ?? true,
                       requestModel.requests[flight.id] == nil {
                        // Display the "Find Matches" button
                        VStack{
                            Spacer()
                            flightDetails
                                .padding(.top, 100)
                            HStack{
                                Spacer()
                                deleteFlightButton
                                findMatchesButton
                            }.padding([.trailing], 25)
                                .padding(.top,5)
                        }
                    }else{
                        VStack{
                            flightDetails
                                .padding(.top, 100)
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
                }
                
                if let user = userModel.currentUser{
                    NavigationLink(destination: FindingMatchView(flightId: flight.id, airport: flight.airport, userId: user.id, date: time.dateFromISOString(flight.date) ?? Date()), isActive: $findMatches){
                        EmptyView()
                    }
                }
                
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(Color("Text Box"))
                .ignoresSafeArea()
                .onAppear{
                    requestModel.
                }
        }
    }
    private var airport: some View{
        VStack(alignment: .center, spacing: 0){
            Text(flight.airport)
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(Color.white)
                .frame(width: 120, height: 50)
                .background(Color.black)
            Text("DEPARTURES")
                .font(.system(size: 15))
        }
    }
    
    private var diffDetail: some View{
        VStack{
            VStack{
                ZStack(alignment: .bottomTrailing){
                    VStack(alignment: .leading){
                        Group{
                            Rectangle()
                                .frame(width: 350, height:150)
                                .foregroundColor(Color("DarkGray"))
                                .overlay{
                                    Text(flight.airport)
                                        .font(.system(size: 100, weight: .thin))
                                        .foregroundColor(Color.white)
                                        .padding(.leading,5)
                                }
                        }
                        Text("DATE:")
                            .font(.system(size: 18, weight: .thin))
                        Text("\(time.formattedDate(flight.date))")
                            .font(.system(size: 30))
                        Text("TIME:")
                            .font(.system(size: 18, weight: .thin))
                        Text("\(time.formattedTime(flight.date))")
                            .font(.system(size: 30))
                    }
                    .padding(1)
                    
                }
            }.frame(width: UIScreen.main.bounds.width-20, height: 350)
                .background(Color.white)
                .cornerRadius(10)
            Text("For now, you are on your own. Find some matches")
        }
    }
    
    private var FlightDetails: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            
            
            
        }
    }
    
    private var flightDetail2: some View{
        HStack{
            border.padding(.leading)
            Spacer()
            VStack(alignment: .center, spacing: 20){
                VStack(spacing: -10){
                    Text("\(airportCity[flight.airport] ?? "nil")")
//                            .font(.system(size: 30))
                        .font(Font.custom("font000000002a85a6df", size: 20))
                        .textCase(.uppercase)
                        .foregroundColor(Color.black)

                    Text("\(flight.airport)")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(Color.black)
                }
                HStack{
                    if let user = userModel.currentUser{
                        VStack(alignment: .leading){
                            Text("Passenger:")
                                .font(.system(size: 14, weight: .semibold))

                            Text("\(user.firstname)")
                                .font(.system(size: 14, weight: .thin))
                        }
                        
                    } else{
                        VStack(alignment: .leading){
                            Text("Passenger:")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Phillip Le")
                                .font(.system(size: 14, weight: .thin))
                        }
                       
                    }
                    Spacer()
                }
                HStack{
                    VStack(alignment: .leading){
                        Text("Date: ")
                            .font(.system(size: 12, weight: .semibold))
                        Text("\(time.formattedDate(flight.date))")
                            .font(.system(size: 12, weight: .thin))
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Time: ")
                            .font(.system(size: 12, weight: .semibold))
                        Text("\(time.formattedTime(flight.date))")
                            .font(.system(size: 12, weight: .thin))
                            .foregroundColor(Color.black)
                    }
                    
                }
                
                
            }.padding(.leading)
            Spacer()
            border.padding(.trailing)
            
        }.frame(width: UIScreen.main.bounds.width-50, height: 400)
            .background(Color.white)
            .cornerRadius(10)
    }
    private var border: some View{
        Rectangle()
            .frame(width: 10, height: 350)
            .foregroundColor(Color("Gray Blue "))
    }
    
    private var findMatchesButton: some View{
        VStack{
            Spacer()
            Button {
                findMatches.toggle()
            } label: {
                VStack {
                    Text("Find matches")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 130, height: 40)
                        .accentColor(Color.white)
                        .background(Color("Gold"))
                        .cornerRadius(10)
                }
            }
            Spacer()
        }
    }
    
    private var countdown: some View{
        HStack{
            if diffs == 1{
                Text("\(diffs) day left...")
                    .font(.system(size: 18, weight: .semibold))
            }else if diffs == 0{
                Text("Today's the day")
                    .font(.system(size: 18, weight: .semibold))
            }else{
                Text("\(diffs) days left...")
                    .font(.system(size: 18, weight: .semibold))
            }
        }.frame(width: UIScreen.main.bounds.width-55)
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
            ZStack{
                Circle()
                    .fill(Color("Dark Blue "))
                    .frame(width: 40, height: 40)
                Image(systemName: "trash")
                    .resizable()
                    .frame(width:20,height:20)
                    .foregroundColor(Color.white)
            }
        }
    }
    
    private var flightDetails: some View{
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
    
    
    
    
//    struct NewFlightDetailView_Previews: PreviewProvider {
//        static private var flight = Flight(id: UUID(), userId: "12345", airport: "EWR", date: "2023-08-02T12:34:56Z", foundMatch: false)
//        static var previews: some View {
//            NewFlightDetailView(flight: flight)
//                .environmentObject(RequestModel())
//                .environmentObject(FlightModel())
//                .environmentObject(UserModel())
//        }
//    }
}
