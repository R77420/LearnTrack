//
//  Session.swift
//  LearnTrackMobile
//
//  Created by Hiba iazza on 11/12/2025.
//

import Foundation
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
    
    // Helper method for sharing (SESS-06)
    var shareText: String {
        let priceText = prix != nil ? String(format: "%.2f €", prix!) : "Non spécifié"
        
        return """
            📚 **Session de formation**
            
            🏷️ Titre : \(titre)
            📅 Dates : du \(dateDebut) au \(dateFin)
            ⏰ Horaires : \(heureDebut ?? "N/A") – \(heureFin ?? "N/A")
            💻 Modalité : \(modalite ?? "N/A")
            📍 Lieu : \(lieu ?? "N/A")
            💶 Tarif client : \(priceText)
            """
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
