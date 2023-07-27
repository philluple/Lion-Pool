//
//  FindingMatchLoading.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/26/23.
//

import SwiftUI

struct FindingMatchLoading: View {
    @State private var isLoading = false
    @State private var dots = ""
    @State private var showNextView = false

    private let maxDots = 3
    private let animationInterval = 0.5
    
    var body: some View {
        VStack(){
            Text("Finding matches")
                .font(.system(size: 45, weight: .bold))
                .foregroundColor(Color("Dark Blue "))
                .padding()
                .frame(width: UIScreen.main.bounds.width, height: 55)
                .background(Color("Gray Blue "))
            
            Spacer()
            
            Text("Matching in progress" + dots)
                .font(.system(size: 30, weight: .bold))
                .padding([.top, .bottom])
                .frame(width: UIScreen.main.bounds.width, height: 70)
                .onAppear {
                    startLoadingAnimation()
                }
            
            Spacer()
            
            NavigationLink(
                destination: HomeView(),
                isActive: $showNextView,
                label: { EmptyView() }
            )
        }
        .onAppear {
            // Start a timer to trigger the navigation after a few seconds (e.g., 3 seconds)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                showNextView = true
            }
        }
    }
    private func startLoadingAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { _ in
            isLoading.toggle()
            updateDots()
        }
        timer.fire()
    }
        
    private func updateDots() {
        if isLoading {
            if dots.count < maxDots {
                dots += "."
            } else {
                dots = ""
            }
        }
    }
}

struct FindingMatchLoading_Previews: PreviewProvider {
    static var previews: some View {
        FindingMatchLoading()
    }
}
