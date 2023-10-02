//
//  CustomNavView.swift
//  LionPool
//
//  Created by Phillip Le on 6/10/22.
//

import SwiftUI

struct CustomNavView<Content:View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content){
        self.content = content()
    }
    var body: some View {
        NavigationView{
            CustomNavBarContainerView{
                content            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CustomNavView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView{
            Color.red.ignoresSafeArea()
        }
    }
}

