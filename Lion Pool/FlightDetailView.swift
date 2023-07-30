//
//  FlightDetailVie.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/23/23.
//

import SwiftUI

struct FlightDetailView: View {
    let flight : Flight
    let time =  TimeUtils()
    //Objects to apply logic
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var networkModel: NetworkModel
    @Environment(\.presentationMode) var presentationMode
    
    
//     Calculate the difference in days and return a formatted string
    var diffs: Int {
        if let date = time.dateFromISOString(flight.date) {
            let components = Calendar.current.dateComponents([.day], from: Date(), to: date)
            return components.day ?? 0
        } else{
            return 0
        }
        
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
                            
                            Text(time.formattedDate(flight.date))
                                .font(.system(size: 42))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))


                            Text("TIME:")
                                .font(.system(size: 20, weight: .thin))
                                .foregroundColor(SwiftUI.Color("Dark Blue "))
                            Text(time.formattedTime(flight.date))
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
                    networkModel.deleteFlight(userId: user.id, flightId: flight.id,  airport: flight.airport){ result in
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
    
}


struct FlightDetailView_Previews: PreviewProvider {
    static private var flight = Flight(id: UUID(), userId: "12345", airport: "EWR", date: "July 20, 2023", foundMatch: false)
    static var previews: some View {
        FlightDetailView(flight: flight)
    }
}
