import SwiftUI
import Firebase
import FirebaseCore


@main
struct Lion_PoolApp: App {
  // register ap delegate for Firebase setup
    @StateObject var viewModel = AuthViewModel()
    @StateObject var flightModel = FlightViewModel()
    
    init (){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(flightModel)
        }
    }
}

