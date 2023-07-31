import Foundation
import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    let baseURL = "http://localhost:3245/api"
    
    func loadImage(from url: URL, completion: @escaping (Image?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(Image(uiImage: cachedImage))
        } else {
            // Fetch the image from the backend API
            fetchImageFromBackend(url: url) { data in
                if let imageData = data, let uiImage = UIImage(data: imageData) {
                    // Cache the image data for future use
                    self.cache.setObject(uiImage, forKey: url as NSURL)
                    completion(Image(uiImage: uiImage))
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    private func fetchImageFromBackend(url: URL, completion: @escaping (Data?) -> Void) {
        let fullURL = "\(baseURL)/fetchImage?url=\(url)"
        guard let url = URL(string: fullURL) else {fatalError("Missing URL")}
        let urlRequest = URLRequest(url:url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Error processing image request ", error)
            }
            guard let response = response as? HTTPURLResponse else{
                print("Error with response")
                return
            }
            if response.statusCode == 200, let imageData = data {
                completion(imageData)
            } else{
                print("Error fetching image data")
                completion(nil)
            }
        }
        dataTask.resume()
    }

}

