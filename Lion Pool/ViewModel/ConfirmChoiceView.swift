//
//  ConfirmChoiceView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/16/23.
//

import SwiftUI

struct ConfirmChoiceView: View {
    let title: String
    let message: String?
    let flight: Flight?
    let request: Request?
    //If true -> we are deleting flight
    let onConfirm: () -> Void
    let onReject: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack { // Use a ZStack as the outer container
//                Color("TextBox").ignoresSafeArea()
                VStack(spacing: 20){
                    Group{
                        if let flight = flight{
                            FlightDetaiTicket(flight: flight)
                                .padding(.vertical)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("Text Box"), lineWidth: 2)
                                )
                            
                            VStack{
                                Text("\(title)?")
                                    .font(.system(size:20,weight: .semibold))
                                    .textCase(.uppercase)
                                    .padding(.top)
    
                                if let message = message{
                                    Divider()
                                        .padding(.horizontal)
                                    Text(message)
                                        .font(.system(size:14,weight: .semibold))
                                        .foregroundColor(Color("DarkGray"))
                                        .padding(.horizontal)
                                        .multilineTextAlignment(.center)
                                    Divider()
                                        .padding()
                                }
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width, height: 5)
                                    .foregroundColor(Color("Gray Blue "))
                                    .padding(.vertical, 10)
                                HStack(spacing:20){
                                    Button {
                                        onReject()
                                    } label: {
                                        Text("Cancel")
                                            .font(.system(size:15,weight: .bold))
                                            .foregroundColor(Color("DarkGray"))
                                            .frame(width: 120, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                    }
                                    Button {
                                        onConfirm()
                                    } label: {
                                        Text("Yes, delete")
                                            .font(.system(size:15,weight: .bold))
                                            .foregroundColor(Color.white)
                                            .frame(width: 120, height: 40)
                                            .background(Color("Gold"))
                                            .cornerRadius(8)
                                    }
                                   

                                }.padding(.bottom)
                            }.frame(width: UIScreen.main.bounds.width-50, height: 150)
                                .background(Color("Text Box"))
                                .cornerRadius(10)
                
                        }else if let request = request{
                            RequestView(request: request)
                                .padding(.vertical)
                            if let message = message{
                                Text(message)
                                    .font(.system(size:15,weight: .semibold))
                            }
                            HStack(spacing:20){
                                Button {
                                    onReject()
                                } label: {
                                    Text("Cancel")
                                        .font(.system(size:15,weight: .bold))
                                        .foregroundColor(Color("DarkGray"))
                                        .frame(width: 120, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                }
                                Button {
                                    onConfirm()
                                } label: {
                                    Text("Yes, delete")
                                        .font(.system(size:15,weight: .bold))
                                        .foregroundColor(Color.white)
                                        .frame(width: 120, height: 40)
                                        .background(Color("Gold"))
                                        .cornerRadius(8)
                                }
                               

                            }
                        }
                    }

                }
            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar{
//                ToolbarItem(placement: .principal){
//                    VStack{
//                        Text(title)
//                            .font(.system(size:40,weight: .bold))
//                            .foregroundColor(Color("Dark Blue "))
//                    }.frame(width: UIScreen.main.bounds.width, height: 60)
//                        .background(Color("Gray Blue "))
//                        .ignoresSafeArea()
//                }
//            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // To prevent double navigation bar in some cases
        .ignoresSafeArea()
    }
}


struct ConfirmChoiceView_Previews: PreviewProvider {
    static private var flight = Flight(id: UUID(), userId: "12345", airport: "EWR", date: "2023-08-02T12:34:56Z", foundMatch: false)
    static private var request = Request(id: UUID(), senderFlightId: UUID(), recieverFlightId: UUID(), recieverUserId: "98765", senderUserId: "12345", flightDate: "2023-08-16T12:34:56Z", pfp: "profile-images/2ch5NVLOfecaawnrjGjXnAVhHWy1-pfp.jpg", name: "John Doe", status: "Pending", airport: "JFK",notify: true
    )
    static var previews: some View {
        ConfirmChoiceView(title: "Delete flight", message: nil, flight: flight, request: nil, onConfirm: {}, onReject: {})

//        NavigationView {
//            Text("Some content before the sheet")
//                .sheet(isPresented: .constant(true)) {
//                    ConfirmChoiceView(title: "Delete flight", message: "Hello there", onConfirm: {}, onReject: {})
//                }
//        }
    }
}
