//
//  SessionTests.swift
//  LearnTrackMobileTests
//
//  Created by LearnTrack on 12/12/2025.
//

import XCTest
@testable import LearnTrackMobile

final class SessionTests: XCTestCase {

    func testSessionCreateToDictionary() {
        // Given
        let sessionCreate = SessionCreate(
            titre: "Formation Swift",
            description: "Introduction au langage",
            dateDebut: "2025-01-01",
            dateFin: "2025-01-05",
            heureDebut: "09:00:00",
            heureFin: "17:00:00",
            clientId: 123,
            ecoleId: 456,
            formateurId: 789,
            nbParticipants: 10,
            statut: "confirme",
            prix: 2500.0,
            notes: "Aucune",
            modalite: "P",
            lieu: "Paris"
        )
        
        // When
        let dict = sessionCreate.toDictionary()
        
        // Then
        XCTAssertEqual(dict["titre"] as? String, "Formation Swift")
        XCTAssertEqual(dict["date_debut"] as? String, "2025-01-01")
        XCTAssertEqual(dict["client_id"] as? Int, 123)
        XCTAssertEqual(dict["prix"] as? Double, 2500.0)
        XCTAssertEqual(dict["modalite"] as? String, "P")
    }
    
    func testSessionUpdateToDictionaryOnlyIncludesChanges() {
        // Given
        let sessionUpdate = SessionUpdate(
            titre: "Nouveau Titre",
            statut: "annule"
        )
        
        // When
        let dict = sessionUpdate.toDictionary()
        
        // Then
        XCTAssertEqual(dict.count, 2)
        XCTAssertEqual(dict["titre"] as? String, "Nouveau Titre")
        XCTAssertEqual(dict["statut"] as? String, "annule")
        XCTAssertNil(dict["description"])
    }
}
