import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await APIService.shared.login(email: email, password: password)
            if response.success, let user = response.user {
                AuthService.shared.login(user: user)
            } else {
                errorMessage = response.message
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
