//
//  CustomLionBar.swift
//  LionPool
//
//  Created by Phillip Le on 6/10/22.
//

import SwiftUI

struct CustomLionBar: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showBackButton: Bool = true
    @State private var title:String = "Lion Pool"//""
    @State private var subtitle: String? = "safer together"//nil
    
    var body: some View {
        HStack{
            if(showBackButton){
                backButton
            }
            Spacer()
            titleSection
            Spacer()
            if(showBackButton){
                backButton
                    .opacity(0)
            }
        }
        .padding()
        .accentColor(Color.white)
        .foregroundColor(Color("Dark Blue "))
        .background(Color("Gray Blue ").ignoresSafeArea(edges:.top))
    }
}

struct CustomLionBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
                .frame(height:-100)
            CustomLionBar()
            Spacer()
        }
    }
}

extension CustomLionBar{
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName:"chevron.left")
        })
    }
    private var titleSection: some View {
        VStack(spacing: -10){
            
            Text(title)
                .font(.system(size:70,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
            
            if let subtitle = subtitle {
                Spacer()
                    .frame(height:-20)
                Text(subtitle)
                .font(.system(size:35,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
            
        }
    }
    
    
}
}

