//
//  Flight.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import Foundation
import FirebaseFirestore

struct Flight: Codable, Identifiable{
    let id: UUID
    let userId: String
    let date: Date
    let airport: String
}

class sharedFlightData: ObservableObject{
    @Published var oldFlightDate = Date()
    @Published var oldAirport = ""
}

class flightList: ObservableObject{
    @Published var flights: [Flight] = []
    
    func fetchFlights(userId: String){
        print("DEBUG:Retrieving user flights from here")
        let db = Firestore.firestore()
        db.collection("users").document("\(userId)").collection("userFlights").getDocuments { snapshot, error in
            if error ==  nil {
                // no errors
                if let snapshot = snapshot{
                    // Update list property
                    DispatchQueue.main.async {
                        self.flights = snapshot.documents.map { d in
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

