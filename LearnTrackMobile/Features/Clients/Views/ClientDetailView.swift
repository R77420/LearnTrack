import SwiftUI

struct ClientDetailView: View {
    let client: Client
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss // Permet de fermer la vue après suppression
        
    // NEW: Ajoutez les ViewModels pour l'action et l'Auth
    @StateObject private var authManager = AuthService.shared
    @StateObject private var viewModel = ClientViewModel()
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(client.nom.prefix(1))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.purple)
                        )
                    
                    Text(client.nom)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                // Quick Actions
                HStack(spacing: 40) {
                    ActionButon(icon: "phone.fill", label: "Appeler") {
                        if let phone = client.telephone ?? client.contactTelephone, let url = URL(string: "tel://\(phone)") {
                            openURL(url)
                        }
                    }
                    
                    ActionButon(icon: "envelope.fill", label: "Email") {
                        if let email = client.email ?? client.contactEmail, let url = URL(string: "mailto:\(email)") {
                            openURL(url)
                        }
                    }
                }
                
                Divider()
                
                // Contact
                VStack(alignment: .leading, spacing: 10) {
                    Text("Contact Principal")
                        .font(.headline)
                    
                    if let contact = client.contactNom {
                        ContactRow(icon: "person", text: contact)
                    }
                    if let email = client.contactEmail {
                        ContactRow(icon: "envelope", text: email)
                    }
                    if let phone = client.contactTelephone {
                        ContactRow(icon: "phone", text: phone)
                    }
                    
                    if let ville = client.ville {
                        HStack(alignment: .top) {
                            Image(systemName: "map")
                                .frame(width: 24)
                            MapsLink(address: "\(client.adresse ?? "") \(client.codePostal ?? "") \(ville)")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // Fiscal
                VStack(alignment: .leading, spacing: 10) {
                    Text("Informations")
                        .font(.headline)
                    
                    if let siret = client.siret {
                        InfoRow(label: "SIRET", value: siret)
                    }
                    if let tva = client.tvaIntra {
                        InfoRow(label: "TVA Intra", value: tva)
                    }
                    
                    // Fake Stats for demo
                    InfoRow(label: "Sessions", value: "3")
                    InfoRow(label: "CA Total", value: "4 500 €")
                }

                .frame(maxWidth: .infinity, alignment: .leading)
                
                deleteButton
            }
            .padding()
        }
        .navigationTitle("Détails Client")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    // CLI-06: Modifier
                    Button(action: { showingEditSheet = true }) {
                        Label("Modifier", systemImage: "pencil")
                    }
                    
                    // CLI-07 & SEC-05: Supprimer (Admin Only)
                    // CLI-07 & SEC-05: Supprimer
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Supprimer", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        // CORRECTION: Utilisation du ClientFormView pour l'édition (CLI-06)
        .sheet(isPresented: $showingEditSheet) {
            ClientFormView(viewModel: viewModel, clientToEdit: client)
        }
        // Suppression (CLI-07)
        .alert("Supprimer le client", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    await viewModel.deleteClient(id: client.id)
                    if viewModel.errorMessage == nil { dismiss() }
                }
            }
        } message: {
            Text("Êtes-vous sûr de vouloir supprimer le client \(client.nom)?")
        }
    }
    
    // Helper View for bottom delete button
    private var deleteButton: some View {
        VStack {
            Divider()
            Button(role: .destructive, action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Supprimer le client")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .foregroundStyle(.red)
                .cornerRadius(10)
            }
        }
    }
}

fileprivate struct ActionButon: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundStyle(.white)
                    )
                Text(label)
                    .font(.caption)
            }
        }
    }
}

fileprivate struct ContactRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.secondary)
            Text(text)
        }
    }
}

fileprivate struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
