//
//  imageUtils.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/3/23.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore

enum ImageResult{
    case success(UIImage)
    case failure
}

class ImageUtils {
    
    func uploadPhoto(userId: String, selectedImage: UIImage?) async {
        guard let selectedImage = selectedImage else { return }
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
//        let encoded = try! PropertyListEncoder().encode(imageData)
//        UserDefaults.standard.set(encoded, forKey: "profile-image")
    
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("profile-images/\(userId)-pfp.jpg")
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                // Handle any errors that occur during the upload
                print("Error uploading image:", error.localizedDescription)
            } else {
                db.collection("users").document(userId).setData(["pfpLocation": "profile-images/\(userId)-pfp.jpg"], merge: true)
            }
        }
        self.updatePhoto(userId: userId)
    }
    
    func updatePhoto(userId: String){
        let fullURL = "https://lion-pool.com/api/updateImage?userId=\(userId)"
        guard let url = URL(string: fullURL) else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (_, response, _) in
            guard let response = response as? HTTPURLResponse else {
                print("Error with response")
                return
            }

            if response.statusCode == 200 {
                return
            }
        }
        dataTask.resume()
    }
    
    func fetchImage(userId: String, completion: @escaping (ImageResult) -> Void) {
        let fullURL = "http://34.125.37.144:3000/api/fetchImage?userId=\(userId)"
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


