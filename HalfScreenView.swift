//
//  HalfScreenView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/21/23.
//

import SwiftUI

struct HalfScreenView: View {
    @Binding var isPresented: Bool
    var body: some View {
        ZStack(){
            Color("Text Box")
            VStack{
                Text("Sample")
            }
        }.frame(height: UIScreen.main.bounds.height/3)
        
    }
}

struct HalfScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let binding = Binding.constant(false)
        return HalfScreenView(isPresented: binding)
    }
}
