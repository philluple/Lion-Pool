//
//  Network.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import Foundation
import SwiftUI

enum FetchResult {
    case success([match])
    case noMatches
    case failure(Error)
}

class Network: ObservableObject{
    var matches: [match] = []

    let baseURL = "http://localhost:3000/api/matches"
    
    func getMatches(newFlightDocID: String, airport: String, currentUser: String, completion: @escaping (FetchResult) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let document = newFlightDocID
        let airport = airport
        let fullURL = "\(baseURL)?docId=\(document)&airport=\(airport)&currentUser=\(currentUser)"
        
        guard let url = URL(string: fullURL) else { fatalError("Missing URL")}
        print("URL: \(url)")
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
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
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
