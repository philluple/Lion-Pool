import SwiftUI
import Firebase
import FirebaseCore

@main
struct Lion_PoolApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserModel())
                .environmentObject(RequestModel())
                .environmentObject(MatchModel())
                .environmentObject(FlightModel())
        }
    }
    
}

