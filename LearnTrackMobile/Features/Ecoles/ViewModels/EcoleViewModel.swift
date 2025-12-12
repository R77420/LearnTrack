import Foundation
import SwiftUI
import Combine

@MainActor
class EcoleViewModel: ObservableObject {
    private let api = EcolesAPI()
    
    @Published var ecoles: [Ecole] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchEcoles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedEcoles = try await api.getEcoles()
            self.ecoles = fetchedEcoles
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createEcole(nom: String, adresse: String, ville: String, email: String) async {
        isLoading = true
        errorMessage = nil
        
        let newEcole = EcoleCreate(
            nom: nom,
            adresse: adresse.isEmpty ? nil : adresse,
            ville: ville.isEmpty ? nil : ville,
            codePostal: nil,
            telephone: nil,
            email: email.isEmpty ? nil : email,
            responsableNom: nil,
            capacite: nil,
            notes: nil
        )
        
        do {
            _ = try await api.createEcole(newEcole)
            await fetchEcoles()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
     // NEW: Update Ecole (ECO-06)
      func updateEcole(id: Int, updateData: EcoleUpdate) async {
            isLoading = true
            errorMessage = nil
            
            do {
                // L'appel API est maintenant simplifié et correct
                _ = try await api.updateEcole(id: id, updateData)
                await fetchEcoles()
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }

        // NEW: Delete Ecole (ECO-07)
        func deleteEcole(id: Int) async {
            isLoading = true
            errorMessage = nil
            
            do {
                try await api.deleteEcole(id: id)
                ecoles.removeAll { $0.id == id }
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
}
