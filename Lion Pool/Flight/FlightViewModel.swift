//
//  FlightViewModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore

class FlightViewModel: ObservableObject{
    
    @Published var flights: [Flight] = []
    let dateFormatter = DateFormatter()

    func addFlight (userId: String, date: Date, airport: String) async throws -> Int{
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: date)
        let documentName = "\(dateString)-\(airport)"
        let match: Bool = false
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        let existingFlightQuery = Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("userFlights")
                .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startDate))
                .whereField("date", isLessThan: Timestamp(date: endDate))
                .limit(to: 1)
        do{
            let existingFlightSnapshot = try await existingFlightQuery.getDocuments()
            if !existingFlightSnapshot.isEmpty {
                // A flight with the same airport and date already exists for the user
                print("ERROR: Flight already exists at \(airport) on \(dateString) for user \(userId)")
                return 0
            } else{
                let flight = Flight(id: UUID(), userId: userId, airport: airport, date: "",  foundMatch: match)
                let encodedFlight = try Firestore.Encoder().encode(flight)
                try await Firestore.firestore().collection("flights").document(flight.airport).collection("userFlights").document("\(dateString)-\(userId)").setData(encodedFlight)
                try await Firestore.firestore().collection("users").document(userId).collection("userFlights").document(documentName).setData(encodedFlight)
                print("SUCCESS: \(userId) added a flight on \(dateString) from \(airport)")
            }

 
            //await fetchFlights(userId: userId)
        } catch {
            print("DEBUG: could not add flight", error.localizedDescription)
        }
        return 1
    }
    
//    func deleteFlight (flight: Flight) async throws -> Int{
//        dateFormatter.dateFormat = "yyyyMMddHHmmss"
//        let dateString = dateFormatter.string(from: flight.date)
//        let documentName = "\(dateString)-\(flight.airport)"
//        do{
//            try await Firestore.firestore().collection("flights").document(flight.airport).collection("userFlights").document("\(dateString)-\(flight.userId)").delete()
//            if flight.foundMatch{
//                try await Firestore.firestore().collection("users").document(flight.userId).collection("userFlights").document(documentName).delete()
//            }
//            try await Firestore.firestore().collection("users").document(flight.userId).collection("userFlights").document(documentName).delete()
//            print("SUCCESS: \(flight.userId) deleted a flight on \(dateString) from \(flight.airport)")
//            //await fetchFlights(userId: flight.userId)
//        }catch{
//            print("DEBUG: could not delete flight", error.localizedDescription)
//        }
//        return 1
//    }
//
    func fetchFlights(userId: String){
        let db = Firestore.firestore()
            db.collection("users").document("\(userId)").collection("userFlights").getDocuments { snapshot, error in
                if error ==  nil {
                    // no errorsqw
                    if let snapshot = snapshot {
                        // Update the flights property directly
                        DispatchQueue.main.async {
                            self.flights = snapshot.documents.compactMap { d in
                                guard let idString = d["id"] as? String,
                                      let userId = d["userId"] as? String,
                                      let timestamp = d["date"] as? String,
                                      let airport = d["airport"] as? String,
                                      let foundMatch = d["foundMatch"] as? Bool
                                        else {
                                          // Skip this document if any of the required fields is missing
                                          return nil
                                      }

                                return Flight(
                                    id: UUID(uuidString: idString) ?? UUID(),
                                    userId: userId,
                                    airport: airport,
                                    date: timestamp,
                                    foundMatch: foundMatch
                                )
                            }
                        }
                    } else {
                        print("DEBUG: Error fetching flights: \(error?.localizedDescription ?? "")")
                    }
                } else {
                    print("DEBUG: Error fetching flights: \(error?.localizedDescription ?? "")")
                }
                print("SUCCESS: Fetched flights from db")
            }
        }
    




}

