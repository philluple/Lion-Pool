//
//  UpcomingFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/12/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

                
struct FlightListView: View {
//    @State var upcoming_flights = [Flight]()
    @State private var confirmedFlight: Bool = false
    @State private var needRefreshList: Bool = false
    @State private var initialFetch = false

    @EnvironmentObject var viewModel : UserModel
    @EnvironmentObject var networkModel: NetworkModel

    
    
    var body: some View {
        if let user = viewModel.currentUser{
            VStack {
                HStack(){
                    Text("Upcoming flights")
                        .font(.system(size:22,weight: .medium))
                    Spacer()
                    CustomNavLink(destination: AddFlightView(confirmedFlight: $confirmedFlight).customNavigationTitle("Add a flight").customNavigationSize(35)) {
                        Text("Add flight")
                            .foregroundColor(Color.white)
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 90, height: 25)
                            .background(Color("Gold"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing,15)
                    }
                }
                .padding(.leading, 15)
                .padding(.top, 10)
                ScrollView{
                    VStack{
                        ForEach(Array(networkModel.flights.values), id: \.self) { flight in
                            FlightView(flight: flight)
                        }
                    }
                }
            }
            .frame(width:UIScreen.main.bounds.width-20,height: calculateHeight(for: networkModel.flights.count))
            .background(Color.white)
            .cornerRadius(10)
            .onAppear{
                if !initialFetch{
                    networkModel.fetchFlights(userId: user.id)
                    networkModel.fetchRequests(userId: user.id)
                    initialFetch.toggle()
                }
            }
        }else{
            Text("Hello")
        }
    }
    
    private func calculateHeight(for count: Int) -> CGFloat {
        let maxItemCount: Int = 4
        let itemHeight: CGFloat = 45
        
        if count == 0 {
            return CGFloat(50)
        }
        else if count < maxItemCount {
            return CGFloat(count) * itemHeight + 50
        } else {
            return CGFloat(4) * itemHeight
        }
    }
}

struct UpcomingFlightView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            FlightListView()
                .environmentObject(UserModel())
        }
        
    }
}
