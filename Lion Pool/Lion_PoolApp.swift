import SwiftUI
import Firebase
import FirebaseCore
import PartialSheet

@main
struct Lion_PoolApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    let instagramModel = InstagramAPI()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserModel())
                .environmentObject(RequestModel())
                .environmentObject(MatchModel())
                .environmentObject(FlightModel())
                .environmentObject(instagramModel)
                .attachPartialSheetToRoot()
                .onOpenURL { url in
//                    print(url)
                    instagramModel.getAuthToken(from: url)
                }
        }
    }
    
}

