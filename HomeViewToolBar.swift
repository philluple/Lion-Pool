//
//  HomeViewToolBar.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/22/23.
//

import SwiftUI

struct HomeViewToolBar: View {
    let user = User(id: "1234", firstname: "Phillip", lastname: "Le", email: "blahblah", UNI: "PNL2111", phone: "3108487944", pfpLocation: "https://firebasestorage.googleapis.com:443/v0/b/lion-pool-f5755.appspot.com/o/profile-images%2FUquVCHmxrCOy7COrm3LxAbda8Ik2-pfp.jpg?alt=media&token=00ba2fe7-c3ae-4bfc-ac61-74adc49c3ca1")
    var body: some View {
        VStack{
                HStack{
                    Text("LionPool")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(Color("Dark Blue "))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading],UIScreen.main.bounds.width/25)
                        //.padding([.bottom, .top, .leading],10)
                    
                    CustomNavLink(destination: ProfileView().customNavigationTitle("Hey, \(user.firstname)").customNavigationSize(35)){
                        Image(systemName:"person.fill")
                            .resizable()
                            .frame(width:30, height:30)
                            .foregroundColor(Color("Dark Blue "))
                            //.padding([.trailing],UIScreen.main.bounds.width/25)
                    }
                    
                    
                }.padding([.trailing, .leading])
            Color.green.ignoresSafeArea()
            }
        
    }
}

struct HomeViewToolBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewToolBar()
    }
}
