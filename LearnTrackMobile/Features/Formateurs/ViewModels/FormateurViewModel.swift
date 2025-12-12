import Foundation
import SwiftUI
import Combine

@MainActor
class FormateurViewModel: ObservableObject {
    private let api = FormateursAPI()
    @Published var formateurs: [Formateur] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchFormateurs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedFormateurs = try await api.getFormateurs()
            self.formateurs = fetchedFormateurs
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createFormateur(
        nom: String,
        prenom: String,
        email: String,
        telephone: String?,
        specialites: [String]?,
        tarifJournalier: Double?,
        estInterne: Bool,
        siret: String?,
        nda: String?,
        adresse: String?,
        ville: String?,
        codePostal: String?
    ) async {
        isLoading = true
        errorMessage = nil
        
        let newFormateur = FormateurCreate(
            nom: nom,
            prenom: prenom,
            email: email,
            telephone: telephone,
            specialites: specialites,
            tarifJournalier: tarifJournalier,
            adresse: adresse,
            ville: ville,
            codePostal: codePostal,
            notes: nil,
            estInterne: estInterne,
            siret: siret,
            nda: nda
        )
        
        do {
            _ = try await api.createFormateur(newFormateur)
            await fetchFormateurs()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // NEW: Update Formateur (FORM-07)
    func updateFormateur(id: Int, updateData: FormateurUpdate) async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await api.updateFormateur(id: id, updateData)
            await fetchFormateurs()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // NEW: Delete Formateur (FORM-08)
    func deleteFormateur(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await api.deleteFormateur(id: id)
            formateurs.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
