//
//  NewSignUp.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI
struct UserDataView: View {
    let title: String
    let userInfo: String
    
    let fontSize = (CGFloat)(16)
    let tfHeight = (CGFloat)(45)
    
    var body: some View {
        HStack(){
            Text(title)
                .font(.system(size:fontSize,weight: .semibold))
                .foregroundColor(Color.black)
                .padding(.leading)
                //.frame(width: UIScreen.main.bounds.width-50, alignment:.leading)
            Spacer()
            Text(userInfo)
                .font(.system(size:fontSize,weight: .semibold))
                .foregroundColor(Color.gray)
                .padding(.trailing)
                
        }.frame(width:UIScreen.main.bounds.width-30, height: 60)
            .background(RoundedRectangle(cornerRadius:5).fill(Color("Text Box")))

    }
}

struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataView(title: ("Email"), userInfo: "pnl2111@columbia.edu")
    }
}

