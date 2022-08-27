//
//  AddFlightView.swift
//  Lion Pool
//
//  Created by Phillip Le on 6/13/22.
//

import SwiftUI

struct AddFlightView: View {
    @State private var bags = 0
    @State private var departAirport = ""
    
    var body: some View {
        
        VStack{
            AddFlightHeader
            //Spacer()
            HStack{
            
                Text("Departure Details")
                    .font(.system(size:22,weight: .semibold))
                    .padding([.top, .leading])
                
                Image(systemName: "airplane")
                    .padding(.top)
                
            }
            
            HStack(spacing: 10){
                Spacer()
                DatePicker(selection: .constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date and time:").font(.system(size:18,weight: .semibold)) })
                    .padding(.horizontal)
                    .datePickerStyle(.graphical)
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            ZStack{
                TextField("", text: $departAirport)
                    .padding(.all)
                    .frame(width: UIScreen.screenWidth-50, height:50)
                    .background(RoundedRectangle(cornerRadius:10).fill(Color("TextBox")))
                    .multilineTextAlignment(.trailing)
                HStack{
                    Spacer()
                        .frame(width:40)
                    Text("Airport")
                        .font(.system(size:18,weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                

            }
            
          

                    
            
            
            
            
        }
        
    }
}

extension AddFlightView{
    private var AddFlightHeader: some View{
        HStack{
            Spacer()
            Text("Add a flight")
                .font(.system(size:45,weight: .bold))
                .foregroundColor(Color("Dark Blue "))
            Spacer()
        }.padding()
            .accentColor(Color.white)
            .foregroundColor(Color("Dark Blue "))
            .background(Color("Gray Blue ").ignoresSafeArea(edges:.top))
    }
    
}

struct AddFlightView_Previews: PreviewProvider {
    static var previews: some View {
        AddFlightView()
            .accentColor(Color.red)
    }
}
