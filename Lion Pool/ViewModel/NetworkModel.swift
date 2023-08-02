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
    @Published var confirmedMatches: [Match] = []
    @Published var flights: [UUID: Flight] = [:]
    @Published var requests: [UUID: Request] = [:]
    @Published var inRequests: [UUID: [Request]] = [:]
    
    let decoder = JSONDecoder()
    let baseURL = "http://localhost:3000/api"
    
    
    func signOut (){
        self.matches = [:]
        self.flights = [:]
        self.confirmedMatches = []
        self.requests = [:]
        self.inRequests = [:]
    }
    
    func fetchMatches (userId: String){
        print("Attempting to fetch matches")
        let fullURL = "\(baseURL)/user/fetchMatches?userId=\(userId)"
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
                    let decodedMatches = try self.decoder.decode([Match].self, from: data)
                    DispatchQueue.main.async {
                        for match in decodedMatches {
                            self.confirmedMatches.append(match)
                        }
                    }
                } catch {
                    print("\(error.localizedDescription)")
                    print("Error fetching matches")
                    return
                }
            }
        }
        dataTask.resume()
        print("Just fetched flights for this bitch")
    }
    
    func updateNotify (flightId: UUID, userId: String){
        let fullURL = "\(baseURL)/user/updateNotify?flightId=\(flightId)&userId=\(userId)"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error{
                print("Reject request error", error)
                return
            }
            guard let response = response as? HTTPURLResponse else{
                print("Error withh response")
                return
            }
            if response.statusCode == 200{
                print("Updated notification status")
                return
            }else{
                print("Failed to update notification status")
                return
            }
        }
        dataTask.resume()
    }
    
    func acceptRequest (request: Request, currentUser: User){
        // Reciever data
        let fullURL = "\(baseURL)/user/acceptRequest"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        
        
        let matchData: [String: Any] = [
            "requestId": request.id.uuidString,
            "recieverFlightId": request.recieverFlightId.uuidString,
            "recieverName": String(format: "%@ %@", currentUser.firstname, currentUser.lastname),
            "recieverUserId": request.recieverUserId,
            "recieverPfp":currentUser.pfpLocation,
            "senderFlightId":request.senderFlightId.uuidString,
            "senderName": request.name,
            "senderUserId": request.senderUserId,
            "senderPfp":request.pfp,
            "date": request.flightDate,
            "airport": request.airport
        ]
        
        
        httpRequest.httpBody = try? JSONSerialization.data(withJSONObject: matchData)
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTask(with: httpRequest) {data, response, error in
            if let error = error {
                print("Error with accpeting request: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print ("Status code: \(httpResponse .statusCode)")
                if httpResponse.statusCode == 200 {
                    //use MatchData to populate a match and add it to the matches array
                    DispatchQueue.main.async{
                        self.confirmedMatches.append(Match(id: request.id, flightId: request.recieverFlightId, matchFlightId: request.senderFlightId, matchUserId: request.senderUserId, date: request.flightDate, pfp: request.pfp, name: request.name, airport: request.airport))
                    }
                } else{
                    print("Could not add flight!")
                }
            }
        }
        dataTask.resume()
    }
    
    func rejectRequest (request: Request, userId: String){
        print("Attempting to reject")
        let id = request.id
        let fullURL = "\(baseURL)/user/rejectRequest?id=\(id)&recieverUserId=\(userId)&senderUserId=\(request.senderUserId)"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error{
                print("Reject request error", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("Error withh response")
                return
            }
            
            if response.statusCode == 200{
                DispatchQueue.main.async{
                    if var inRequestsArray = self.inRequests[request.recieverFlightId] {
                        if let indexToDelete = inRequestsArray.firstIndex(where: {$0 == request}){
                            inRequestsArray.remove(at: indexToDelete)
                            self.inRequests[request.recieverFlightId] = inRequestsArray
                        }
                    }
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    
    func fetchInRequests(userId: String){
        print("Attempting to fetch incoming requests")
        let fullURL = "\(baseURL)/user/fetchInRequests?userId=\(userId)"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Request error: ",error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("Error with response")
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let decodedRequests = try self.decoder.decode([Request].self, from: data)
                    DispatchQueue.main.async {
                        for request in decodedRequests {
                            let recieverFlightId = request.recieverFlightId
                            if var existingRequests = self.inRequests[recieverFlightId] {
                                // If there are existing requests for this recieverFlightId, append the new request to the array
                                existingRequests.append(request)
                                self.inRequests[recieverFlightId] = existingRequests
                            } else {
                                // If there are no existing requests for this recieverFlightId, create a new array and add the request
                                self.inRequests[recieverFlightId] = [request]
                            }
                        }
                        return
                    }
                } catch {
                    print("\(error.localizedDescription)")
                    print("Error decoding requests fron Inrequests")
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchRequests(userId: String){
        print("Attempting to fetch request")
        let fullURL = "\(baseURL)/user/fetchRequests?userId=\(userId)"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Request error: ",error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("Error with response")
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                do {
                    let decodedRequests = try self.decoder.decode([Request].self, from: data)
                    DispatchQueue.main.async {
                        for request in decodedRequests{
                            self.requests[request.senderFlightId] = request
                        }
                        return
                    }
                } catch {
                    print("\(error.localizedDescription)")
                    print("Error decoding requests from fetchRequests")
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    
    func sendRequest(match: Match, senderUserId: String, completion: @escaping (Result)-> Void){
        print("Attempting to send request")
        let fullURL = "\(baseURL)/matches/request?senderFlightId=\(match.flightId)&senderUserId=\(senderUserId)&recieverFlightId=\(match.matchFlightId)&recieverUserId=\(match.matchUserId)"
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
                    print(data)
                    let decodedRequest = try self.decoder.decode(Request.self, from: data)
                    DispatchQueue.main.async{
                        self.requests[decodedRequest.senderFlightId] = decodedRequest
                        completion(.success)
                    }
                }catch {
                    DispatchQueue.main.async{
                        print("Error from sendrequest: \(error.localizedDescription)")
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
        print("Attempting to fetch flights")
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
                    let decodedFlights = try self.decoder.decode([Flight].self, from: data)
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
        print("Attempting to add flight")
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
                        let flightData = try self.decoder.decode(Flight.self, from: data)
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
            print("Attempting to get matches")
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
                        let decodedMatches = try self.decoder.decode([Match].self, from: data)
                        DispatchQueue.main.async {
                            self.matches[flightId] = decodedMatches
                            print(decodedMatches)
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
    
    func deleteFlight(userId: String, flightId: UUID, airport: String, completion: @escaping (Result) -> Void){
        print("Attempting to delete flights")
        let userId = userId
        let flightId = flightId
        let airport = airport
        
        let fullURL = "\(baseURL)/flight/deleteFlight?flightId=\(flightId)&userId=\(userId)&airport=\(airport)"
        print(fullURL)
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
//                    self.matches.removeValue(forKey: flightId)
                    self.requests.removeValue(forKey: flightId)
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
