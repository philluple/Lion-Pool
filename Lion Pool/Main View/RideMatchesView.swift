//
//  MatchesView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct RideMatchesView: View {
    var body: some View {
        VStack{
            
                Text("Matches")
                .font(.system(size:22,weight: .medium))
                .frame(width: UIScreen.main.bounds.width-50, alignment:.leading)
                
            
            LazyVStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width-50, height: 225)
                    .foregroundColor(Color("TextBox"))
                    .cornerRadius(8)
                    .overlay(
                        ScrollView(.horizontal){
                            HStack(spacing:5){
                                Spacer()
                                ForEach(0 ... 3, id: \.self) { _ in
                                    MatchesView()
                                    Divider()
                                        .padding([.top, .leading, .bottom])
                                        .opacity(50)
                                    Spacer()
                                }
                            }
                        }
                    )
            }
           
            
        }
    }
}


struct RideMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        RideMatchesView()
    }
}
