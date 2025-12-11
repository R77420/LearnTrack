import Foundation
// MARK: - API Service

class APIService {
    static let shared = APIService()
    private let baseURL = "https://www.formateurs-numerique.com/api"

    private init() {}

    // MARK: - Generic Request
    func request<T: Decodable>(_ endpoint: String, method: String = "GET", body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200, 201:
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        case 204:
            throw APIError.noContent
        case 400:
            throw APIError.badRequest
        case 404:
            throw APIError.notFound
        default:
            throw APIError.serverError(httpResponse.statusCode)
        }
    }

    func requestNoContent(_ endpoint: String, method: String, body: [String: Any]? = nil) async throws {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 204 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
    }
    
    // MARK: - Health
    func checkHealth() async throws -> HealthResponse {
        try await request("/health")
    }

    func checkDatabaseHealth() async throws -> DatabaseHealthResponse {
        try await request("/health/db")
    }
}
