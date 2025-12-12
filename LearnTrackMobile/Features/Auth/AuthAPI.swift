//
//  AuthAPI.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

import Foundation

class AuthAPI {
    private let api = APIService.shared
    
    /// Connexion avec email et mot de passe
    func login(email: String, password: String) async throws -> AuthResponse {
        let body: [String: Any] = ["email": email, "password": password]
        return try await api.request("/auth/login", method: "POST", body: body)
    }

    /// Inscription d'un nouvel utilisateur
    func register(email: String, password: String, nom: String, prenom: String) async throws -> AuthResponse {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "nom": nom,
            "prenom": prenom
        ]
        return try await api.request("/auth/register", method: "POST", body: body)
    }
    
    /// Demande de réinitialisation de mot de passe
    func resetPassword(email: String) async throws {
        // REVERTED to Simulation: The backend endpoint "/auth/reset-password" returns 404 (Not Found).
        // The user confirmed this. Until the backend implements this endpoint, we simulate success.
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
}
