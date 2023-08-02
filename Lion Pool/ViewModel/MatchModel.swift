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
    @Published var matchesConfirmed: [Match] = []
    
    let jsonDecoder = JSONDecoder()
    let baseURL = "http://localhost:3000/api"
    
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
                    let decodedMatches = try self.jsonDecoder.decode([Match].self, from: data)
                    DispatchQueue.main.async {
                        for match in decodedMatches {
                            self.matchesConfirmed.append(match)
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
