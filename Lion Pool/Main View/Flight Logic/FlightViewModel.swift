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

class FlightViewModel: ObservableObject{
    @Published var flights: [Flight] = []

    let dateFormatter = DateFormatter()

    func addFlight (userId: String, date: Date, airport: String) async throws -> Int{
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: date)
        let dateAdded = Date()
        let documentName = "\(dateString)-\(airport)"
        do{
            let flight = Flight(id: UUID(), userId: userId, date: date, airport: airport)
            let encodedFlight = try Firestore.Encoder().encode(flight)
            try await Firestore.firestore().collection("flights").document(flight.airport).collection("userFlights").document("\(dateString)-\(userId)").setData(encodedFlight)
            try await Firestore.firestore().collection("users").document(userId).collection("userFlights").document(documentName).setData(encodedFlight)
            print("SUCCESS: \(userId) added a flight on \(dateString) from \(airport)")
        } catch {
            print("DEBUG: could not add flight", error.localizedDescription)
        }
        
        //atp we have added a flight:
        
        return 1
    }
    
    func deleteFlight (flight: Flight) async throws -> Int{
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: flight.date)

        let documentName = "\(dateString)-\(flight.airport)"
        print("airport: \(flight.airport) date: \(dateString) user id: \(flight.userId)")
        do{
            try await Firestore.firestore().collection("flights").document(flight.airport).collection("userFlights").document("\(dateString)-\(flight.userId)").delete()
            try await Firestore.firestore().collection("users").document(flight.userId).collection("userFlights").document(documentName).delete()
            print("SUCCESS: \(flight.userId) deleted a flight on \(dateString) from \(flight.airport)")
        }catch{
            print("DEBUG: could not delete flight", error.localizedDescription)
        }
        return 1
    }
    
    func editFlight (oldFlight: Flight, newFlight: Flight) async throws -> Int{
        return 1
    }
    
    func fetchFlights(userId: String) {
            print("DEBUG: Retrieving user flights")
            let db = Firestore.firestore()
            db.collection("users").document("\(userId)").collection("userFlights").getDocuments { snapshot, error in
                if error ==  nil {
                    // no errors
                    if let snapshot = snapshot {
                        // Update the flights property directly
                        DispatchQueue.main.async {
                            self.flights = snapshot.documents.compactMap { d in
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
                        }
                    } else {
                        print("DEBUG: Error fetching flights: \(error?.localizedDescription ?? "")")
                    }
                } else {
                    print("DEBUG: Error fetching flights: \(error?.localizedDescription ?? "")")
                }
            }
        }



}
