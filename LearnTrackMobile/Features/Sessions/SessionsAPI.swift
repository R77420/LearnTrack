//
//  SessionsAPI.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

import Foundation

class SessionsAPI {
    private let api = APIService.shared
    
    func getSessions() async throws -> [Session] {
        try await api.request("/sessions")
    }

    func getSession(id: Int) async throws -> Session {
        try await api.request("/sessions/\(id)")
    }

    func createSession(_ session: SessionCreate) async throws -> Session {
        let body = session.toDictionary()
        return try await api.request("/sessions", method: "POST", body: body)
    }

    func updateSession(id: Int, _ session: SessionUpdate) async throws -> Session {
        let body = session.toDictionary()
        return try await api.request("/sessions/\(id)", method: "PUT", body: body)
    }

    func deleteSession(id: Int) async throws {
        try await api.requestNoContent("/sessions/\(id)", method: "DELETE")
    }
    
}
