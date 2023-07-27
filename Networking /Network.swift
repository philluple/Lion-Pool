//
//  Network.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import Foundation
import SwiftUI

class Network: ObservableObject{
    @Published var matches: [match] = []
    @Published var done: Bool = false
    let baseURL = "http://localhost:3000/api/matches"
    
    func getMatches(newFlightDocID: String, airport: String, currentUser: String, completion: @escaping (Int) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let document = newFlightDocID
        let airport = airport
        let fullURL = "\(baseURL)?docId=\(document)&airport=\(airport)&currentUser=\(currentUser)"
        var statusCode = 0
        
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
            statusCode = response.statusCode
            print("Status code: \(response.statusCode)")
            if response.statusCode == 200 {
                guard let data = data else {
                    completion(statusCode)
                    return
                }
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let decodedMatches = try decoder.decode([match].self, from: data)
                        self.matches = decodedMatches
                        statusCode = 200
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
            if response.statusCode == 204 {
                DispatchQueue.main.async {
                    statusCode = 204
                }
            }
            completion(statusCode)
        }
        
        dataTask.resume()
    }

}
