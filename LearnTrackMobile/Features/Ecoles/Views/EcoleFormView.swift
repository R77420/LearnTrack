import SwiftUI

struct EcoleFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EcoleViewModel
    
    var ecoleToEdit: Ecole?
    
    @State private var nom = ""
    @State private var adresse = ""
    @State private var ville = ""
    @State private var contactEmail = ""
    
    private var isEditing: Bool { ecoleToEdit != nil }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations École")) {
                    TextField("Nom", text: $nom)
                    TextField("Adresse", text: $adresse)
                    TextField("Ville", text: $ville)
                    TextField("Email contact", text: $contactEmail)
                        #if os(iOS)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        #endif
                }
            }
            .navigationTitle(isEditing ? "Modifier École" : "Nouvelle École")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Enregistrer" : "Créer") { // CORRECTION BOUTON
                        Task {
                            if let ecole = ecoleToEdit {
                                // Opération MODIFIER (ECO-06)
                                let updateData = EcoleUpdate(
                                    nom: nom,
                                    adresse: adresse.isEmpty ? nil : adresse,
                                    ville: ville.isEmpty ? nil : ville,
                                    email: contactEmail.isEmpty ? nil : contactEmail
                                )
                                await viewModel.updateEcole(id: ecole.id, updateData: updateData)
                            } else {
                                // Opération CRÉER
                                await viewModel.createEcole(nom: nom, adresse: adresse, ville: ville, email: contactEmail)
                            }
                            dismiss()
                        }
                    }
                    .disabled(nom.isEmpty)
                }
            }
            // CORRECTION: Chargement des données à l'ouverture pour l'édition
            .onAppear {
                if isEditing, let ecole = ecoleToEdit {
                    nom = ecole.nom
                    adresse = ecole.adresse ?? ""
                    ville = ecole.ville ?? ""
                    contactEmail = ecole.email ?? ""
                }
            }
        }
    }
}
