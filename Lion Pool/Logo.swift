//
//  Logo.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        VStack(alignment: .center, spacing: -22){
            Text("Lion Pool")
                .font(.system(size:70,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
            Text("safer together")
                .font(.system(size:35,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
        }
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
