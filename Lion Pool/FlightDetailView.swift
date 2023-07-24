//
//  FlightDetailVie.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/23/23.
//

import SwiftUI

struct FlightDetailView: View {
    @Binding var flight: Flight
    @Binding var needRefreshFromExpand: Bool

    //Objects to apply logic
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var flightModel: FlightViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let fmt = ISO8601DateFormatter()

        // Calculate the difference in days and return a formatted string
    var diffs: Int {
        let components = Calendar.current.dateComponents([.day], from: Date(), to: flight.date)
        return components.day ?? 0
    }

    var body: some View {
        VStack {
            Text("\(diffs) days until...")
                .font(.system(size: 45, weight: .bold))
                .foregroundColor(SwiftUI.Color("Dark Blue "))
                .padding([.top, .bottom])
                .frame(width:UIScreen.main.bounds.width, height: 70)
                .background(SwiftUI.Color("Gray Blue "))
            
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("TextBox"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("TextOutline"), lineWidth: 4))
                .frame(width: UIScreen.main.bounds.width - 20, height: 350)
                .overlay {
                    ZStack(alignment: .bottomTrailing){
                        VStack(alignment: .leading){
                            Group{
                                Rectangle()
                                    .frame(width: 350, height:150)
                                    .foregroundColor(Color("DarkGray"))
                                    .overlay{
                                        Text(flight.airport)
                                            .font(.system(size: 150, weight: .thin))
                                            .foregroundColor(Color.white)
                                            .padding(.leading,5)
                                    }
                            }
                            Text("DATE:")
                                .font(.system(size: 20, weight: .thin))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text(flight.date, style:.date)
                                .font(.system(size: 42))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text("TIME:")
                                .font(.system(size: 20, weight: .thin))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text(flight.date, style:.time)
                                .font(.system(size: 42))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                        }
                    }
                }
            HStack{
                Spacer()
                deleteFlightButton
                    .padding(.trailing)
            }.padding(.top)
            Spacer()
        }
    }
    private var deleteFlightButton: some View{
        Button {
            Task{
                let result = try await flightModel.deleteFlight(flight: flight)
                if result == 1{
                    print("DEBUG: user deleted flight")
                    needRefreshFromExpand.toggle()
                }
            }
        } label: {
            Image(systemName: "trash.circle.fill")
                .resizable()
                .frame(width:60,height:60)
                .foregroundColor(Color.red)
        }
    }
}

//struct FlightDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        FlightDetailView(flight: <#T##Binding<Flight>#>, needRefreshFromExpand: <#T##Binding<Bool>#>)
//    }
//}
