import Foundation

struct HealthResponse: Codable {
    let status: String
}

struct DatabaseHealthResponse: Codable {
    let status: String
    let database: String
}
