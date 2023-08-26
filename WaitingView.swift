//
//  WaitingView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/25/23.
//

import SwiftUI

struct WaitingView: View {
    @EnvironmentObject var userModel: UserModel
    var body: some View {
        
        ZStack {
            withAnimation(.easeInOut(duration: 0.5)) {
                Color("Gray Blue ")
                    .ignoresSafeArea()
            }
            VStack {
                Logo(fontColor: "Dark Blue ", fontSize: 60)
                    .padding(.bottom, UIScreen.main.bounds.height/6)
                withAnimation(.easeInOut(duration: 0.5)) {
                    Group{
                        Text("Almost done!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.white)
                        Group{
                            if let email = UserDefaults.standard.string(forKey: "email"){
                                Text("A verification email has been sent to \(email)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .accentColor(Color.white)
                                    .padding(.vertical)
                            }else{
                                Text("A verification email has been sent to your email")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .accentColor(Color.white)
                                    .padding(.vertical)
                            }
                        }
                        Text("Please check your email and follow the link to activate your account (literally 2 seconds)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .accentColor(Color.white)
                        Button {
                            userModel.resendVerification()
                        } label: {
                            HStack(spacing: 3){
                                Text("Didn't see an email?")
                                    .fontWeight(.semibold)
                                    .accentColor(Color("Dark Blue "))
                                Text("Resend link.")
                                    .fontWeight(.bold)
                                    .accentColor(Color.white)
                            }
                            .font(.system(size:16,weight: .bold))
                        }

                        Spacer()
                    }
                }
            }
        }
    }
}


struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
            .environmentObject(UserModel())
    }
}
