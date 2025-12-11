//
//  HealthModels.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

struct HealthResponse: Codable {
    let status: String
}

struct DatabaseHealthResponse: Codable {
    let status: String
    let database: String
}
