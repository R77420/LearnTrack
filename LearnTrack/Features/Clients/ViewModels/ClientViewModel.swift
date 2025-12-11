import Foundation
import SwiftUI
import Combine

@MainActor
class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchClients() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedClients = try await APIService.shared.getClients()
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
            _ = try await APIService.shared.createClient(newClient)
            await fetchClients() // Refresh list
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
