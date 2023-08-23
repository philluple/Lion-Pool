import SwiftUI
import Firebase
import FirebaseCore
import PartialSheet

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
                .attachPartialSheetToRoot()
                .onOpenURL { url in
                    if url.scheme == "https" && url.host == "lion-pool.com"{
                        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                              let path = components.path else {
                            return
                        }
                                            
                        if path == "/your-specific-path" {
                            // Handle the response for the specific path
                            // You can use environment variables or view models to handle the response within your app
                        }
                    }
                }
        }
    }
    
}

