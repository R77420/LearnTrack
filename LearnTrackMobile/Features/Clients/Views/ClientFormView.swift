import SwiftUI

struct ClientFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ClientViewModel
    
    @State private var nom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var ville = ""
    
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
            .navigationTitle("Nouveau Client")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            await viewModel.createClient(nom: nom, email: email, telephone: telephone, ville: ville)
                            dismiss()
                        }
                    }
                    .disabled(nom.isEmpty)
                }
            }
        }
    }
}
