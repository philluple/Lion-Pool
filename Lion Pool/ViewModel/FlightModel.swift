//
//  FlightsModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/1/23.
//

import Foundation

enum FlightResult{
    case success
    case failure
}
    
enum AddResult{
    case success(Flight)
    case failure
}

class FlightModel: ObservableObject{
    //    @Published var flights: [UUID: Flight] = [:]
    @Published var flights: [Flight] = []
    
    let jsonDecoder = JSONDecoder()
    let baseURL = "http://34.125.37.144:3000/api/flight"
    
    init(){
        if let userId = UserDefaults.standard.string(forKey: "userId"){
            fetchFlights(userId: userId)
        }
    }

    func signIn(){
        let userId = UserDefaults.standard.string(forKey: "userId")
        fetchFlights(userId: userId!)
    }
    
    func signOut(){
        self.flights = []
    }
    
    func fetchFlights(userId: String){
        print("Attempting to fetch flights")
        self.flights = []
        let fullURL = "\(baseURL)/fetchFlights?userId=\(userId)"
        print(fullURL)
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
                    let decodedFlights = try self.jsonDecoder.decode([Flight].self, from: data)
                    DispatchQueue.main.async {
                        for flight in decodedFlights {
                            self.flights.append(flight)
                            
                        }
                        UserDefaults.standard.set(self.flights.count, forKey: "flights")
                    }
                } catch {
                    print("\(error.localizedDescription)")
                    print("Error decoding flights")
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    func deleteFlight(userId: String, flightId: UUID, airport: String, completion: @escaping (FlightResult) -> Void){
        print("Attempting to delete flights")
        let userId = userId
        let flightId = flightId
        let airport = airport
        
        let fullURL = "\(baseURL)/deleteFlight?flightId=\(flightId)&userId=\(userId)&airport=\(airport)"
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
                    if let index = self.flights.firstIndex(where: { $0.id == flightId }) {
                        self.flights.remove(at: index)
                    } else {
                        // Object with target ID not found in the array
                    }
                    if let existingCounter = UserDefaults.standard.value(forKey: "flights") as? Int{
                        let incrementedCounter = existingCounter - 1
                        UserDefaults.standard.set(incrementedCounter, forKey: "flights")
                    } else{
                        UserDefaults.standard.set(self.flights.count, forKey: "flights")
                    }
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
    
    func addFlight(userId: String, date: Date, airport: String, completion: @escaping (AddResult)-> Void) {
        print("Attempting to add flight")
        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: date)
        
        let userId  = userId
        let date = formattedDate
        let airport = airport
        
        let fullURL = "\(baseURL)/addFlight"
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
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        DispatchQueue.main.async{
                            completion(.failure)
                        }
                        return
                    }
                    do {
                        let flightData = try self.jsonDecoder.decode(Flight.self, from: data)
                        DispatchQueue.main.async{
                            self.flights.sort { $0.date < $1.date }
                            if let insertionIndex = self.flights.firstIndex(where: { $0.date > flightData.date }) {
                                self.flights.insert(flightData, at: insertionIndex)
                            } else {
                                self.flights.append(flightData)
                            }
                            completion(.success(flightData))
                            if let existingCounter = UserDefaults.standard.value(forKey: "flights") as? Int{
                                let incrementedCounter = existingCounter + 1
                                UserDefaults.standard.set(incrementedCounter, forKey: "flights")
                            } else{
                                UserDefaults.standard.set(self.flights.count, forKey: "flights")
                            }
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
    
}
