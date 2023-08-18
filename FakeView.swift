//
//  FakeView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/17/23.
//

import SwiftUI

struct FakeView: View {
    @State private var isPresentView = false
    @State private var responseURL: URL? = nil
    
    var body: some View {
        Button("Open WebView"){
            isPresentView.toggle()
        }
        .sheet(isPresented: $isPresentView){
            NavigationView{
                InstagramWebView()
                    .ignoresSafeArea()
                    .onReceive(responseURL.publisher){ recievedURL in
                        print("Received URL: \(recievedURL)")
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct FakeView_Previews: PreviewProvider {
    static var previews: some View {
        FakeView()
    }
}
