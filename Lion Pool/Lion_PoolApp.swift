import SwiftUI
import Firebase

@main
struct Lion_PoolApp: App {
  // register app delegate for Firebase setup
    @StateObject var viewModel = AuthViewModel()
    
    init (){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

