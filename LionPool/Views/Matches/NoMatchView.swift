//
//  NoMatchView.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/27/23.
//

import SwiftUI

struct NoMatchView: View {
    @State var goHome: Bool = false

    var body: some View {
        Button {
            goHome.toggle()
        } label: {
            VStack(alignment: .center){
                Spacer()
                Text("Sorry, we couldn't find you a match")
                    .font(.system(size:35,weight: .semibold))
                    .foregroundColor(Color("Dark Blue "))
                    .multilineTextAlignment(.center)
                Text("Check back closer to your flight :)")
                    .font(.system(size:20))
                    .foregroundColor(Color("Dark Blue "))
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Gray Blue "))
            .ignoresSafeArea()
        }
        .onAppear{
            startTimer()
        }
        .fullScreenCover(isPresented: $goHome) {
            HomeView()
        }
    }
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            goHome = true
        }
    }
}

struct NoMatchView_Previews: PreviewProvider {
    static var previews: some View {
        NoMatchView()
    }
}
