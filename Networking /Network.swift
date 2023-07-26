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
    @Published var foundMatch: Bool = false
    let baseURL = "http://localhost:3000/api/matches"
    
    func getMatches(newFlightDocID: String, airport: String, currentUser: String) async{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let document = newFlightDocID
        let airport = airport
        let fullURL = "\(baseURL)?docId=\(document)&airport=\(airport)&currentUser=\(currentUser)"
        print(fullURL)
        guard let url = URL(string: fullURL) else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url:url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            self.foundMatch = false
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }
            print("Status code: \(response.statusCode)")
            if response.statusCode == 200 {
                print("inside 200")
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        print(data)
                        let decoder = JSONDecoder()
                        let decodedMatches = try decoder.decode([match].self, from: data)
                        self.matches = decodedMatches
                        self.foundMatch.toggle()
                        print("inside 200")
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
            if response.statusCode == 204 {
                DispatchQueue.main.async {
                    print("inside 204")
                    self.foundMatch = false
                }
            }
        }

        dataTask.resume()
        print("here after resume")
    }

}

