//
//  NewSignUp.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    let fontSize = (CGFloat)(18)
    let tfHeight = (CGFloat)(50)
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size:fontSize,weight: .regular))
                .frame(width: UIScreen.main.bounds.width-50, alignment:.leading)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .padding(.all)
                    .font(.system(size:18,weight: .regular))
                    .frame(width: UIScreen.main.bounds.width-40, height:tfHeight)
                    .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
                    .disableAutocorrection(true)
            }else{
                TextField(placeholder, text: $text)
                    .disableAutocorrection(true)
                    .padding(.all)
                    .frame(width: UIScreen.main.bounds.width-40, height:tfHeight)
                    .background(RoundedRectangle(cornerRadius:10).fill(Color("Text Box")))
            }
            
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address:", placeholder: "uni@columbia.edu")
    }
}
