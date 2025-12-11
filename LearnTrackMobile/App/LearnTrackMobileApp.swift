import SwiftUI

@main
struct LearnTrackMobileApp: App {
    @StateObject private var authManager = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
