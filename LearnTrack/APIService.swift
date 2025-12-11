import Foundation

// MARK: - API Service

class APIService {
    static let shared = APIService()
    private let baseURL = "https://www.formateurs-numerique.com/api"

    private init() {}

    // MARK: - Generic Request

    private func request<T: Decodable>(_ endpoint: String, method: String = "GET", body: [String: Any]? = nil) async throws -> T {
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

    private func requestNoContent(_ endpoint: String, method: String, body: [String: Any]? = nil) async throws {
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

    // MARK: - Auth

    /// Connexion avec email et mot de passe
    func login(email: String, password: String) async throws -> AuthResponse {
        let body: [String: Any] = ["email": email, "password": password]
        return try await request("/auth/login", method: "POST", body: body)
    }

    /// Inscription d'un nouvel utilisateur
    func register(email: String, password: String, nom: String, prenom: String) async throws -> AuthResponse {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "nom": nom,
            "prenom": prenom
        ]
        return try await request("/auth/register", method: "POST", body: body)
    }
    
    /// Demande de réinitialisation de mot de passe
    func resetPassword(email: String) async throws {
        // Simulation of API Call since endpoint is not strictly defined in docs
        // In a real app: try await requestNoContent("/auth/reset-password", method: "POST", body: ["email": email])
        // For now, we simulate network delay and success
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }

    // MARK: - Clients

    func getClients() async throws -> [Client] {
        try await request("/clients")
    }

    func getClient(id: Int) async throws -> Client {
        try await request("/clients/\(id)")
    }

    func createClient(_ client: ClientCreate) async throws -> Client {
        let body = client.toDictionary()
        return try await request("/clients", method: "POST", body: body)
    }

    func updateClient(id: Int, _ client: ClientUpdate) async throws -> Client {
        let body = client.toDictionary()
        return try await request("/clients/\(id)", method: "PUT", body: body)
    }

    func deleteClient(id: Int) async throws {
        try await requestNoContent("/clients/\(id)", method: "DELETE")
    }

    func getClientSessions(clientId: Int) async throws -> [Session] {
        try await request("/clients/\(clientId)/sessions")
    }

    // MARK: - Ecoles

    func getEcoles() async throws -> [Ecole] {
        try await request("/ecoles")
    }

    func getEcole(id: Int) async throws -> Ecole {
        try await request("/ecoles/\(id)")
    }

    func createEcole(_ ecole: EcoleCreate) async throws -> Ecole {
        let body = ecole.toDictionary()
        return try await request("/ecoles", method: "POST", body: body)
    }

    func updateEcole(id: Int, _ ecole: EcoleUpdate) async throws -> Ecole {
        let body = ecole.toDictionary()
        return try await request("/ecoles/\(id)", method: "PUT", body: body)
    }

    func deleteEcole(id: Int) async throws {
        try await requestNoContent("/ecoles/\(id)", method: "DELETE")
    }

    func getEcoleSessions(ecoleId: Int) async throws -> [Session] {
        try await request("/ecoles/\(ecoleId)/sessions")
    }

    // MARK: - Formateurs

    func getFormateurs() async throws -> [Formateur] {
        try await request("/formateurs")
    }

    func getFormateur(id: Int) async throws -> Formateur {
        try await request("/formateurs/\(id)")
    }

    func createFormateur(_ formateur: FormateurCreate) async throws -> Formateur {
        let body = formateur.toDictionary()
        return try await request("/formateurs", method: "POST", body: body)
    }

    func updateFormateur(id: Int, _ formateur: FormateurUpdate) async throws -> Formateur {
        let body = formateur.toDictionary()
        return try await request("/formateurs/\(id)", method: "PUT", body: body)
    }

    func deleteFormateur(id: Int) async throws {
        try await requestNoContent("/formateurs/\(id)", method: "DELETE")
    }

    func getFormateurSessions(formateurId: Int) async throws -> [Session] {
        try await request("/formateurs/\(formateurId)/sessions")
    }

    // MARK: - Sessions

    func getSessions() async throws -> [Session] {
        try await request("/sessions")
    }

    func getSession(id: Int) async throws -> Session {
        try await request("/sessions/\(id)")
    }

    func createSession(_ session: SessionCreate) async throws -> Session {
        let body = session.toDictionary()
        return try await request("/sessions", method: "POST", body: body)
    }

    func updateSession(id: Int, _ session: SessionUpdate) async throws -> Session {
        let body = session.toDictionary()
        return try await request("/sessions/\(id)", method: "PUT", body: body)
    }

    func deleteSession(id: Int) async throws {
        try await requestNoContent("/sessions/\(id)", method: "DELETE")
    }

    // MARK: - Users

    func getUsers() async throws -> [User] {
        try await request("/users")
    }

    func getUser(id: Int) async throws -> User {
        try await request("/users/\(id)")
    }

    func createUser(_ user: UserCreate) async throws -> User {
        let body = user.toDictionary()
        return try await request("/users", method: "POST", body: body)
    }

    func updateUser(id: Int, _ user: UserUpdate) async throws -> User {
        let body = user.toDictionary()
        return try await request("/users/\(id)", method: "PUT", body: body)
    }

    func deleteUser(id: Int) async throws {
        try await requestNoContent("/users/\(id)", method: "DELETE")
    }
}

// MARK: - Errors

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noContent
    case badRequest
    case notFound
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalide"
        case .invalidResponse:
            return "Réponse invalide du serveur"
        case .noContent:
            return "Aucun contenu"
        case .badRequest:
            return "Requête invalide"
        case .notFound:
            return "Ressource non trouvée"
        case .serverError(let code):
            return "Erreur serveur (\(code))"
        }
    }
}

