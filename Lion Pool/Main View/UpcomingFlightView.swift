//
//  UpcomingFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI

struct UpcomingFlightView: View {
    @State var addFlight:Bool = false
    var body: some View {
        VStack{
            //Upcoming Flights + Button
            HStack(spacing: -30){
                Text("Upcoming flights")
                    .font(.system(size:22,weight: .medium))
                    .frame(width: UIScreen.main.bounds.width-50, alignment:.leading)
                Button {
                    addFlight.toggle()
                } label: {
                    Image(systemName:"plus.circle.fill")
                        .resizable()
                        .frame(width:25, height:25)
                        .foregroundColor(Color("Gold"))
                }
            }
            LazyVStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width-50, height: 200)
                    .foregroundColor(Color("TextBox"))
                    .cornerRadius(8)
                    .overlay(
                        ScrollView{
                            VStack{
                                Spacer()
                                ForEach(0 ... 3, id: \.self) { _ in
                                    UpcomingFlightsView()
                                } // For each
                            } // Vstack
                        } // Scroll View
                    ) // Overlay
            } // LazyStack
            .sheet(isPresented: $addFlight){
                AddFlightView()
            }
        } // Vstack
    }
}

struct UpcomingFlightView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingFlightView()
    }
}
