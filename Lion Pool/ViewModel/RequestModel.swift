//
//  RequestsModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/1/23.
//

import Foundation


class RequestModel: ObservableObject{
    @Published var requests: [UUID: Request] = [:]
    @Published var inRequests: [UUID: [Request]] = [:]
    
    let jsonDecoder = JSONDecoder()
    let baseURL = "http://localhost:3000/api"
    

    enum Result{
        case success
        case failure
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
    
    func acceptRequest (request: Request, currentUser: User, completion: @escaping (Result)-> Void){
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
                        completion(.success)
                        
//                        self.confirmedMatches.append(Match(id: request.id, flightId: request.recieverFlightId, matchFlightId: request.senderFlightId, matchUserId: request.senderUserId, date: request.flightDate, pfp: request.pfp, name: request.name, airport: request.airport))
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
                    let decodedRequests = try self.jsonDecoder.decode([Request].self, from: data)
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
                    let decodedRequests = try self.jsonDecoder.decode([Request].self, from: data)
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
                    let decodedRequest = try self.jsonDecoder.decode(Request.self, from: data)
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
    
    
}
