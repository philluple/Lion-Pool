//
//  SwiftUIView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var networkModel: NetworkModel
    
    var body: some View {
        Group {
            if userModel.userSession != nil {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}
