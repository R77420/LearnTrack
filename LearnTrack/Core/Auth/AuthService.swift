import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    private init() {}
    
    @MainActor
    func login(user: User) {
        self.currentUser = user
        self.isAuthenticated = true
    }
    
    @MainActor
    func logout() {
        self.currentUser = nil
        self.isAuthenticated = false
    }
}
