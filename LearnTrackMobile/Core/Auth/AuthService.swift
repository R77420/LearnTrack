import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    private let userKey = "auth_user" // Clé du Keychain
    
    private init() {
        loadSession() // Charge la session au démarrage
    }
    
    @MainActor
    func login(user: User) {
        self.currentUser = user
        self.isAuthenticated = true
        saveSession(user: user) // Sauvegarde dans le Keychain
    }
    
    @MainActor
    func logout() {
        self.currentUser = nil
        self.isAuthenticated = false
        deleteSession() //  Supprime du Keychain
    }
    
    //  RBAC Helper (SEC-05)
    var isAdmin: Bool {
        // Le rôle 'admin' donne accès aux fonctions sensibles
        return currentUser?.role.lowercased() == "admin"
    }

    // Session Persistence Methods (Inspiré du projet conforme)
    private func saveSession(user: User) {
        do {
            // Encode l'objet User en Data pour le stockage sécurisé
            let userData = try JSONEncoder().encode(user)
            _ = KeychainManager.shared.save(key: userKey, data: userData)
        } catch {
            print("Erreur: Échec de l'encodage de l'utilisateur pour le Keychain: \(error)")
        }
    }
    
    private func loadSession() {
        if let userData = KeychainManager.shared.load(key: userKey) {
            do {
                // Décode les données du Keychain pour rétablir la session
                let user = try JSONDecoder().decode(User.self, from: userData)
                self.currentUser = user
                self.isAuthenticated = true
            } catch {
                print("Erreur: Échec du décodage de l'utilisateur depuis le Keychain: \(error)")
                deleteSession()
            }
        }
    }
    
    private func deleteSession() {
        KeychainManager.shared.delete(key: userKey)
    }
}
