//
//  AddFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/13/22.
//

import SwiftUI
import Swift


struct AddFlightView: View {
    @State private var departAirport = ""
    @State private var date = Date()
    @State private var confirmDetailsBool: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel


    
    var airports = ["EWR", "JFK", "LGA"]
    var body: some View {
        //Overall stack to maintain header
        VStack(spacing: 0){
            List{
                // Departure Details + image
                Section{
                    HStack{
                        Text("Date of departure")
                            .font(.system(size:22,weight: .semibold))
                            .padding([.top, .leading])
                    }
            
                    HStack(){
                        DatePicker(selection: $date, label: { /*@START_MENU_TOKEN@*/Text("Date and time:").font(.system(size:18,weight: .semibold)) })
                            .padding(.horizontal)
                            .datePickerStyle(.graphical)
                    }
                }
               
                Section{
                    Picker(selection: $departAirport, label:
                            Text("Airport")
                        .font(.system(size:22, weight: .semibold))
                    ){
                        Text("").tag("")
                        ForEach(airports, id: \.self) {
                            Text($0)
                                .foregroundColor(.red)
                        }
                    }.frame(height:50)
                }
                
                //Confirmation Button
                Section {
                    HStack{
                        Spacer()
                        Spacer()
                    Button(action: {
                        confirmDetailsBool.toggle()
                    }) {
                        Image(systemName: "arrow.forward.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color("Gold")) // Customize the button's color
                        }
                    }.listRowBackground(Color.clear) // Set the button's background to clear
                }
                
            }
            .sheet(isPresented: $confirmDetailsBool){
                confirmationScreen(dateToConfirm: $date, airportToConfirm: $departAirport)
            }
        }
                
    }
}

struct confirmationScreen: View {
    @Binding var dateToConfirm: Date
    @Binding var airportToConfirm: String
    @StateObject private var flightViewModel = FlightViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        VStack {
            Text("Let's confirm!")
                .font(.system(size: 45, weight: .bold))
                .foregroundColor(SwiftUI.Color("Dark Blue "))
                .padding([.top, .bottom])
                .frame(width:UIScreen.main.bounds.width, height: 70)
                .background(SwiftUI.Color("Gray Blue "))
            
            Spacer()
            // Dismiss the button
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                VStack{
                    Text(dateToConfirm, style:.date)
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundColor(SwiftUI.Color("Dark Blue "))
                    Text("out of")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(SwiftUI.Color("Dark Blue "))
                    Text(airportToConfirm)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(SwiftUI.Color("Dark Blue "))
                        .multilineTextAlignment(.center)
                    Text("at")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(SwiftUI.Color("Dark Blue "))
                    Text(dateToConfirm, style:.time)
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundColor(SwiftUI.Color("Dark Blue "))
                }.frame(width: UIScreen.main.bounds.width-10, height: 250)
                    .background(Color("Text Box"))
                    .cornerRadius(30)
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
                    }
                }
            } label: {
                HStack{
                    Text("LET'S MATCH!")
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


struct AddFlightView_Previews: PreviewProvider {
    static var previews: some View {
        
        AddFlightView()
            .accentColor(Color("Gold"))
    }
}
