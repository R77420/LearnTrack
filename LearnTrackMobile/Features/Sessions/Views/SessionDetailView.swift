import SwiftUI

struct SessionDetailView: View {
    let session: Session
    // NEW: Add necessary state and managers
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthService.shared
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    // NEW: Computed properties for display
    private var margin: Double? {
        guard let p = session.prix else { return nil }
        let st = session.tarifSousTraitant ?? 0
        let fr = session.fraisRembourser ?? 0
        return p - st - fr
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 1. Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text(session.titre)
                            .font(.title) // Large Title can be too big
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            Badge(text: session.statut, color: statusColor(session.statut))
                            Badge(text: session.modaliteDisplay, color: .purple)
                        }
                    }
                    .padding(.bottom, 5)
                    
                    Divider()
                    
                    // 2. Dates & Horaires
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Date et Horaires", systemImage: "calendar")
                            .font(.headline)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "calendar")
                                .foregroundStyle(.blue)
                                .font(.system(size: 24))
                                .frame(width: 32)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Du \(session.dateDebut)")
                                    .fontWeight(.medium)
                                Text("Au \(session.dateFin)")
                                    .fontWeight(.medium)
                            }
                            
                            Spacer()
                            
                            if let hStart = session.heureDebut, let hEnd = session.heureFin {
                                VStack(alignment: .trailing) {
                                    HStack {
                                        Image(systemName: "clock")
                                        Text(hStart)
                                    }
                                    HStack {
                                        Image(systemName: "arrow.right")
                                            .font(.caption)
                                        Text(hEnd)
                                    }
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 3. Lieu
                    if let lieu = session.lieu, !lieu.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Lieu", systemImage: "map")
                                .font(.headline)
                            
                            HStack(alignment: .top) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 24))
                                    .frame(width: 32)
                                
                                MapsLink(address: lieu)
                            }
                        }
                        Divider()
                    }
                    
                    // 4. Intervenants (Cliquables)
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Intervenants", systemImage: "person.2.fill")
                            .font(.headline)
                        
                        if let fId = session.formateurId, let formateur = viewModel.formateurs.first(where: { $0.id == fId }) {
                            NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                                IntervenantRow(icon: "person.circle.fill", color: .blue, title: "Formateur", name: "\(formateur.prenom) \(formateur.nom)")
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if let fId = session.formateurId {
                            // Fallback if not loaded
                             IntervenantRow(icon: "person.circle.fill", color: .gray, title: "Formateur", name: "ID: \(fId)")
                        }
                        
                        if let cId = session.clientId, let client = viewModel.clients.first(where: { $0.id == cId }) {
                            NavigationLink(destination: ClientDetailView(client: client)) {
                                IntervenantRow(icon: "building.2.fill", color: .purple, title: "Client", name: client.nom)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if let cId = session.clientId {
                             IntervenantRow(icon: "building.2.fill", color: .gray, title: "Client", name: "ID: \(cId)")
                        }
                        
                        if let eId = session.ecoleId, let ecole = viewModel.ecoles.first(where: { $0.id == eId }) {
                            NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                                IntervenantRow(icon: "graduationcap.fill", color: .orange, title: "École", name: ecole.nom)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Divider()
                    
                    // 5. Tarifs et Marge
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Financier", systemImage: "eurosign.circle.fill")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            if let prix = session.prix {
                                FinanceRow(label: "Tarif Client", value: prix, isBold: true)
                            }
                            
                            if let st = session.tarifSousTraitant {
                                FinanceRow(label: "Sous-traitant", value: -st, color: .red) // Negative for cost
                            }
                            
                            if let frais = session.fraisRembourser {
                                FinanceRow(label: "Frais", value: -frais, color: .red) // Negative for cost
                            }
                            
                            Divider()
                            
                            if let marge = margin {
                                HStack {
                                    Text("Marge")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(String(format: "%.2f €", marge))
                                        .fontWeight(.bold)
                                        .foregroundStyle(marge >= 0 ? .green : .red)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    
                    
                    // 6. Zone de Danger
                    Divider()
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Supprimer la session")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundStyle(.red)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Détail Session")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: { showingEditSheet = true }) { Label("Modifier", systemImage: "pencil") } // SESS-03
                    
                    // NEW: ShareLink implementation (SESS-06)
                    ShareLink(item: session.shareText, subject: Text("Session: \(session.titre)")) {
                        Label("Partager", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) { Label("Supprimer", systemImage: "trash") } // SESS-04
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
                    SessionFormView(viewModel: viewModel, sessionToEdit: session) // Le formulaire reçoit l'objet `session`
        }
        .alert("Supprimer la session", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    await viewModel.deleteSession(id: session.id)
                    if viewModel.errorMessage == nil { dismiss() }
                }
            }
        } message: {
            Text("Êtes-vous sûr de vouloir supprimer la session \(session.titre)?")
        }
        .task {
            // Load dependencies to find names for Intervenants
            await viewModel.fetchDependencies()
        }
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Planifiée": return .blue
        case "En cours": return .green
        case "Terminée": return .gray
        case "Annulée": return .red
        default: return .blue
        }
    }
}

// Subviews
struct IntervenantRow: View {
    let icon: String
    let color: Color
    let title: String
    let name: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(name)
                    .font(.body)
                    .fontWeight(.medium)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle()) // Make full row clickable
    }
}

struct FinanceRow: View {
    let label: String
    let value: Double
    var color: Color = .primary
    var isBold: Bool = false
    
    var body: some View {
        HStack {
             Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(String(format: "%.2f €", value))
                .fontWeight(isBold ? .bold : .regular)
                .foregroundStyle(color)
        }
    }
}
