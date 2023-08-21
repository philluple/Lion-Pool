//
//  imageUtils.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/3/23.
//

import Foundation
import UIKit

enum ImageResult{
    case success(UIImage)
    case failure
}

class ImageUtils {
    
    func fetchImage(userId: String, completion: @escaping (ImageResult) -> Void) {
        let fullURL = "https://lion-pool.com/api/fetchImage?userId=\(userId)"
        guard let url = URL(string: fullURL) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion(.failure)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Error with response")
                completion(.failure)
                return
            }

            if response.statusCode == 200 {
                guard let data = data else {
                    print("No data received")
                    completion(.failure)
                    return
                }
                do {
                    // Ensure that the base64 string is valid by converting it to Data
                    guard let imageData = Data(base64Encoded: data) else {
                        print("Invalid base64 image data")
                        completion(.failure)
                        return
                    }
                    
                    // Create a UIImage from the image data
                    if let uiImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            completion(.success(uiImage))
                        }
                    } else {
                        print("Error creating UIImage from data")
                        completion(.failure)
                    }
                } catch {
                    print("Error decoding image data: \(error)")
                    completion(.failure)
                    return
                }
            }else {
                print("Error: Status code \(response.statusCode)")
                completion(.failure)
            }
        }
        dataTask.resume()
    }

    

    
}


