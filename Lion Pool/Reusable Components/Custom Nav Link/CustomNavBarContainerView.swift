//
//  CustomNavBarContainerView.swift
//  LionPool
//
//  Created by Phillip Le on 6/10/22.
//

import SwiftUI

struct CustomNavBarContainerView<Content: View>: View{
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content){
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0){
            CustomLionBar()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct CustomNavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarContainerView{
            ZStack {
                Color.green.ignoresSafeArea()
                
                Text("Hello world")
                    .foregroundColor(.white)
            }
        }
    }
}

