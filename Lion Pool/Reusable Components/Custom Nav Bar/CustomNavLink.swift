//
//  CustomNavLink.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/20/23.
//

import SwiftUI
struct CustomNavLink<Label: View, Destination: View>: View {
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label){
        self.destination = destination
        self.label = label()
    }

    var body: some View {
        NavigationLink(
            destination:
                CustomNavBarContainerView(content: {destination}).navigationBarBackButtonHidden(),
            label:{
                label
            }
        )
    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView{
            CustomNavLink (
                destination: Text("Destination")) {
                Text("Click me")
                }.customNavigationTitle("")
        }
    }
}
