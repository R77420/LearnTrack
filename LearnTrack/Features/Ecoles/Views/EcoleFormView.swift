import SwiftUI

struct EcoleFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EcoleViewModel
    
    @State private var nom = ""
    @State private var adresse = ""
    @State private var ville = ""
    @State private var contactEmail = ""
    
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
            .navigationTitle("Nouvelle École")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            await viewModel.createEcole(nom: nom, adresse: adresse, ville: ville, email: contactEmail)
                            dismiss()
                        }
                    }
                    .disabled(nom.isEmpty)
                }
            }
        }
    }
}
