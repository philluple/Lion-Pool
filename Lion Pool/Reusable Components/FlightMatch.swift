//
//  FlightMatch.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import SwiftUI
import FirebaseStorage


struct FlightMatch: View {
    let match: match?
    @State private var matchImage: UIImage? // Assuming this is a UIImage

    var body: some View {
        if let match = match{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("Text Box"))
                .frame(width: UIScreen.main.bounds.width - 50, height: 200)
                .overlay{
                    HStack{
                        if let image = matchImage {
                            Image(uiImage: image)
                                .resizable()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color("TextOutlineDark"), lineWidth: 4))
                                .aspectRatio(contentMode: .fit)
                                .frame(width:150, height:150)
                            
                            
                        }else{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            
                        }
                        VStack{
                            Text(match.name)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color("Dark Blue "))
                            Text("CC '24")
                            HStack{
                                RoundedRectangle(cornerRadius:10)
                                    .fill(Color("Gold"))
                                    .frame(width: 150, height:30)
                                    .overlay{
                                        Text(" Send request")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color("DarkGray"))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                    }
                               
                            }
                        }
                        

                    }
                }
            .onAppear{
                loadImage()
                print ("SUCCESS: loaded the image")
            }

        }else{
            Text("nothing there")
        }
    }


    func loadImage(){
        
        guard let pfp = match?.pfp, !pfp.isEmpty else {
                return
        }
        
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: pfp)
        httpsReference.getData(maxSize: 750*750) { data, error in
            if let error = error {
                print("DEBUG: Error retrieving profile picture: \(error.localizedDescription)")
            } else {
                if let data = data, let image = UIImage(data: data) {
                    matchImage = image
                    print("SUCCESS: Downloaded user profile photo")
                }
            }
        }
    }
}

struct FlightMatch_Previews: PreviewProvider {
    static var previews: some View {
        @State var newMatch = match(date: "2023-08-01T02:03:00.000Z", pfp: "https://firebasestorage.googleapis.com:443/v0/b/lion-pool-f5755.appspot.com/o/profile-images%2FFeqlCm9u3kQgRXbIaVaLLYrvldE3-pfp.jpg?alt=media&token=36fe4246-87a7-43cb-ab07-5d22cc315c6e", userId: "FeqlCm9u3kQgRXbIaVaLLYrvldE3", name: "Lion Cunt")
        FlightMatch(match: newMatch)
    }
}
