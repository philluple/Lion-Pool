//
//  UpcomingFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

                
struct UpcomingFlightView: View {
    @State var upcoming_flights = [Flight]()
    @EnvironmentObject var viewModel : AuthViewModel

    var body: some View {
        if let user = viewModel.currentUser{
            VStack {
                HStack(spacing: -30){
                    Text("Upcoming flights")
                        .font(.system(size:22,weight: .medium))
                        .frame(width: UIScreen.main.bounds.width-50, alignment:.leading)
                    
                    CustomNavLink(destination: AddFlightView().customNavigationTitle("Add a flight").customNavigationSize(35)) {
                        Image(systemName:"plus.circle.fill")
                            .resizable()
                            .frame(width:25, height:25)
                            .foregroundColor(Color("Gold"))
                    }
                }
                
                LazyVStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width-50, height: 200)
                        .foregroundColor(Color("TextBox"))
                        .cornerRadius(8)
                        .overlay(
                            ScrollView{
                                VStack{
                                    Spacer()
                                    ForEach(upcoming_flights) { flight in
                                        UpcomingFlightsView(departingAirport: flight.airport, flightDate: flight.date )
                                    }
                                }
                            }
                        )
                }
                
            
            }.frame(width:UIScreen.main.bounds.width-20,height: 275)
                .background(Color.white)
                .cornerRadius(10)
            .onAppear{
                fetchFlights(userId: user.id)
            }
        }
    }
    func fetchFlights(userId: String){
        print("DEBUG:Retrieving user flights")
        let db = Firestore.firestore()
        db.collection("users").document("\(userId)").collection("userFlights").getDocuments { snapshot, error in
            if error ==  nil {
                // no errors
                if let snapshot = snapshot{
                    // Update list property
                    DispatchQueue.main.async {
                        upcoming_flights = snapshot.documents.map { d in
                            guard let idString = d["id"] as? String,
                                  let userId = d["userId"] as? String,
                                  let timestamp = d["date"] as? Timestamp,
                                  let airport = d["airport"] as? String else {
                                      // Skip this document if any of the required fields is missing
                                      return nil
                                  }

                            return Flight(
                                id: UUID(uuidString: idString) ?? UUID(),
                                userId: userId,
                                date: timestamp.dateValue(),
                                airport: airport
                            )
                        }
                        .compactMap { $0 } // Filter out any nil values resulting from missing required fields

                    }
                }else{ print ("DEBUG: shit happened")}
            
            }else{
                print("DEBUG: more shit happened")
            }
        }
        
    }
}

struct UpcomingFlightView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingFlightView()
    }
}
