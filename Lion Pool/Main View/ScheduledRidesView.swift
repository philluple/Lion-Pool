//
//  ScheduledRidesView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct ScheduledRidesView: View {
    var body: some View {
        VStack{
            Text("Scheduled rides")
                .font(.system(size:22,weight: .medium))
                .frame(width: UIScreen.main.bounds.width-50, alignment:.leading)
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width-50, height: 200)
                .foregroundColor(Color("TextBox"))
                .cornerRadius(8)
            Spacer()
        }
    }
}

struct ScheduledRidesView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledRidesView()
    }
}
