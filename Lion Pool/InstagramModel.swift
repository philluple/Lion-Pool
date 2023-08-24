//
//  InstagramModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/23/23.
//

import Foundation

class InstagramAPI {
    func getAuthToken (from url: URL){
        if let userId = UserDefaults.standard.string(forKey: "userId"){
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems,
               let code = queryItems.first(where: { $0.name == "code" })?.value {
                let fullURL = "http://34.125.37.144:3000/api/instagram-auth"
                guard let url = URL(string: fullURL) else { fatalError("Missing URL")}
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let requestData: [String: String] = [
                    "userId": userId,
                    "code": code
                ]
                request.httpBody = try? JSONSerialization.data(withJSONObject: requestData)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                print(request)
                
                let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
                    if let error = error {
                        print("Error with sending the request: ", error)
                    }
                    else if let httpResponse = response as? HTTPURLResponse{
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                do {
                                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                                        if let username = json["username"] as? String{
                                            UserDefaults.standard.set(username, forKey: "instagram_user")
                                        }
                                    }
                                } catch {
                                    print("Error parsing JSON", error)
                                }
                            }
                            //print the username
                        } else{
                            print("there was a problem with your instagram: ", httpResponse.statusCode)
                            return
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
}
