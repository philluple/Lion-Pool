import SwiftUI
import Firebase

@main
struct Lion_PoolApp: App {
  // register ap delegate for Firebase setup
    @StateObject var viewModel = AuthViewModel()
    
    init (){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
//            RegistrationView()
//                .environmentObject(viewModel)
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

