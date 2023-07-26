//
//  ConfirmFlightDetailsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/21/23.
//

import SwiftUI

struct ConfirmFlightDetailsView: View {
    //This comes from add flight
    @Binding var dateToConfirm: Date
    @Binding var airportToConfirm: String
    @Binding var flightAddedSuccessfully: Bool
    //Objects to apply logic
    @EnvironmentObject var flightViewModel: FlightViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var network: Network
    @Environment(\.presentationMode) var presentationMode
    let dateFormatter = DateFormatter(dateFormat: "yyyyMMddHHmmss")

    var body: some View {
        NavigationView{
            VStack {
                Text("Let's confirm!")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(SwiftUI.Color("Dark Blue "))
                    .padding([.top, .bottom])
                    .frame(width:UIScreen.main.bounds.width, height: 70)
                    .background(SwiftUI.Color("Gray Blue "))
                
                Spacer()

                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ZStack(alignment: .bottomTrailing){
                        VStack(alignment: .leading){
                            Group{
                                Rectangle()
                                    .frame(width: 350, height:150)
                                    .foregroundColor(Color("DarkGray"))
                                    .overlay{
                                        Text(airportToConfirm)
                                            .font(.system(size: 150, weight: .thin))
                                            .foregroundColor(Color.white)
                                            .padding(.leading,5)
                                    }
                            }
                            Text("DATE:")
                                .font(.system(size: 20, weight: .thin))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text(dateToConfirm, style:.date)
                                .font(.system(size: 42))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text("TIME:")
                                .font(.system(size: 20, weight: .thin))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text(dateToConfirm, style:.time)
                                .font(.system(size: 42))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                        }
                        .padding()
                        .background(Color("Text Box"))
                        
                        
                    }

                    }
                
                Text("click to edit")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("Gold"))
                
                Spacer()
                // Apply the logic
                Button  {
                    Task{
                        if let user = viewModel.currentUser{
                            let result = try await flightViewModel.addFlight(userId: user.id, date: dateToConfirm, airport: airportToConfirm)
                            if result == 1{
                                //Load HomeView
//                                let dateString = dateFormatter.string(from: dateToConfirm)
//                                let documentID = "\(dateString)-\(user.id)"
                                //await network.getMatches(newFlightDocID: documentID, airport: airportToConfirm, currentUser: user.id)
                                //apply the logic
                                flightViewModel.fetchFlights(userId: user.id)
                                flightAddedSuccessfully.toggle()
                            }
                        }
                    }
                } label: {
                    HStack{
                        Text("Add flight!")
                            .font(.system(size:18,weight: .bold))
                            .frame(width:UIScreen.main.bounds.width-40, height:52)
                            .accentColor(Color.white)
                    }
                }
                .background(Color("Gold"))
                .cornerRadius(10)
                .padding(.top, 24)
                    
                Spacer()
            }
        }

    }
}

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

//struct ConfirmFlightDetailsView_Previews: PreviewProvider {
//    @State static var flightAddedSuccessfully: Bool = false
//    @State static var date: Date = Date()
//    @State static var departAirport = "EWR"
//
//    static var previews: some View {
//        ConfirmFlightDetailsView(dateToConfirm: $date, airportToConfirm:  $departAirport, flightAddedSuccessfully: $flightAddedSuccessfully)
//    }
//}
