//
//  UpcomingFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct UpcomingFlightView: View {
    var body: some View {
        VStack{
            HStack(spacing: -30){
                Text("Upcoming flights")
                    .font(.system(size:22,weight: .medium))
                    .frame(width: UIScreen.screenWidth-50, alignment:.leading)
                
                NavigationLink(destination: signupView()) {
                    Image(systemName:"plus.circle.fill")
                        .resizable()
                        .frame(width:25, height:25)
                        .foregroundColor(Color("Gold"))
                }
            }
            
            LazyVStack{
                Rectangle()
                    .frame(width: UIScreen.screenWidth-50, height: 200)
                    .foregroundColor(Color("TextBox"))
                    .cornerRadius(8)
                    .overlay(
                        ScrollView{
                            VStack{
                                Spacer()
                                ForEach(0 ... 3, id: \.self) { _ in
                                    UpcomingFlightsView()
                                }
                            }
                        }
                    )
            }
            
        
        }
    }
}

struct UpcomingFlightView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingFlightView()
    }
}