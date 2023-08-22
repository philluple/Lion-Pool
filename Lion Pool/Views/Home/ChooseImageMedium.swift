//
//  ChooseImageMedium.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/21/23.
//

import SwiftUI

struct ChooseImageMedium: View {
    @Binding var camera: Bool
    @Binding var library: Bool
    @Binding var selected: Bool
    @Binding var showSheet: Bool
    @Binding var changedPfp: Bool
    @State private var profileImagePicker: Image?
    @State private var selectedImage: UIImage?
//    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userModel: UserModel
    var imageUtils = ImageUtils()

    var body: some View {
        if let image = selectedImage{
            VStack{
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .overlay(Circle().stroke(Color("Text Box"), lineWidth: 4))
                    .clipShape(Circle())
                
                if let name = UserDefaults.standard.string(forKey: "name"){
                    if let index = name.range(of: " ")?.lowerBound {
                        let firstName = String(name.prefix(upTo: index)) // Extract everything before the first space
                        Text("Looking good, \(firstName)!")
                            .font(.system(size:16,weight: .semibold))
                    }
                }
                
                HStack{
                    Button {
                        showSheet.toggle()
                    } label: {
                        Text("Cancel")
                            .font(.system(size:18,weight: .bold))
                            .frame(width:UIScreen.main.bounds.width/2-40, height:52)
                            .accentColor(.white)
                    }.background(Color("Gold"))
                        .cornerRadius(10)
                        .padding()
                        .accentColor(Color.white)

                    Button {
                        if let id = UserDefaults.standard.string(forKey: "userId"){
                            Task{
                                await imageUtils.uploadPhoto(userId: id, selectedImage: image)
                                showSheet.toggle()
                                changedPfp.toggle()
                            }
                        }else{
                            print("In the else")
                        }
                    } label: {
                        Text("Confirm")
                            .font(.system(size:18,weight: .bold))
                            .frame(width:UIScreen.main.bounds.width/2-40, height:52)
                            .accentColor(.white)
                        
                    }.background(Color("Gold"))
                        .cornerRadius(10)
                        .padding()
                        .accentColor(Color.white)

                }
            }.frame(height:UIScreen.main.bounds.height/3)
                .padding(.top)
            
            
        }else{
            VStack(alignment: .leading) {
                Text("Change Profie Image")
                    .font(.system(size: 18, weight: .semibold))
                VStack(alignment: .leading){
                    Button {
                       camera = true
                        library = false
                        selected = true
                    } label: {
                        HStack{
                            Image(systemName: "camera")
                            Text("Camera")
                                .font(.system(size:16,weight: .bold))
                        }
                    }
                    Divider()
                        .padding(.horizontal, 20)
                    Button {
                        camera = false
                        library = true
                        selected = true
                    } label: {
                        HStack{
                            Image(systemName: "photo")
                            Text("Photo Library")
                                .font(.system(size:16,weight: .bold))
                        }
                    }
                    .sheet(isPresented: $selected, onDismiss: loadImage){
                        Lion_Pool.ImagePicker(selectedImage: $selectedImage, isCameraSource: $camera)
                    }
                }.padding(.top)
                    .accentColor(Color.gray)
            }.padding(.bottom)
                .padding(.leading)

        }
    }
    
    func loadImage(){
        guard let selectedImage = selectedImage else { return}
        profileImagePicker = Image(uiImage: selectedImage)
    }
}

struct ChooseImageMedium_Previews: PreviewProvider {
    static var previews: some View {
        ChooseImageMedium(camera: .constant(true), library: .constant(false), selected: .constant(false), showSheet: .constant(true), changedPfp: .constant(false))
    }
}
