//
//  AppNavBarView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/20/23.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack{
                Color.orange.ignoresSafeArea()
                
                CustomNavLink(
                    destination: Text("Destination"),
                    label: {Text("Here")}
                ).customNavigationTitle("Add departure")
                    .customNavigationSize(35)
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
    private var defaultNavView: some View {
        NavigationView {
            ZStack{
                Color.green.ignoresSafeArea()
                
                NavigationLink(
                    destination:
                        Text("Destination")
                        .navigationTitle("Title 2")
                        .navigationBarBackButtonHidden(false)
                    ,
                    label: {
                        Text("Navigate")
                    })
            }
            .navigationTitle(("Nav Title here"))
            }
        }
}

