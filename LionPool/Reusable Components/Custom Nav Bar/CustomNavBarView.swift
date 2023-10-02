//
//  CustomNavBarView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/20/23.
//

import SwiftUI

struct CustomNavBarView: View {
    @Environment(\.presentationMode) var presentationMode
    let title: String
    let fontSize: CGFloat
    let showBackButton: Bool
    
    var body: some View {
        HStack{
            if showBackButton{
                backButton
            }
            Spacer()
            VStack(spacing: 4){
                Text(title)
                    .font(.system(size:fontSize, weight: .bold))
                    .foregroundColor(Color("Dark Blue "))
                
            }
            Spacer()
            if showBackButton{
                backButton
                    .opacity(0)
            }
            
        }
        //.padding([.top],UIScreen.main.bounds.height/250)
        .padding(.leading)
        .background(Color("Gray Blue ").ignoresSafeArea(edges:.top))
        .accentColor(Color("Dark Blue "))
    }
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CustomNavBarView(title: "Add a Flight", fontSize: 35, showBackButton: true)
            Spacer()
        }
        
    }
}
extension CustomNavBarView {
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("Dark Blue "))
        })
    }
}
