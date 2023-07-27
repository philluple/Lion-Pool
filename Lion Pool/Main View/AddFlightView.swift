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
    @State private var flightAddedSuccessfully: Bool = false

    @Binding var confirmedFlight: Bool
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var airports = ["EWR", "JFK", "LGA"]
    
    let dateRange: PartialRangeFrom<Date> = {
        let calendar = Calendar.current
        let currentDate = Date()
        let startComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let startDate = calendar.date(from: startComponents)!
        return startDate...
    }()
    
    
    var body: some View {
        //Overall stack to maintain header
            VStack(){
                List{
                    DatePicker(
                        "Flight date",
                        selection: $date,
                        in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    ).datePickerStyle(.graphical)
                    
                    Section{
                        VStack{
                            Text("AIRPORT")
                                .font(.system(size:22, weight: .medium))
                            Picker(selection: $departAirport,
                                   label:Text("Airport").font(.system(size:22))){
                                Text("").tag("")
                                ForEach(airports, id: \.self) {
                                    Text($0)
                                        .foregroundColor(.red)
                                }
                            }.pickerStyle(.segmented)
                        }
                    }
                    
                    //Confirmation Button
                    if departAirport != ""{
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
                    
                }
                .sheet(isPresented: $confirmDetailsBool){
                    ConfirmFlight(dateToConfirm: $date, airportToConfirm: $departAirport, flightAddedSuccessfully: $flightAddedSuccessfully)
                    
                        .onChange(of: flightAddedSuccessfully){
                            success in
                            if success{
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                }
            }
        }
    
}

