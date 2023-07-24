//
//  flight button.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/23/23.
//

import SwiftUI

struct flight_button: View {
    var body: some View {
        Text("Add flight")
            .foregroundColor(Color.white)
            .font(.system(size: 15, weight: .bold))
            .frame(width: 90, height: 20)
            .background(Color("Gold"))
            .clipShape(RoundedRectangle(cornerRadius: 3))

    }
}

struct flight_button_Previews: PreviewProvider {
    static var previews: some View {
        flight_button()
    }
}
