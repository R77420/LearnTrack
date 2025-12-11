import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var resetMessage: String?
    
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
                errorMessage = "Email ou mots de passe incorrecte"
            }
        } catch {
            errorMessage = "Email ou mots de passe incorrecte"
        }
        
        isLoading = false
    }
    
    func resetPassword(for email: String) async {
        guard !email.isEmpty else {
            errorMessage = "Veuillez entrer une adresse email"
            return
        }
        
        isLoading = true
        errorMessage = nil
        resetMessage = nil
        
        do {
            try await APIService.shared.resetPassword(email: email)
            resetMessage = "Un email de réinitialisation a été envoyé à \(email)"
        } catch {
            errorMessage = "Impossible d'envoyer l'email: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
