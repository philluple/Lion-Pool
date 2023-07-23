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
            print("deleting document")
            try await Firestore.firestore().collection("flights").document(flight.airport).collection("userFlights").document("\(dateString)-\(flight.userId)").delete()
            try await Firestore.firestore().collection("users").document(flight.userId).collection("userFlights").document(documentName).delete()
            print("deleted document")
        }catch{
            print("DEBUG: could not delete flight", error.localizedDescription)
        }
        return 1
    }
    
    func editFlight (oldFlight: Flight, newFlight: Flight) async throws -> Int{
        return 1
    }

    func fetchDocuments(for userId: String, completion: @escaping ([Flight]?, Error?) -> Void) {
        let userFlightsRef = Firestore.firestore().collection("users").document(userId).collection("userFlights")
        
        userFlightsRef.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([], nil)
                return
            }
            
            var flights: [Flight] = []
            
            for document in documents {
                if let documentData = document.data() as? [String: Any] {
                    do {
                        let documentObject = try Firestore.Decoder().decode(Flight.self, from: documentData)
                        flights.append(documentObject)
                    } catch {
                        completion(nil, error)
                        return
                    }
                }
            }
            
            completion(flights, nil)
        }
    }


}
