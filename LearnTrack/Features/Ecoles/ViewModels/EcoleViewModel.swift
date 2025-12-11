import Foundation
import SwiftUI
import Combine

@MainActor
class EcoleViewModel: ObservableObject {
    @Published var ecoles: [Ecole] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchEcoles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedEcoles = try await APIService.shared.getEcoles()
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
            _ = try await APIService.shared.createEcole(newEcole)
            await fetchEcoles()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
