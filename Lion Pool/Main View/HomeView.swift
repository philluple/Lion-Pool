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
    @State private var confirmedFlight: Bool = false
    @State private var isAddingFlight = false
    
    var body: some View {
        if let user = viewModel.currentUser{
            CustomNavView{
                ScrollView {
                    VStack () {
                        Spacer()
                        ListFlightView()
                            .padding(.top, UIScreen.main.bounds.height/35)
                            .overlay(alignment: .topTrailing){
                                CustomNavLink(destination: AddFlightView(confirmedFlight: $confirmedFlight).customNavigationTitle("Add a flight").customNavigationSize(35)) {
                                    Image(systemName:"plus.circle.fill")
                                        .resizable()
                                        .frame(width:30, height:30)
                                        .foregroundColor(Color("Gold"))
                                        .padding(.top,35)
                                        .padding(.trailing,15)
                                }.onChange(of: confirmedFlight){
                                    success in
                                    if success{
                                        print("HomeView")
                                    }
                                }
                            }
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
            CustomNavView{
                ScrollView {
                    VStack (spacing: 15) {
                        ListFlightView()
                            .padding([.top],UIScreen.main.bounds.height/25)
                            .overlay(alignment: .topTrailing){
                                CustomNavLink(destination: AddFlightView(confirmedFlight: $confirmedFlight).customNavigationTitle("Add a flight").customNavigationSize(35)) {
                                    Image(systemName:"plus.circle.fill")
                                        .resizable()
                                        .frame(width:30, height:30)
                                        .foregroundColor(Color("Gold"))
                                        .padding(.top,45)
                                        .padding(.trailing,10)
                                }
                            }
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

                            CustomNavLink(destination: ProfileView().customNavigationTitle("Hey, Lion").customNavigationSize(35)){
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
        }
    }
}




struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
