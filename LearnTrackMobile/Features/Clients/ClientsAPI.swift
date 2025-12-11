//
//  ClientsAPI.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

import Foundation

class ClientsAPI {
    private let api = APIService.shared
    
    func getClients() async throws -> [Client] {
        try await api.request("/clients")
    }

    func getClient(id: Int) async throws -> Client {
        try await api.request("/clients/\(id)")
    }

    func createClient(_ client: ClientCreate) async throws -> Client {
        let body = client.toDictionary()
        return try await api.request("/clients", method: "POST", body: body)
    }

    func updateClient(id: Int, _ client: ClientUpdate) async throws -> Client {
        let body = client.toDictionary()
        return try await api.request("/clients/\(id)", method: "PUT", body: body)
    }

    func deleteClient(id: Int) async throws {
        try await api.requestNoContent("/clients/\(id)", method: "DELETE")
    }

    func getClientSessions(clientId: Int) async throws -> [Session] {
        try await api.request("/clients/\(clientId)/sessions")
    }
}
