//
//  FlightDetailVie.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/23/23.
//

import SwiftUI

struct FlightDetailView: View {
    @Binding var flight: Flight
    
    //Objects to apply logic
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var networkModel: NetworkModel
    
    @Environment(\.presentationMode) var presentationMode
    
    private let monthAbbrev: [String: String ] = [
        "January" : "Jan",
        "February" : "Feb",
        "March": "Mar",
        "April": "Apr",
        "August": "Aug",
        "September": "Sept",
        "October": "Oct",
        "November": "Nov",
        "December": "Dev"
    ]
    
    let fmt = ISO8601DateFormatter()
    
//     Calculate the difference in days and return a formatted string
    var diffs: Int {
        let date = flight.dateFromISOString(flight.date)
        let components = Calendar.current.dateComponents([.day], from: Date(), to: date!)
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
                            
                            Text(formattedDate(flight.dateFromISOString(flight.date)!))
                                .font(.system(size: 42))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))


                            Text("TIME:")
                                .font(.system(size: 20, weight: .thin))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text(formattedTime(flight.dateFromISOString(flight.date)!))
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
                if let user = userModel.currentUser{
                    let result = try await networkModel.deleteFlight(userId: user.id, flightId: flight.id,  airport: flight.airport){ result in
                        switch result {
                        case .success:
                            presentationMode.wrappedValue.dismiss()
                        case .failure:
                            print("could not delete")
                        }
                    }
                }
                
            }
        }label: {
            Image(systemName: "trash.circle.fill")
                .resizable()
                .frame(width:60,height:60)
                .foregroundColor(Color.red)
        }
    }
    
    private func formattedDate( _ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    
        let monthString = dateFormatter.string(from: date)
        if let abbreviatedMonth = monthAbbrev[monthString] {
            return abbreviatedMonth
        }
        return monthString
    }

    private func formattedTime(_ date: Date) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}


