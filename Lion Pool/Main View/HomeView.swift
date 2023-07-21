//
//  HomeView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser{
            CustomNavView{
                ScrollView {
                    VStack (spacing: 15) {
                        UpcomingFlightView()
                            .padding([.top],UIScreen.main.bounds.height/25)
                        ScheduledRidesView()
                    }
                    
                }.overlay(
                    ZStack {
                        HStack{
                            Text("LionPool")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(Color("Dark Blue "))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading],UIScreen.main.bounds.width/25)
                                //.padding([.bottom, .top, .leading],10)
                            
                            CustomNavLink(destination: ProfileView().customNavigationTitle("Hey, \(user.firstname)").customNavigationSize(35)){
                                Image(systemName:"person.fill")
                                    .resizable()
                                    .frame(width:30, height:30)
                                    .foregroundColor(Color("Dark Blue "))
                                    //.padding([.trailing],UIScreen.main.bounds.width/25)
                            }
                            
                            
                        }.padding([.trailing, .leading])
                        
                    }
                        .background(Color("Gray Blue "))
                        .frame(width: UIScreen.main.bounds.width, height: -10)
                        .frame(maxHeight: UIScreen.main.bounds.height, alignment: .top)
                )
                .frame(width:UIScreen.main.bounds.width )
                .background(Color("Text Box"))
                .background(ignoresSafeAreaEdges: .all)
            }
            .edgesIgnoringSafeArea(.all)
        }else{
            Text("help")
        }
    }
}




struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
