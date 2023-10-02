//
//  InstagramModel.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/23/23.
//

import Foundation
import SwiftUI

struct ImageFeed: Codable {
    var username: String
    var feed: [post]
}

struct post: Codable, Identifiable {
    var id: String
    var imageURL: String
    var time: String
}

struct IdentifiableImage: Identifiable{
    let id: String
    let image: UIImage
    let time: Date
}

class InstagramAPI: ObservableObject{
    @Published var feed: [post] = []
    @Published var posts: [IdentifiableImage] = []
    @Published var displayPost: Bool = false
    
    let dateFormatter = DateFormatter()
    
    init(){
        if let userId = UserDefaults.standard.string(forKey: "userId"){
            print(userId)
            fetchFeed(userId: userId)
        }
    }
    
    func signOut (){
        self.feed = []
        self.posts = []
    }
    
    func fetchFeed(userId: String) {
        print("Fetching feed")
        self.feed = []
        let fullURL = "https://lion-pool.com/api/fetchFeed?userId=\(userId)"
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
                    let decoder = JSONDecoder()
                    let imageFeed = try decoder.decode([post].self, from: data)
                    DispatchQueue.main.async {
                        if !imageFeed.isEmpty {
                            for post in imageFeed {
                                let timeDate = self.dateFormatter.date(from: post.time) ?? Date()
                                if let index = self.posts.firstIndex(where: { $0.time <= timeDate }) {
                                    self.feed.insert(post, at: index)
                                } else {
                                    self.feed.append(post) // If it's the latest date
                                }
                            }
                            self.displayPost = true
                        } else {
                            print("Empty")
                            
                        }
                    }
                } catch {
                    print("\(error.localizedDescription)")
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    func loadImageData(id: String, post: post) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let url = URL(string: post.imageURL) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let timeDate = self.dateFormatter.date(from: post.time) ?? Date()
                        let identifiableImage = IdentifiableImage(id: id, image: uiImage, time: timeDate)
                        // Find the appropriate index to insert the new image
                        if let index = self.posts.firstIndex(where: { $0.time <= timeDate }) {
                            self.posts.insert(identifiableImage, at: index)
                        } else {
                            self.posts.append(identifiableImage) // If it's the latest date
                        }
                    }
                } else if let error = error {
                    print("Error loading image:", error)
                }
            }.resume()
        }
    }
    
        func saveImageFeed(feed: ImageFeed) {
            do {
                let encodedData = try JSONEncoder().encode(feed)
                UserDefaults.standard.set(encodedData, forKey: "feed")
            } catch {
                print("Error encoding posts:", error)
            }
        }

        // Load posts from UserDefaults
    func loadPostsFromUserDefaults() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let encodedData = UserDefaults.standard.data(forKey: "feed") {
            do {
                let decodedPosts = try JSONDecoder().decode(ImageFeed.self, from: encodedData)
                for post in decodedPosts.feed {
                    //value is the post
                    let timeDate = dateFormatter.date(from: post.time) ?? Date()
                    if let index = self.posts.firstIndex(where: { $0.time <= timeDate }) {
                        self.feed.insert(post, at: index)
                    } else {
                        self.feed.append(post) // If it's the latest date
                    }
                }
                
            } catch {
                print("Error decoding posts:", error)
            }
        }
    }

    // Initial
    func getAuthToken(from url: URL) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems,
               let code = queryItems.first(where: { $0.name == "code" })?.value {
                let fullURL = "https://lion-pool.com/api/instagram-auth"
                
                guard let url = URL(string: fullURL) else {
                    fatalError("Missing URL")
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let requestData: [String: String] = [
                    "userId": userId,
                    "code": code
                ]
                
                request.httpBody = try? JSONSerialization.data(withJSONObject: requestData)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error with sending the request: ", error)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200, let data = data {
                            do {
                                let decoder = JSONDecoder()
                                let imageFeed = try decoder.decode(ImageFeed.self, from: data)
                                let username = imageFeed.username
                                DispatchQueue.main.async {
                                    if !imageFeed.feed.isEmpty {
                                        for post in imageFeed.feed {
                                            //value is the post
                                            let timeDate = dateFormatter.date(from: post.time) ?? Date()
                                            if let index = self.posts.firstIndex(where: { $0.time <= timeDate }) {
                                                self.feed.insert(post, at: index)
                                            } else {
                                                self.feed.append(post) // If it's the latest date
                                            }
                                        }
                                        self.saveImageFeed(feed: imageFeed)
                                        self.displayPost = true
                                        UserDefaults.standard.set(username, forKey: "instagram_handle")
                                    } else {
                                        print("Empty")
                                        
                                    }
                                }
                            } catch {
                                print("Error parsing JSON", error)
                            }
                        } else {
                            print("There was a problem with your instagram: ", httpResponse.statusCode)
                        }
                    }
                }
                
                dataTask.resume()
            }
        }
    }
}
