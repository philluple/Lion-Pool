//
//  ToolbarView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/20/23.
//

import SwiftUI

struct ToolbarView: View {
    var body: some View {
        NavigationView{
            ZStack {
                Color.green.ignoresSafeArea()
                
                NavigationLink(
                    destination:
                        Text("Destination")
                        .navigationTitle("Title 2")
                        .navigationBarBackButtonHidden(false)
                    ,
                    label: {
                        Text ("Navigate")
                    })

            }
            .navigationTitle("Nav Title here")
        }
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
    }
}
