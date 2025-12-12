import Foundation
import SwiftUI
import Combine

@MainActor
class SessionViewModel: ObservableObject {
    private let api = SessionsAPI()
    // NEW: API dependencies for pickers
    private let clientsAPI = ClientsAPI()
    private let formateursAPI = FormateursAPI()
    private let ecolesAPI = EcolesAPI()
    
    @Published var sessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // NEW: Data for form pickers
    @Published var clients: [Client] = []
    @Published var formateurs: [Formateur] = []
    @Published var ecoles: [Ecole] = []
    
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
    
    private func _fetchClients() async {
        do {
            self.clients = try await clientsAPI.getClients()
        } catch {
            print("Erreur: Impossible de charger les clients: \(error.localizedDescription)")
        }
    }
    
    private func _fetchFormateurs() async {
        do {
            self.formateurs = try await formateursAPI.getFormateurs()
        } catch {
            print("Erreur: Impossible de charger les formateurs: \(error.localizedDescription)")
        }
    }
    
    private func _fetchEcoles() async {
        do {
            self.ecoles = try await ecolesAPI.getEcoles()
        } catch {
            print("Erreur: Impossible de charger les écoles: \(error.localizedDescription)")
        }
    }
    
    // NEW: Fetch dependencies for the form
    func fetchDependencies() async {
        isLoading = true
        errorMessage = nil
        // Fetch dependencies in parallel
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self._fetchClients() }
            group.addTask { await self._fetchFormateurs() }
            group.addTask { await self._fetchEcoles() }
        }
        isLoading = false
    }

    // Fonctions privées pour le fetch des dépendances...

    // MODIFIÉ: createSession avec tous les paramètres SESS-02
    func createSession(
        titre: String, dateDebut: Date, dateFin: Date, statut: String, modalite: String, lieu: String, heureDebut: Date, heureFin: Date,
        clientId: Int?, ecoleId: Int?, formateurId: Int?, prix: Double?, tarifSousTraitant: Double?, fraisRembourser: Double?, refContrat: String?
    ) async {
        isLoading = true
        errorMessage = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let newSession = SessionCreate(
            titre: titre,
            description: nil,
            dateDebut: dateFormatter.string(from: dateDebut),
            dateFin: dateFormatter.string(from: dateFin),
            heureDebut: timeFormatter.string(from: heureDebut),
            heureFin: timeFormatter.string(from: heureFin),
            clientId: clientId,
            ecoleId: ecoleId,  
            formateurId: formateurId,
            nbParticipants: nil,
            statut: statut,
            prix: prix,
            notes: nil,
            modalite: modalite,
            lieu: lieu
        )
        
        do {
            _ = try await api.createSession(newSession)
            await fetchSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // NEW: Update Session (SESS-03)
    func updateSession(id: Int, updateData: SessionUpdate) async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await api.updateSession(id: id, updateData)
            await fetchSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // NEW: Delete Session (SESS-04)
    func deleteSession(id: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            try await api.deleteSession(id: id)
            sessions.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
