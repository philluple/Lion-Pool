//
//  RequestListView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/29/23.
//

import SwiftUI

struct RequestListView: View {
    @EnvironmentObject var networkModel: NetworkModel
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Matches")
                    .font(.system(size:22,weight: .medium))
                    .padding(.leading, 15)
//                    .padding(.top, 10)
                Spacer()
            }.padding(.top,20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(){
                    ForEach(networkModel.requests) { request in
                        RequestView(request: request)
                        Divider()
                            .padding(.bottom)
                    }
                }
            }
            
        }.frame(width:UIScreen.main.bounds.width-20,height: networkModel.requests.count == 0 ? 50 : 250)
            .background(Color.white)
            .cornerRadius(10)
        }
    }

struct RequestListView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListView()
    }
}
