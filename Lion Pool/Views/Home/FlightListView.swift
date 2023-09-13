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
    @EnvironmentObject var flightModel: FlightModel
    @EnvironmentObject var requestModel: RequestModel

    
    
    var body: some View {
        VStack {
            HStack(){
                Text("Upcoming flights")
                    .font(.system(size:20,weight: .medium))
                Spacer()
                CustomNavLink(destination: AddFlightView(confirmedFlight: $confirmedFlight).customNavigationTitle("Add a flight").customNavigationSize(30)) {
                    Text("Add flight")
                        .foregroundColor(Color.white)
                        .font(.system(size: 14, weight: .bold))
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
                    ForEach(Array(flightModel.flights.enumerated()), id: \.element.id) { (index, flight) in
                        FlightView(flight: flight)
                        
                        if index != flightModel.flights.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }

                }
            }
        }
        .frame(width:UIScreen.main.bounds.width-20,height: calculateHeight(for: flightModel.flights.count))
        .background(Color.white)
        .cornerRadius(10)
        
    }
    
    private func calculateHeight(for count: Int) -> CGFloat {
        let maxItemCount: Int = 5
        let itemHeight: CGFloat = 55
        
        if count == 0 {
            return CGFloat(50)
        }
        else if count < maxItemCount {
            return CGFloat(count) * itemHeight + 40
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
                .environmentObject(FlightModel())
                .environmentObject(RequestModel())
        }
        
    }
}
