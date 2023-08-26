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
    @EnvironmentObject var matchModel: MatchModel
    @EnvironmentObject var requestModel: RequestModel
    @EnvironmentObject var flightModel: FlightModel

    
    var body: some View {
//        FakeView()
        Group {
            if userModel.userSession != nil {
                HomeView()
            } else{
                LoginView()
            }
//            if userModel.userSession != nil {
//                if userModel.verificationStatus == .verified{
//                    HomeView()
//                } else{
//                    WaitingView()
//                }
//            } else {
//                LoginView()
//            }
        }
        .onAppear {
            userModel.checkUserSession()
        }
    }
}