// MARK: - Health Models

struct HealthResponse: Codable {
    let status: String
}

struct DatabaseHealthResponse: Codable {
    let status: String
    let database: String
}

// MARK: - Auth Models

struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let user: User?
}

// MARK: - Client Models

struct Client: Codable, Identifiable {
    let id: Int
    let nom: String
    let email: String?
    let telephone: String?
    let adresse: String?
    let ville: String?
    let codePostal: String?
    let siret: String?
    let contactNom: String?
    let contactEmail: String?
    let contactTelephone: String?
    let notes: String?
    let tvaIntra: String?
    let actif: Bool

    enum CodingKeys: String, CodingKey {
        case id, nom, email, telephone, adresse, ville, siret, notes, actif
        case codePostal = "code_postal"
        case contactNom = "contact_nom"
        case contactEmail = "contact_email"
        case contactTelephone = "contact_telephone"
        case tvaIntra = "tva_intra"
    }
}

struct ClientCreate {
    var nom: String
    var email: String?
    var telephone: String?
    var adresse: String?
    var ville: String?
    var codePostal: String?
    var siret: String?
    var contactNom: String?
    var contactEmail: String?
    var contactTelephone: String?
    var notes: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["nom": nom]
        if let email = email { dict["email"] = email }
        if let telephone = telephone { dict["telephone"] = telephone }
        if let adresse = adresse { dict["adresse"] = adresse }
        if let ville = ville { dict["ville"] = ville }
        if let codePostal = codePostal { dict["code_postal"] = codePostal }
        if let siret = siret { dict["siret"] = siret }
        if let contactNom = contactNom { dict["contact_nom"] = contactNom }
        if let contactEmail = contactEmail { dict["contact_email"] = contactEmail }
        if let contactTelephone = contactTelephone { dict["contact_telephone"] = contactTelephone }
        if let notes = notes { dict["notes"] = notes }
        return dict
    }
}

struct ClientUpdate {
    var nom: String?
    var email: String?
    var telephone: String?
    var adresse: String?
    var ville: String?
    var codePostal: String?
    var siret: String?
    var contactNom: String?
    var contactEmail: String?
    var contactTelephone: String?
    var notes: String?
    var actif: Bool?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let nom = nom { dict["nom"] = nom }
        if let email = email { dict["email"] = email }
        if let telephone = telephone { dict["telephone"] = telephone }
        if let adresse = adresse { dict["adresse"] = adresse }
        if let ville = ville { dict["ville"] = ville }
        if let codePostal = codePostal { dict["code_postal"] = codePostal }
        if let siret = siret { dict["siret"] = siret }
        if let contactNom = contactNom { dict["contact_nom"] = contactNom }
        if let contactEmail = contactEmail { dict["contact_email"] = contactEmail }
        if let contactTelephone = contactTelephone { dict["contact_telephone"] = contactTelephone }
        if let notes = notes { dict["notes"] = notes }
        if let actif = actif { dict["actif"] = actif }
        return dict
    }
}

// MARK: - Ecole Models

struct Ecole: Codable, Identifiable {
    let id: Int
    let nom: String
    let adresse: String?
    let ville: String?
    let codePostal: String?
    let telephone: String?
    let email: String?
    let responsableNom: String?
    let capacite: Int?
    let notes: String?
    let actif: Bool

    enum CodingKeys: String, CodingKey {
        case id, nom, adresse, ville, telephone, email, capacite, notes, actif
        case codePostal = "code_postal"
        case responsableNom = "responsable_nom"
    }
}

