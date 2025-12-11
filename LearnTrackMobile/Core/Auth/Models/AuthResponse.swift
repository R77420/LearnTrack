//
//  AuthResponse.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let user: User?
}
