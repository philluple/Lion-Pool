//
//  InstagramView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/17/23.
//

import SwiftUI

struct InstagramView: View {
    var body: some View {
        NavigationView {
            ZStack {
//                Image(uiImage: instagramImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .edgesIgnoringSafeArea(Edge.Set.all)
                VStack{
                    Button(action: {
                        //get instagram user data
                    }) {
                        Image("Instagram_Icon")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    }
                    Button(action: {
                        //get instagram media
                    }){
                        Text("Fetch Media to background")
                            .font(.headline)
                            .padding()
                    }
                }
            }
        }
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
