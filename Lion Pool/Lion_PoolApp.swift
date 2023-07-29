import SwiftUI
import Firebase
import FirebaseCore


@main
struct Lion_PoolApp: App {

    @StateObject var userModel = UserModel()
    @StateObject var networkModel = NetworkModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userModel)
                .environmentObject(networkModel)

        }
    }
}

