//
//  SwiftUIView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/14/23.
//

import SwiftUI

struct Launch: View {
    @State var scale = 1.0

    var body: some View {
        Color("Dark Blue ")
            .ignoresSafeArea()
            .overlay{
                Logo(fontColor: "White", fontSize: 80)
                    .scaleEffect(scale)
                            .animation(Animation.easeInOut(duration: 1), value: scale)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                                    scale = 100.0
                                }
                            }
            }
    }
}

struct Launch_Previews: PreviewProvider {
    static var previews: some View {
        Launch()
    }
}
