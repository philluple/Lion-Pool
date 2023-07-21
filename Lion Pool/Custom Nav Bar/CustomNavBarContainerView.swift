//
//  CustomNavBarContainerView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/20/23.
//

import SwiftUI

struct CustomNavBarContainerView<Content: View>: View {
    let content: Content
    @State private var title: String = ""
    @State private var fontSize: CGFloat = 35
    @State private var showBackButton: Bool = true
    
    init(@ViewBuilder content: () -> Content){
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0){
            CustomNavBarView(title: title, fontSize: fontSize, showBackButton: showBackButton)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.onPreferenceChange(CustomNavBarTitlePreferenceKey.self,
            perform: { value in self.title = value
        })
        .onPreferenceChange(CustomNavBarTitleFontSize.self,
            perform: {value in self.fontSize = value
        })
        .onPreferenceChange(CustomNavBarBackButtonHidden.self,
                            perform: { value in self.showBackButton = !value})
        
    }
}

struct CustomNavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarContainerView{
            ZStack{
                Color("Dark Blue ").ignoresSafeArea()
                
                Text("Hello Wo")
            }
        }
    }
}
