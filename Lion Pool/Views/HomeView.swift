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
    @EnvironmentObject var networkModel: NetworkModel
    
    var body: some View {
        CustomNavView{
            ScrollView {
                VStack () {
                    Spacer()
                    VStack (spacing: 15){
                        ListOfFlights
                        RequestListView()
                    }
                }
            }.overlay(PageHeader)
                .frame(width:UIScreen.main.bounds.width )
                .background(Color("Text Box"))
                .background(ignoresSafeAreaEdges: .all)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .onAppear{
            if let user = viewModel.currentUser{
                networkModel.fetchFlights(userId: user.id)
                networkModel.fetchRequests(userId: user.id)
                networkModel.fetchInRequests(userId: user.id)
            }
        }
    }
    
    private var PageHeader: some View{
        ZStack {
            HStack{
                Text("LionPool")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(Color("Dark Blue "))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading],UIScreen.main.bounds.width/30)
                //.padding([.bottom, .top, .leading],10)
                
                CustomNavLink(destination: ProfileView().customNavigationTitle("Account info").customNavigationSize(35)){
                    if let image = viewModel.currentUserProfileImage{
                        Image(uiImage: image)
                            .resizable()
                            .frame(width:40, height:40)
                            .foregroundColor(Color("Dark Blue "))
                            .overlay(Circle().stroke(Color("Text Box"), lineWidth: 4))
                            .clipShape(Circle())
                            .padding([.trailing],UIScreen.main.bounds.width/40)
                    }else{
                        Image(systemName:"person.fill")
                            .resizable()
                            .frame(width:30, height:30)
                            .foregroundColor(Color("Dark Blue "))
                            .padding([.trailing],UIScreen.main.bounds.width/40)
                    }
                }
            }
            .padding([.trailing, .leading])
        }
            .background(Color("Gray Blue "))
            .frame(width: UIScreen.main.bounds.width, height: 0)
            .frame(maxHeight: UIScreen.main.bounds.height, alignment: .top)
    }
    private var ListOfFlights: some View{
        FlightListView()
            .padding(.top, UIScreen.main.bounds.height/35)
        //.overlay(alignment: .topTrailing){
        //}
    }
}
    
struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
            .environmentObject(UserModel())
            .environmentObject(NetworkModel())
    }
}
