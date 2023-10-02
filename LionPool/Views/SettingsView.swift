//
//  SettingsView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/22/23.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var matchModel : MatchModel
    @EnvironmentObject var requestModel : RequestModel
    @EnvironmentObject var flightModel : FlightModel
    
    @State private var changedPfp: Bool = false
    @State private var camera: Bool = false // Add this state
    @State private var library: Bool = false // Add this state
    @State private var selected: Bool = false // Add this state
    @State private var isSheetPresented = false
    @State private var signOutSheet: Bool = false
    @State private var settingSheet: Bool = false
    @State private var frameHeight: CGFloat = UIScreen.main.bounds.height/5
    
    private func signOutAction() {
        matchModel.signOut()
        flightModel.signOut()
        requestModel.signOut()
        userModel.signOut()
    }
    
    var body: some View {
        NavigationView{
            VStack (alignment: .leading, spacing: 8){
                Text("Settings")
                    .font(.system(size: 20, weight: .bold))
                Divider()
                    .padding(.horizontal)
                NavigationLink(
                    destination: ChooseImageMedium(camera: $camera, library: $library, selected: $selected, showSheet: $isSheetPresented, changedPfp: $changedPfp),
                    label: {
                        HStack{
                            Text("Update picture")
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing)
                        }
                    })
                    .navigationBarBackButtonHidden(true)
                
                NavigationLink(
                    destination: ChoiceView(isPresented: $signOutSheet, firstAction: signOutAction, firstOption: "Sign out", secondOption: "Cancel", title: "Would you like to sign out"),
                    label: {
                        HStack{
                            Text("Log out")
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing)
                        }
                    })
                    .navigationBarBackButtonHidden(true)
                
            }.padding(.leading)
        }.accentColor(Color("DarkGray"))
            .frame(height: frameHeight)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
