//
//  HomeScreen.swift
//  LionPool
//
//  Created by Phillip Le on 6/10/22.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
       StartScreenView()
        
    }
}

extension ContentView {
    private var HeyLionHeader: some View{
        HStack{
            Spacer()
            Text("Hey, Lion")
                .font(.system(size:70,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
            Spacer()
        }.padding()
            .accentColor(Color.white)
            .foregroundColor(Color("Dark Blue "))
            .background(Color("Gray Blue ").ignoresSafeArea(edges:.top))
    }
    
    var mainInterfaceView: some View{
        VStack{
            HeyLionHeader
            ScrollView{
                VStack(spacing:25){
                    UpcomingFlightView()
                        .padding(.top)
                    RideMatchesView()
                    ScheduledRidesView()
                    Spacer()
                }
            }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}


