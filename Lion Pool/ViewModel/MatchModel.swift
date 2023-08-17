//
//  MatchesViewModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/1/23.
//

import Foundation

enum MatchResult {
    case success
    case noMatches
    case failure
}

class MatchModel: ObservableObject{
    @Published var matchesFound: [UUID: [Match]] = [:]
    @Published var matchesConfirmed: [UUID: [Match]] = [:]
    let userId = UserDefaults.standard.string(forKey: "userId")

    
    init(){
        fetchMatches()
    }
    
    let jsonDecoder = JSONDecoder()
    let baseURL = "http://localhost:3000/api/match"
    
    func signIn(){
        let userId = UserDefaults.standard.string(forKey: "userId")
        fetchMatches()
    }
    
    func signOut(){
        self.matchesFound = [:]
        self.matchesConfirmed = [:]
    }
    
    func fetchMatches (){
        self.matchesConfirmed = [:]
        let fullURL = "\(baseURL)/fetchMatches?userId=\(String(describing: userId))"
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
                    let decodedMatches = try self.jsonDecoder.decode([Match].self, from: data)
                    DispatchQueue.main.async {
                        for match in decodedMatches {
                            if var existingMatches = self.matchesConfirmed[match.flightId] {
                                // If there are existing requests for this recieverFlightId, append the new request to the array
                                existingMatches.append(match)
                                self.matchesConfirmed[match.flightId] = existingMatches
                            } else {
                                // If there are no existing requests for this recieverFlightId, create a new array and add the request
                                self.matchesConfirmed[match.flightId] = [match]
                            }
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
    
    func findMatch(flightId: UUID, userId: String, airport: String, completion: @escaping (MatchResult) -> Void) {
        self.matchesFound = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let flightId = flightId
        let userId = userId
        let airport = airport
        let fullURL = "\(baseURL)/findMatch?flightId=\(flightId)&userId=\(userId)&airport=\(airport)"
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
                    let decodedMatches = try self.jsonDecoder.decode([Match].self, from: data)
                    DispatchQueue.main.async {
                        self.matchesFound[flightId] = decodedMatches
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
    }
    
}
