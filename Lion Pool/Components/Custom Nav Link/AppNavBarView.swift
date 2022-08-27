//
//  AppNavBarView.swift
//  LionPool
//
//  Created by Phillip Le on 6/10/22.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView{
            ZStack{
                Color.orange.ignoresSafeArea()
                
                CustomNavLink(destination: Text("Destination")) {
                    Text("Navigate")
                }
            }
        }
    }
}


struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}

extension AppNavBarView {
    private var defaultNavView: some View{
        NavigationView{
            ZStack{
                Color.green.ignoresSafeArea()
                
                NavigationLink(
                    destination:
                        Text("Destination")
                        .navigationTitle("title 2")
                        .navigationBarBackButtonHidden(false)
                    ,
                label: {
                    Text ("Navigate")
                })
            }
        }
    }
}