struct EcoleCreate {
    var nom: String
    var adresse: String?
    var ville: String?
    var codePostal: String?
    var telephone: String?
    var email: String?
    var responsableNom: String?
    var capacite: Int?
    var notes: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["nom": nom]
        if let adresse = adresse { dict["adresse"] = adresse }
        if let ville = ville { dict["ville"] = ville }
        if let codePostal = codePostal { dict["code_postal"] = codePostal }
        if let telephone = telephone { dict["telephone"] = telephone }
        if let email = email { dict["email"] = email }
        if let responsableNom = responsableNom { dict["responsable_nom"] = responsableNom }
        if let capacite = capacite { dict["capacite"] = capacite }
        if let notes = notes { dict["notes"] = notes }
        return dict
    }
}

struct EcoleUpdate {
    var nom: String?
    var adresse: String?
    var ville: String?
    var codePostal: String?
    var telephone: String?
    var email: String?
    var responsableNom: String?
    var capacite: Int?
    var notes: String?
    var actif: Bool?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let nom = nom { dict["nom"] = nom }
        if let adresse = adresse { dict["adresse"] = adresse }
        if let ville = ville { dict["ville"] = ville }
        if let codePostal = codePostal { dict["code_postal"] = codePostal }
        if let telephone = telephone { dict["telephone"] = telephone }
        if let email = email { dict["email"] = email }
        if let responsableNom = responsableNom { dict["responsable_nom"] = responsableNom }
        if let capacite = capacite { dict["capacite"] = capacite }
        if let notes = notes { dict["notes"] = notes }
        if let actif = actif { dict["actif"] = actif }
        return dict
    }
}

// MARK: - Formateur Models

struct Formateur: Codable, Identifiable {
    let id: Int
    let nom: String
    let prenom: String
    let email: String
    let telephone: String?
    let specialites: [String]?
    let tarifJournalier: Double?
    let adresse: String?
    let ville: String?
    let codePostal: String?
    let notes: String?
    let actif: Bool
    let estInterne: Bool?
    let siret: String?
    let nda: String?

    enum CodingKeys: String, CodingKey {
        case id, nom, prenom, email, telephone, specialites, adresse, ville, notes, actif, siret, nda
        case tarifJournalier = "tarif_journalier"
        case codePostal = "code_postal"
        case estInterne = "est_interne"
    }
}

struct FormateurCreate {
    var nom: String
    var prenom: String
    var email: String
    var telephone: String?
    var specialites: [String]?
    var tarifJournalier: Double?
    var adresse: String?
    var ville: String?
    var codePostal: String?
    var notes: String?
    var estInterne: Bool?
    var siret: String?
    var nda: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["nom": nom, "prenom": prenom, "email": email]
        if let telephone = telephone { dict["telephone"] = telephone }
        if let specialites = specialites { dict["specialites"] = specialites }
        if let tarifJournalier = tarifJournalier { dict["tarif_journalier"] = tarifJournalier }
        if let adresse = adresse { dict["adresse"] = adresse }
        if let ville = ville { dict["ville"] = ville }
        if let codePostal = codePostal { dict["code_postal"] = codePostal }
        if let notes = notes { dict["notes"] = notes }
        if let estInterne = estInterne { dict["est_interne"] = estInterne }
        if let siret = siret { dict["siret"] = siret }
        if let nda = nda { dict["nda"] = nda }
        return dict
    }
}

struct FormateurUpdate {
    var nom: String?
    var prenom: String?
    var email: String?
    var telephone: String?
    var specialites: [String]?
    var tarifJournalier: Double?
    var adresse: String?
    var ville: String?
    var codePostal: String?
    var notes: String?
    var actif: Bool?
    var estInterne: Bool?
    var siret: String?
    var nda: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let nom = nom { dict["nom"] = nom }
        if let prenom = prenom { dict["prenom"] = prenom }
        if let email = email { dict["email"] = email }
        if let telephone = telephone { dict["telephone"] = telephone }
        if let specialites = specialites { dict["specialites"] = specialites }
        if let tarifJournalier = tarifJournalier { dict["tarif_journalier"] = tarifJournalier }
        if let adresse = adresse { dict["adresse"] = adresse }
        if let ville = ville { dict["ville"] = ville }
        if let codePostal = codePostal { dict["code_postal"] = codePostal }
        if let notes = notes { dict["notes"] = notes }
        if let actif = actif { dict["actif"] = actif }
        if let estInterne = estInterne { dict["est_interne"] = estInterne }
        if let siret = siret { dict["siret"] = siret }
        if let nda = nda { dict["nda"] = nda }
        return dict
    }
}

