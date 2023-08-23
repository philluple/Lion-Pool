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
    @EnvironmentObject var viewModel: UserModel
    @EnvironmentObject var flightModel: FlightModel
    @EnvironmentObject var matchModel: MatchModel
    @EnvironmentObject var requestModel: RequestModel

    var body: some View {
        CustomNavView{
            ScrollView {
                VStack () {
                    Spacer()
                    VStack (spacing: 15){
                        ListOfFlights
                        ConfirmedMatchesListView()
                    }
                }
            }.overlay(PageHeader)
                .frame(width:UIScreen.main.bounds.width )
                .background(Color("Text Box"))
                .background(ignoresSafeAreaEdges: .all)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
    }
    
    private var PageHeader: some View{
        ZStack {
            HStack{
                Text("LionPool")
                    .font(.system(size: 30, weight: .bold))
//                    .font(Font.custom("ChicagoFlf", size: 32))
                    .foregroundColor(Color("Dark Blue "))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading],UIScreen.main.bounds.width/30)
                
                CustomNavLink(destination: ProfileView().customNavigationTitle("Account info").customNavigationSize(30)){
                    if let image = viewModel.currentUserProfileImage{
                        image
                            .resizable()
                            .frame(width:35, height:35)
                            .foregroundColor(Color("Dark Blue "))
                            .overlay(Circle().stroke(Color("Text Box"), lineWidth: 2))
                            .clipShape(Circle())
                            .padding([.trailing],UIScreen.main.bounds.width/40)
                            .padding(.vertical, 4)

                    }else{
                        Image(systemName:"person.fill")
                            .resizable()
                            .frame(width:30, height:30)
                            .foregroundColor(Color("Dark Blue "))
                            .padding([.trailing],UIScreen.main.bounds.width/40)
                            .padding(.bottom,2)

                    }
                }
            }
            .padding([.trailing, .leading])
            .background(Color("Gray Blue "))
            .frame(width: UIScreen.main.bounds.width, height: 0)
            .frame(maxHeight: UIScreen.main.bounds.height, alignment: .top)
        }
    }
    
    private var ListOfFlights: some View{
        FlightListView()
            .padding(.top, UIScreen.main.bounds.height/35)
    }
}
    
