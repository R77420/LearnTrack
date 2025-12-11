//
//  UsersAPI.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

class UsersAPI {
    private let api = APIService.shared
    
    func getUsers() async throws -> [User] {
        try await api.request("/users")
    }

    func getUser(id: Int) async throws -> User {
        try await api.request("/users/\(id)")
    }

    func createUser(_ user: UserCreate) async throws -> User {
        let body = user.toDictionary()
        return try await api.request("/users", method: "POST", body: body)
    }

    func updateUser(id: Int, _ user: UserUpdate) async throws -> User {
        let body = user.toDictionary()
        return try await api.request("/users/\(id)", method: "PUT", body: body)
    }

    func deleteUser(id: Int) async throws {
        try await api.requestNoContent("/users/\(id)", method: "DELETE")
    }
}
