//
//  NewFlightDetailView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/9/23.
//

import SwiftUI
import PartialSheet

struct NewFlightDetailView: View {
    let flight : Flight
    let time =  TimeUtils()

    //Objects to apply logic
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var requestModel: RequestModel
    @EnvironmentObject var flightModel: FlightModel
    @EnvironmentObject var matchModel: MatchModel
    @Environment(\.presentationMode) var presentationMode
    @State var findMatches: Bool = false
    @State private var displayFind = false
    @State private var isSheetPresented = false
    @State private var confirmation = false
    @State private var rejection = false
    @State private var match: Match?
    
    
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
                       requestModel.requests[flight.id]?.isEmpty ?? true {
                        // Display the "Find Matches" button
                        VStack{
                            Spacer()
                            FlightDetaiTicket(flight: flight)
                                .padding(.top, 100)
                            HStack{
                                Spacer()
                                deleteFlightButton
                                findMatchesButton
                            }.padding([.trailing], 25)
                                .padding(.top,5)
                        }
                        
                    }else{
                        Group{
                            VStack{
                                FlightDetaiTicket(flight: flight)
                                    .padding(.top, 100)
                                if let inRequestArray = requestModel.inRequests[flight.id] {
                                    IncomingRequestsView(inRequestArray: inRequestArray)
                                }
                                if let outRequestArray = requestModel.requests[flight.id]{
                                    VStack (alignment: .leading){
                                        HStack {
                                            Text("Requests you sent")
                                                .font(.system(size: 22, weight: .medium))
                                                .padding(.leading, 15)
                                            Spacer()
                                        }.frame(width: UIScreen.main.bounds.width - 20)
                                        ScrollView(.horizontal, showsIndicators: true){
                                            HStack(spacing: 10){
                                                ForEach(outRequestArray){ request in
                                                    RequestView(request: request)
                                                        .padding(.leading)
                                                }
                                            }
                                        }
                                    }.frame(width:UIScreen.main.bounds.width-20)
                                }
                            }
                        }

                    }
                }
                
                if let match = self.match{
                    Text("This flight has a match!!!")
                }
                
                if let user = userModel.currentUser{
                    NavigationLink(destination: FindingMatchView(flightId: flight.id, airport: flight.airport, userId: user.id, date: time.dateFromISOString(flight.date) ?? Date()).navigationBarHidden(true), isActive: $findMatches){
                        EmptyView()
                    }.navigationBarHidden(true)
                }
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(Color("Text Box"))
                .ignoresSafeArea()
            .partialSheet(isPresented: $isSheetPresented){
                ChoiceView(isPresented: $isSheetPresented, firstAction:
                    deleteFlight, firstOption: "Yes, delete", secondOption: "Cancel", title: "Delete this flight?")
            }

        }.onAppear {
            print("Appearing")
            if let matchingMatch = matchModel.matchesConfirmed[flight.id]{
                self.match = matchingMatch
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
            isSheetPresented.toggle()
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
    private func deleteFlight() {
        if let user = userModel.currentUser {
            flightModel.deleteFlight(userId: user.id, flightId: flight.id, airport: flight.airport) { result in
                switch result {
                case .success:
                    presentationMode.wrappedValue.dismiss()
                case .failure:
                    print("could not delete")
                }
            }
        } else {
            print("Error")
        }
    }
}
    
//struct OutRequestsView: View{
//    var outRequestsArray: [Request]
//    var body: some View{
//    }
//}

struct IncomingRequestsView: View {
    
    var inRequestArray: [Request]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Incoming requests")
                    .font(.system(size: 22, weight: .medium))
                    .padding(.leading, 15)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 20)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 10) {
                    ForEach(inRequestArray) { inRequest in
                        NotificationView(request: inRequest)
                    }
                }
            }
            .padding([.leading])
        }
        .frame(width: UIScreen.main.bounds.width - 20)
    }
}
    
struct NewFlightDetailView_Previews: PreviewProvider {
    static private var flight = Flight(id: UUID(), userId: "12345", airport: "EWR", date: "2023-08-02T12:34:56Z", foundMatch: false)
    static var previews: some View {
        NewFlightDetailView(flight: flight)
            .environmentObject(RequestModel())
            .environmentObject(FlightModel())
            .environmentObject(UserModel())
    }
}
