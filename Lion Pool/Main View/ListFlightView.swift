//
//  UpcomingFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

                
struct ListFlightView: View {
//    @State var upcoming_flights = [Flight]()
    @State private var confirmedFlight: Bool = false
    @State private var needRefreshList: Bool = false
    @State private var hasFetchedFlights = false // Add a state variable to track whether flights have been fetched

    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var flightModel: FlightViewModel

    
    
    var body: some View {
        if let user = viewModel.currentUser{
            VStack {
                HStack(){
                    Text("Upcoming flights")
                        .font(.system(size:22,weight: .medium))
                    Spacer()
                    CustomNavLink(destination: AddFlightView(confirmedFlight: $confirmedFlight).customNavigationTitle("Add a flight").customNavigationSize(35)) {
                        Text("Add flight")
                            .foregroundColor(Color.white)
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 90, height: 25)
                            .background(Color("Gold"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        //.padding(.top, (flightModel.flights.count != 0 ? 40 : 30))
                            .padding(.trailing,15)
                    }
                }
                .padding(.leading, 15)
                .padding(.top, 10)
                ScrollView{
                    VStack{
                        ForEach(Array(flightModel.flights.enumerated()), id: \.element.id) { index, flight in
                            UpcomingFlightsView(flight: flight)
                                
                            if index != flightModel.flights.count - 1 {
                                Divider()
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                }
                
            }
            .frame(width:UIScreen.main.bounds.width-20,height: (flightModel.flights.count < 4 ? CGFloat(flightModel.flights.count)*60+40 : 280))
            .background(Color.white)
            .cornerRadius(10)
            .onAppear{
                if !hasFetchedFlights{
                    flightModel.fetchFlights(userId: user.id)
                    hasFetchedFlights = true
                }
            }
            }else{
            let newFlight = Flight(id: UUID(), userId: "123456", date: Date(), airport: "EWR")
            VStack {
                HStack(){
                    Text("Upcoming flights")
                        .font(.system(size:22,weight: .medium))
                        .padding(.leading, 20)
                    Spacer()
                }
                ScrollView{
                    VStack{
                        Spacer()
                        ForEach(0...3, id: \.self) { _ in
                            UpcomingFlightsView(flight: newFlight)
                            Divider()
                        }
                    }
                }
            }.frame(width:UIScreen.main.bounds.width-20,height: 275)
                .background(Color.white)
                .cornerRadius(10)
        }
    }

//    func fetchFlights(userId: String){
//        print("DEBUG:Retrieving user flights")
//        let db = Firestore.firestore()
//        db.collection("users").document("\(userId)").collection("userFlights").getDocuments { snapshot, error in
//            if error ==  nil {
//                // no errors
//                if let snapshot = snapshot{
//                    // Update list property
//                    DispatchQueue.main.async {
//                        upcoming_flights = snapshot.documents.map { d in
//                            guard let idString = d["id"] as? String,
//                                  let userId = d["userId"] as? String,
//                                  let timestamp = d["date"] as? Timestamp,
//                                  let airport = d["airport"] as? String else {
//                                      // Skip this document if any of the required fields is missing
//                                      return nil
//                                  }
//
//                            return Flight(
//                                id: UUID(uuidString: idString) ?? UUID(),
//                                userId: userId,
//                                date: timestamp.dateValue(),
//                                airport: airport
//                            )
//                        }
//                        .compactMap { $0 } // Filter out any nil values resulting from missing required fields
//
//                    }
//                }else{ print ("DEBUG: shit happened")}
//            
//            }else{
//                print("DEBUG: more shit happened")
//            }
//        }
//        
//    }
}

struct UpcomingFlightView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ListFlightView()
                .environmentObject(AuthViewModel())
        }
        
    }
}
