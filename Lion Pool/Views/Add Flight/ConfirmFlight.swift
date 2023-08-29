//
//  ConfirmFlightDetailsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/21/23.
//


import SwiftUI
import FirebaseFirestore

struct ConfirmFlight: View {
    //This comes from add flight
    @Binding var dateToConfirm: Date
    @Binding var airportToConfirm: String
    @Binding var flightAddedSuccessfully: Bool
    
    @State var flightAdded: Bool = false
    @State var userId: String = ""
    @State var matchesFound: Bool = false
    @State var opacity = 0.0
    @State var addedFlightId: UUID? = nil
    
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var flightModel: FlightModel

    //@StateObject var network: Network
    @Environment(\.presentationMode) var presentationMode
    let dateFormatter = DateFormatter(dateFormat: "yyyyMMddHHmmss")
    
    var body: some View {
        NavigationView{
            VStack {
                PageHeader
                Spacer()
                FlightDetails
                Text("Sorry, each day can only have one flight")
                    .font(.system(size:18, weight:.semibold))
                    .foregroundColor(Color.red)
                    .opacity(opacity)
                ConfirmFlight
                Spacer()
                if let flightId = addedFlightId {
                    NavigationLink(destination: FindingMatchView(flightId: flightId, airport: airportToConfirm, userId: userId, date: dateToConfirm), isActive: $flightAdded){
                        EmptyView()
                    }
                }
            }
        }
    }
    private var FlightDetails: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            VStack{
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
                    .padding(1)
                    .background(Color("Text Box"))

                }
                Text("click to edit")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("Gold"))
            }

            
        }
    }
    
    private var PageHeader: some View{
        Text("Let's confirm!")
            .font(.system(size: 45, weight: .bold))
            .foregroundColor(SwiftUI.Color("Dark Blue "))
            .padding([.top, .bottom])
            .frame(width:UIScreen.main.bounds.width, height: 50)
            .background(SwiftUI.Color("Gray Blue "))
    }
    
    private var ConfirmFlight: some View {
        Button {
            Task {
                if let user = userModel.currentUser {
                        flightModel.addFlight(userId: user.id, date: dateToConfirm, airport: airportToConfirm) { result in
                            switch result {
                            case .success(let flight):
                                DispatchQueue.main.async{
                                    addedFlightId = flight.id
                                    userId = flight.userId
                                    flightAdded.toggle()
                                }
                            case .failure:
                                opacity = 1.0
                            }
                    }
                }
            }
        } label: {
            HStack {
                Text("GET MATCHED")
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: UIScreen.main.bounds.width - 40, height: 52)
                    .accentColor(Color.white)
            }
        }
        .background(Color("Gold"))
        .cornerRadius(10)
        .padding(.top, 24)
    }
}


extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

