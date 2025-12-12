import SwiftUI

struct EcoleDetailView: View {
    let ecole: Ecole
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    
    // NEW: Ajoutez les ViewModels pour l'action et l'Auth
    @StateObject private var authManager = AuthService.shared
    @StateObject private var viewModel = EcoleViewModel()
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.orange)
                        )
                    
                    Text(ecole.nom)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                // Quick Actions
                HStack(spacing: 40) {
                    ActionButon(icon: "phone.fill", label: "Appeler") {
                        if let phone = ecole.telephone, let url = URL(string: "tel://\(phone)") {
                            openURL(url)
                        }
                    }
                    
                    ActionButon(icon: "envelope.fill", label: "Email") {
                        if let email = ecole.email, let url = URL(string: "mailto:\(email)") {
                            openURL(url)
                        }
                    }
                }
                
                Divider()
                
                // Contact
                VStack(alignment: .leading, spacing: 10) {
                    Text("Coordonnées")
                        .font(.headline)
                    
                    if let responsable = ecole.responsableNom {
                        ContactRow(icon: "person", text: "Resp: \(responsable)")
                    }
                    if let email = ecole.email {
                        ContactRow(icon: "envelope", text: email)
                    }
                     if let phone = ecole.telephone {
                        ContactRow(icon: "phone", text: phone)
                    }
                    
                    if let ville = ecole.ville {
                         HStack(alignment: .top) {
                             Image(systemName: "map")
                                 .frame(width: 24)
                             MapsLink(address: "\(ecole.adresse ?? "") \(ecole.codePostal ?? "") \(ville)")
                         }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
            deleteButton
                .padding(.horizontal)
                .padding(.bottom)
        }
        .navigationTitle("Détails École")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: { showingEditSheet = true }) { // ECO-06
                        Label("Modifier", systemImage: "pencil")
                    }
                    
                    // ECO-07 & SEC-05
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Supprimer", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            // On utilise le formulaire de création existant et on lui passe l'objet `ecole`
            EcoleFormView(viewModel: viewModel, ecoleToEdit: ecole)
        }
        // NEW: Alert for Delete
        .alert("Supprimer l'école", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    await viewModel.deleteEcole(id: ecole.id)
                    if viewModel.errorMessage == nil { dismiss() }
                }
            }
        } message: {
            Text("Êtes-vous sûr de vouloir supprimer l'école \(ecole.nom)?")
        }
    }
    
    private var deleteButton: some View {
        VStack {
            Divider()
            Button(role: .destructive, action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Supprimer l'école")
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
                    .fill(Color.orange)
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
