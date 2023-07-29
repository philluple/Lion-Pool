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
    case success
    case noMatches
    case failure
}

enum AddResult{
    case success(Flight)
    case failure
}

enum Result{
    case success
    case failure
    
}



class NetworkModel: ObservableObject{
    
    @Published var matches: [UUID: [Match]] = [:]
    @Published var flights: [UUID: Flight] = [:]
    @Published var requests: [Request] = []
    
    
        
    let baseURL = "http://localhost:3000/api"
    
    func signOut (){
        matches = [:]
        flights = [:]
    }
    
    func sendRequest(match: Match, senderUserId: String, completion: @escaping (Result)-> Void){
        let fullURL = "\(baseURL)/matches/request?senderFlightId=\(match.senderFlightId)&senderUserId=\(senderUserId)&recieverFlightId=\(match.recieverFlightId)&recieverUserId=\(match.recieverUserId)"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        let URLrequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: URLrequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                return
            }
            
            if(response.statusCode == 200){
                guard let data = data else{
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decodedRequest = try decoder.decode(Request.self, from: data)
                    DispatchQueue.main.async{
                        print("Added a request")
                        self.requests.append(decodedRequest)
                        completion(.success)
                    }
                }catch {
                    DispatchQueue.main.async{
                        print("Error: \(error.localizedDescription)")
                        completion(.failure)
                    }
                }

            } else{
                DispatchQueue.main.async{
                    completion(.failure)
                }
            
            }
        }
        dataTask.resume()
    }
    
    func fetchFlights(userId: String){
        let userId = userId
        let fullURL = "\(baseURL)/user/fetchFlights?userId=\(userId)"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Error with response")
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decodedFlights = try decoder.decode([Flight].self, from: data)
                    DispatchQueue.main.async {
                        for flight in decodedFlights {
                            self.flights[flight.id] = flight
                        }
                    }
                } catch {
                    print("\(error.localizedDescription)")
                    print("Error decoding flights")
                    return
                }
            }
        }
        dataTask.resume()
        print("Just fetched flights for this bitch")
    }
    
    
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
                            self.flights[flightData.id] = flightData
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
        let userId = userId
        let airport = airport
        let fullURL = "\(baseURL)/matches?flightId=\(flightId)&userId=\(userId)&airport=\(airport)"
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
                    let decodedMatches = try decoder.decode([Match].self, from: data)
                    DispatchQueue.main.async {
                        self.matches[flightId] = decodedMatches
                        completion(.success)
                    }
                } catch let error {
                    print("Decoding error: \(error)")
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
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else {
//                return
//            }
//            if response.statusCode == 200 {
//                guard let data = data else {
//                    DispatchQueue.main.async {
//                        completion(.noMatches)
//                    }
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    let decodedMatches = try decoder.decode(Match.self, from: data)
//                    DispatchQueue.main.async {
////                        self.matches[flightId] = decodedMatches
//                        completion(.success)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        print("failed to execute the do statement \(error.localizedDescription) " )
//                        completion(.failure)
//                    }
//                }
//
//            }
//            if response.statusCode == 204 {
//                DispatchQueue.main.async {
//                    completion(.noMatches)
//                }
//            }
//        }
        
//        dataTask.resume()
//        print("Count: \(matches.count)")
//    }
    
    func deleteFlight(userId: String, flightId: UUID, airport: String, completion: @escaping (Result) -> Void){
        let userId = userId
        let flightId = flightId
        let airport = airport
        
        let fullURL = "\(baseURL)/flight/deleteFlight?flightId=\(flightId)&userId=\(userId)&airport=\(airport)"
        guard let url = URL(string: fullURL) else { fatalError("Missing URL")}
        let urlRequest = URLRequest(url:url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure)
                }
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.flights.removeValue(forKey: flightId)
                    self.matches.removeValue(forKey: flightId)
                    completion(.success)
                }
            } else {
                // Prompt the user to try again later - 500
                DispatchQueue.main.async {
                    completion(.failure)
                }
                
            }
        }
        dataTask.resume()
    }
}
