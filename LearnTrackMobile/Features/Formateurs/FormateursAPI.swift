//
//  FormateursAPI.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

import Foundation

class FormateursAPI {
    private let api = APIService.shared
    
    func getFormateurs() async throws -> [Formateur] {
        try await api.request("/formateurs")
    }

    func getFormateur(id: Int) async throws -> Formateur {
        try await api.request("/formateurs/\(id)")
    }

    func createFormateur(_ formateur: FormateurCreate) async throws -> Formateur {
        let body = formateur.toDictionary()
        return try await api.request("/formateurs", method: "POST", body: body)
    }

    func updateFormateur(id: Int, _ formateur: FormateurUpdate) async throws -> Formateur {
        let body = formateur.toDictionary()
        return try await api.request("/formateurs/\(id)", method: "PUT", body: body)
    }

    func deleteFormateur(id: Int) async throws {
        try await api.requestNoContent("/formateurs/\(id)", method: "DELETE")
    }

    func getFormateurSessions(formateurId: Int) async throws -> [Session] {
        try await api.request("/formateurs/\(formateurId)/sessions")
    }
}
