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
    func addFlight (userId: String, date: Date, airport: String) async throws -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: date)
        let documentName = "\(dateString)-\(airport)"
        
        do{
            let flight = Flight(id: UUID(), userId: userId, date: date, airport: airport)
            let encodedFlight = try Firestore.Encoder().encode(flight)
            try await Firestore.firestore().collection("flights").document(flight.airport).setData(encodedFlight)
            try await Firestore.firestore().collection("users").document(userId).collection("userFlights").document(documentName).setData(encodedFlight)
        } catch {
        print("DEBUG: could not create account", error.localizedDescription)
        }
        
        //atp we have added a flight:
        
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
