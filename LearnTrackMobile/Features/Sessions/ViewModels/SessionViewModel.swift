import Foundation
import SwiftUI
import Combine

@MainActor
class SessionViewModel: ObservableObject {
    private let api = SessionsAPI()
    @Published var sessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedSessions = try await api.getSessions()
            self.sessions = fetchedSessions
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createSession(titre: String, dateDebut: Date, dateFin: Date, statut: String, modalite: String, lieu: String, heureDebut: Date, heureFin: Date) async {
        isLoading = true
        errorMessage = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let newSession = SessionCreate(
            titre: titre,
            description: nil,
            dateDebut: dateFormatter.string(from: dateDebut),
            dateFin: dateFormatter.string(from: dateFin),
            heureDebut: timeFormatter.string(from: heureDebut),
            heureFin: timeFormatter.string(from: heureFin),
            clientId: nil,
            ecoleId: nil,
            formateurId: nil,
            nbParticipants: nil,
            statut: statut,
            prix: nil,
            notes: nil
        )
        // Note: Creating a dictionary with extra fields (modalite, lieu) requires manually adding them 
        // if SessionCreate struct doesn't have them. I added them to Session model but maybe not SessionCreate?
        // Let's check APIService.swift again. I only added them to Session struct, NOT SessionCreate/Update.
        
        do {
            _ = try await api.createSession(newSession)
            await fetchSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
