//
//  Network.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

enum MatchResult {
    case success([match])
    case noMatches
    case failure
}

enum AddResult{
    case success(Flight)
    case failure
}

class Network: ObservableObject{
    var matches: [match] = []
    let dateFormatter = DateFormatter()
//    var flight = Flight(id: UUID(), userId: "user123", airport: "JFK", date: "2023-07-27T12:34:56Z", foundMatch: true)

    let baseURL = "http://localhost:3000/api"
    
    func addFlight(userId: String, date: Date, airport: String, completion: @escaping (AddResult)-> Void) {

        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: date)
        
        let userId  = userId
        let date = formattedDate
        let airport = airport
        
        let fullURL = "\(baseURL)/flight/addFlight"
        print (fullURL)
        guard let url = URL(string: fullURL) else { fatalError("Missing URL")}
        
        // Form the HTTP Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let flightData: [String: Any] = [
            "userId": userId,
            "date": date,
            "airport": airport
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: flightData)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                print("Error with adding flight: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print ("Status code: \(httpResponse .statusCode)")
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        DispatchQueue.main.async{
                            completion(.failure)
                        }
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let flightData = try decoder.decode(Flight.self, from: data)
                        DispatchQueue.main.async{
                            print("SUCCESS: Successfully added flight")
//                            self.flight = flightData
                            completion(.success(flightData))
                        }
                    } catch let decodingError{
                        DispatchQueue.main.async{
                            print("DEBUG: Could not decode, ERR: \(decodingError)")
                            completion(.failure)
                        }
                    }
                } else{
                    print("Could not add flight!")
                    DispatchQueue.main.async{
                        completion(.failure)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func getMatches(flightId: UUID, userId: String, airport: String, completion: @escaping (MatchResult) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let flightId = flightId
        let airport = airport
        let userId = userId
        let fullURL = "\(baseURL)/matches?flightId=\(flightId)&userId=\(userId)&airport=\(airport)"
        print(fullURL)
        guard let url = URL(string: fullURL) else { fatalError("Missing URL")}
        let urlRequest = URLRequest(url:url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            print("Status code: \(response.statusCode)")
            if response.statusCode == 200 {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.noMatches)
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decodedMatches = try decoder.decode([match].self, from: data)
                    print(decodedMatches)
                    DispatchQueue.main.async {
                        self.matches = decodedMatches
                        completion(.success(decodedMatches))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure)
                    }
                }

            }
            if response.statusCode == 204 {
                DispatchQueue.main.async {
                    completion(.noMatches)
                }
            }
        }
        
        dataTask.resume()
        print("Count: \(matches.count)")
    }

}