// MARK: - Session Models

struct Session: Codable, Identifiable {
    let id: Int
    let titre: String
    let description: String?
    let dateDebut: String
    let dateFin: String
    let heureDebut: String?
    let heureFin: String?
    let clientId: Int?
    let ecoleId: Int?
    let formateurId: Int?
    let nbParticipants: Int?
    let statut: String
    let prix: Double?
    let notes: String?
    let modalite: String?
    let lieu: String?

    enum CodingKeys: String, CodingKey {
        case id, titre, description, statut, prix, notes, modalite, lieu
        case dateDebut = "date_debut"
        case dateFin = "date_fin"
        case heureDebut = "heure_debut"
        case heureFin = "heure_fin"
        case clientId = "client_id"
        case ecoleId = "ecole_id"
        case formateurId = "formateur_id"
        case nbParticipants = "nb_participants"
    }
}

struct SessionCreate {
    var titre: String
    var description: String?
    var dateDebut: String  // Format: "YYYY-MM-DD"
    var dateFin: String
    var heureDebut: String?  // Format: "HH:MM:SS"
    var heureFin: String?
    var clientId: Int?
    var ecoleId: Int?
    var formateurId: Int?
    var nbParticipants: Int?
    var statut: String?
    var prix: Double?
    var notes: String?
    var modalite: String?
    var lieu: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "titre": titre,
            "date_debut": dateDebut,
            "date_fin": dateFin
        ]
        if let description = description { dict["description"] = description }
        if let heureDebut = heureDebut { dict["heure_debut"] = heureDebut }
        if let heureFin = heureFin { dict["heure_fin"] = heureFin }
        if let clientId = clientId { dict["client_id"] = clientId }
        if let ecoleId = ecoleId { dict["ecole_id"] = ecoleId }
        if let formateurId = formateurId { dict["formateur_id"] = formateurId }
        if let nbParticipants = nbParticipants { dict["nb_participants"] = nbParticipants }
        if let statut = statut { dict["statut"] = statut }
        if let prix = prix { dict["prix"] = prix }
        if let notes = notes { dict["notes"] = notes }
        if let modalite = modalite { dict["modalite"] = modalite }
        if let lieu = lieu { dict["lieu"] = lieu }
        return dict
    }
}

struct SessionUpdate {
    var titre: String?
    var description: String?
    var dateDebut: String?
    var dateFin: String?
    var heureDebut: String?
    var heureFin: String?
    var clientId: Int?
    var ecoleId: Int?
    var formateurId: Int?
    var nbParticipants: Int?
    var statut: String?
    var prix: Double?
    var notes: String?
    var modalite: String?
    var lieu: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let titre = titre { dict["titre"] = titre }
        if let description = description { dict["description"] = description }
        if let dateDebut = dateDebut { dict["date_debut"] = dateDebut }
        if let dateFin = dateFin { dict["date_fin"] = dateFin }
        if let heureDebut = heureDebut { dict["heure_debut"] = heureDebut }
        if let heureFin = heureFin { dict["heure_fin"] = heureFin }
        if let clientId = clientId { dict["client_id"] = clientId }
        if let ecoleId = ecoleId { dict["ecole_id"] = ecoleId }
        if let formateurId = formateurId { dict["formateur_id"] = formateurId }
        if let nbParticipants = nbParticipants { dict["nb_participants"] = nbParticipants }
        if let statut = statut { dict["statut"] = statut }
        if let prix = prix { dict["prix"] = prix }
        if let notes = notes { dict["notes"] = notes }
        if let modalite = modalite { dict["modalite"] = modalite }
        if let lieu = lieu { dict["lieu"] = lieu }
        return dict
    }
}

// MARK: - User Models

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let nom: String
    let prenom: String
    let role: String
    let actif: Bool
}

struct UserCreate {
    var email: String
    var passwordHash: String
    var nom: String
    var prenom: String
    var role: String?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "email": email,
            "password_hash": passwordHash,
            "nom": nom,
            "prenom": prenom
        ]
        if let role = role { dict["role"] = role }
        return dict
    }
}

struct UserUpdate {
    var email: String?
    var nom: String?
    var prenom: String?
    var role: String?
    var actif: Bool?

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let email = email { dict["email"] = email }
        if let nom = nom { dict["nom"] = nom }
        if let prenom = prenom { dict["prenom"] = prenom }
        if let role = role { dict["role"] = role }
        if let actif = actif { dict["actif"] = actif }
        return dict
    }
}
