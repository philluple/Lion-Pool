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
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var flightModel: FlightViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                //let user = viewModel.currentUser
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
