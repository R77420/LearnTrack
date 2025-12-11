//
//  EcolesAPI.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

import Foundation

class EcolesAPI {
    private let api = APIService.shared
    
    func getEcoles() async throws -> [Ecole] {
        try await api.request("/ecoles")
    }

    func getEcole(id: Int) async throws -> Ecole {
        try await api.request("/ecoles/\(id)")
    }

    func createEcole(_ ecole: EcoleCreate) async throws -> Ecole {
        let body = ecole.toDictionary()
        return try await api.request("/ecoles", method: "POST", body: body)
    }

    func updateEcole(id: Int, _ ecole: EcoleUpdate) async throws -> Ecole {
        let body = ecole.toDictionary()
        return try await api.request("/ecoles/\(id)", method: "PUT", body: body)
    }

    func deleteEcole(id: Int) async throws {
        try await api.requestNoContent("/ecoles/\(id)", method: "DELETE")
    }

    func getEcoleSessions(ecoleId: Int) async throws -> [Session] {
        try await api.request("/ecoles/\(ecoleId)/sessions")
    }
    
}
