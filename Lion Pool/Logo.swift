//
//  Logo.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI

struct Logo: View {
    var fontColor: String
    var fontSize: CGFloat
    // add all parameters in the init
    init(fontColor: String, fontSize: CGFloat) {
        self.fontColor = fontColor
        self.fontSize = fontSize
    }

    var body: some View {
        VStack(alignment: .center, spacing: -22){
            Text("Lion Pool")
                .font(.system(size:fontSize,weight: .bold))
                .foregroundColor(Color(fontColor))
            Text("safer together")
                .font(.system(size:fontSize/2,weight: .bold))
                .foregroundColor(Color(fontColor))
        }
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo(fontColor: "Dark Blue ", fontSize: 70)
    }
}
