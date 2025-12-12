import Foundation
import SwiftUI
import Combine

@MainActor
class ClientViewModel: ObservableObject {
    private let api = ClientsAPI()
    
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchClients() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedClients = try await api.getClients()
            self.clients = fetchedClients
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createClient(nom: String, email: String, telephone: String, ville: String) async {
        isLoading = true
        errorMessage = nil
        
        let newClient = ClientCreate(
            nom: nom,
            email: email.isEmpty ? nil : email,
            telephone: telephone.isEmpty ? nil : telephone,
            adresse: nil,
            ville: ville.isEmpty ? nil : ville,
            codePostal: nil,
            siret: nil,
            contactNom: nil,
            contactEmail: nil,
            contactTelephone: nil,
            notes: nil
        )
        
        do {
            _ = try await api.createClient(newClient)
            await fetchClients() // Refresh list
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    // NEW: Update Client (CLI-06)
    func updateClient(id: Int, updateData: ClientUpdate) async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await api.updateClient(id: id, updateData)
            await fetchClients()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // NEW: Delete Client (CLI-07)
    func deleteClient(id: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            try await api.deleteClient(id: id)
            clients.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
