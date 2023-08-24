//
//  InstagramModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/23/23.
//

import Foundation
import SwiftUI

struct ImageFeed: Codable {
    var feed: [String: String]
    var username: String
}

struct IdentifiableImage: Identifiable{
    let id: String
    let image: UIImage
}

class InstagramAPI: ObservableObject{
    @Published var posts: [IdentifiableImage] = []
    
    func loadImageData(from imageURL: URL, id: String) {
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    let identifiableImage = IdentifiableImage(id: id, image: uiImage)
                    self.posts.append(identifiableImage)
                }
            } else if let error = error {
                print("Error loading image:", error)
            }
        }.resume()
    }
    
    func getAuthToken (from url: URL) {
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
                                    let decoder = JSONDecoder()
                                    let imageFeed = try decoder.decode(ImageFeed.self, from: data)
                                    let username = imageFeed.username
                                    UserDefaults.standard.set(username, forKey: "instagram_handle")
                                    DispatchQueue.main.async{
                                        if !imageFeed.feed.isEmpty {
                                            for (key, value) in imageFeed.feed {
                                                if let imageURL = URL(string: value) {
                                                    if let imageData = try? Data(contentsOf: imageURL) {
                                                        if let uiImage = UIImage(data: imageData) {
                                                            let identifiableImage = IdentifiableImage(id: key, image: uiImage)
                                                            self.posts.append(identifiableImage)
                                                        }
                                                    }
                                                }
                                            }
                                        } else{
                                            print("Empty")
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
