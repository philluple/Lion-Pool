//
//  ConfirmSignOut.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/22/23.
//

import SwiftUI
import PartialSheet


struct ChoiceView: View {
    @Binding var isPresented: Bool
    var firstAction: () -> Void
    var secondAction: (() -> Void)?
    
    @State var firstOption: String
    @State var secondOption: String
    @State var title: String
    @State var firstImage: String?
    @State var secondImage: String?
    
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var matchModel: MatchModel
    @EnvironmentObject var requestModel: RequestModel
    @EnvironmentObject var flightModel: FlightModel
    
    
    var body: some View {
            VStack(alignment: .leading){
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                Button{
                    firstAction()
                    isPresented.toggle()
                } label:{
                    if let firstImage = firstImage{
                        HStack{
                            Image(systemName: firstImage)
                            Text(firstOption)
                                .font(.system(size:16,weight: .bold))
                        }
                    }else{
                        Text(firstOption)
                            .font(.system(size:16,weight: .bold))
                    }
                    
                }.padding(.top, 2)
                Divider()
                    .padding(.horizontal, 20)
                Button{
                    if let secondAction = secondAction{
                        secondAction()
                    }
                    isPresented.toggle()
                } label:{
                    if let secondImage = secondImage{
                        HStack{
                            Image(systemName: secondImage)
                            Text(secondOption)
                                .font(.system(size:16,weight: .bold))
                        }
                    }else{
                        Text(secondOption)
                            .font(.system(size:16,weight: .bold))
                    }
                }
                
            }
            .padding(.leading)
            .accentColor(Color("DarkGray"))
    }
}

func doNothing(){
    
}

struct ConfirmSignOut_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceView(isPresented: .constant(true), firstAction: doNothing, firstOption: "Sign Out", secondOption: "Cancel", title: "Would you like to cancel")
    }
}
