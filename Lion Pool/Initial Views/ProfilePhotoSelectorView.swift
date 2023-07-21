//
//  ProfilePhotoSelectorVie.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/20/23.
//

import SwiftUI

struct ProfilePhotoSelectorView: View {
    @State private var showImagePicker = false
    var body: some View {
        VStack{
            Logo(fontColor: "Dark Blue ", fontSize: 65)
                .frame(width: UIScreen.main.bounds.width, height: 90)
                .background(Color("Gray Blue "))
                .padding([.bottom],2)
            Spacer()
            
            Button {
                showImagePicker.toggle()
            }label:{
                Circle()
                    .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
                
            }
        }
    }
}

struct ProfilePhotoSelectorVie_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
    }
}
