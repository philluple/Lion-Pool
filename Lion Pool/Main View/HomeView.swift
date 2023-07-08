//
//  HomeView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack (spacing: 20) {
                    UpcomingFlightView()
                        .padding([.top],UIScreen.main.bounds.height/15)
                    ScheduledRidesView()
                    RideMatchesView()
                    UpcomingFlightView()
                    
                    
                }
                
            }.overlay(
                ZStack {
                    Color.clear
                        .background(.thinMaterial)
                    
                    HStack{
                        Text("Hey, Lion")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Color("Dark Blue "))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading],UIScreen.main.bounds.width/25)
                            .padding([.bottom, .top, .leading],10)
                        
                        NavigationLink(destination: ProfileView()){
                            Image(systemName:"person.circle")
                                .resizable()
                                .frame(width:30, height:30)
                                .foregroundColor(Color("Dark Blue "))
                                .padding([.trailing],UIScreen.main.bounds.width/25)
                            
                        }.navigationBarBackButtonHidden()
                            
                        
                    }//.frame(width: UIScreen.main.bounds.width)
                    //.background(Color("Gray Blue "))
                    //.navigationBarBackButtonHidden(true)
                    
                    
                }
                    .frame(height: 30)
                    .frame(maxHeight: UIScreen.main.bounds.height, alignment: .top)
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
