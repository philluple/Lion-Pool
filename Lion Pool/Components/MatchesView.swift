//
//  Matchesview.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct MatchesView: View {
    var body: some View {
        VStack{
            Image("Geneva")
                .resizable()
                .frame(width:95, height:95)
                .clipShape(Circle())
            
            Text("Geneva Ng")
                .font(.system(size:17,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
            
            Text("Rideshare to JFK")
                .font(.system(size:15))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray)
            
            Text("Oct 10\n@10:30AM")
                .font(.system(size:15))

                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray)
        }.padding(.vertical)
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
