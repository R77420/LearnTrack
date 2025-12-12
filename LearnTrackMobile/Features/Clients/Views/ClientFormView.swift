import SwiftUI

struct ClientFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ClientViewModel
    
    @State private var nom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var ville = ""
    
    var clientToEdit: Client?
    private var isEditing: Bool { clientToEdit != nil }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations Générales")) {
                    TextField("Nom", text: $nom)
                    TextField("Email", text: $email)
                        #if os(iOS)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        #endif
                    TextField("Téléphone", text: $telephone)
                        #if os(iOS)
                        .keyboardType(.phonePad)
                        #endif
                    TextField("Ville", text: $ville)
                }
            }
            .navigationTitle(isEditing ? "Modifier Client" : "Nouveau Client")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    // CORRECTION: Bascule entre Créer et Enregistrer
                    Button(isEditing ? "Enregistrer" : "Créer") {
                        Task {
                            if let client = clientToEdit {
                                // Opération MODIFIER (CLI-06)
                                let updateData = ClientUpdate(
                                    nom: nom,
                                    email: email,
                                    telephone: telephone,
                                    ville: ville
                                    // Les autres champs non affichés ne sont pas modifiés
                                )
                                await viewModel.updateClient(id: client.id, updateData: updateData)
                            } else {
                                // Opération CRÉER
                                await viewModel.createClient(nom: nom, email: email, telephone: telephone, ville: ville)
                            }
                            dismiss()
                        }
                    }
                    .disabled(nom.isEmpty)
                }
            }
            // CORRECTION: Chargement des données à l'ouverture pour l'édition
            .onAppear {
                if isEditing, let client = clientToEdit {
                    nom = client.nom
                    email = client.email ?? ""
                    telephone = client.telephone ?? ""
                    ville = client.ville ?? ""
                }
            }
        }
    }
}
