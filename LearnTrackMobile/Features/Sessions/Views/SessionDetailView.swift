import SwiftUI

struct SessionDetailView: View {
    let session: Session
    // NEW: Add necessary state and managers
    @Environment(\.openURL) var openURL
    @StateObject private var authManager = AuthService.shared
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(session.titre)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Badge(text: session.statut, color: .blue)
                            Badge(text: session.modalite ?? "Présentiel", color: .purple)
                        }
                    }
                    
                    Divider()
                    
                    // Date & Horaires
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Date et Horaires", systemImage: "calendar")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Du \(session.dateDebut)")
                                Text("Au \(session.dateFin)")
                            }
                            Spacer()
                            if let hStart = session.heureDebut, let hEnd = session.heureFin {
                                Text("\(hStart) - \(hEnd)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Lieu (Maps)
                    if let lieu = session.lieu {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Lieu", systemImage: "map")
                                .font(.headline)
                            MapsLink(address: lieu)
                        }
                        Divider()
                    }
                    
                    // Intervenants (Non-functional links for MVP)
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Intervenants", systemImage: "person.2")
                            .font(.headline)
                        
                        // Placeholder for Formateur, Client, Ecole details
                        // In a real app, these would fetch the entities and link to their Details
                        if let formateurId = session.formateurId {
                            HStack {
                                Image(systemName: "person.circle")
                                Text("Formateur (ID: \(formateurId))")
                            }
                        }
                        
                        if let clientId = session.clientId {
                            HStack {
                                Image(systemName: "building.2")
                                Text("Client (ID: \(clientId))")
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Tarifs
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Financier", systemImage: "eurosign.circle")
                            .font(.headline)
                        
                        if let prix = session.prix {
                            HStack {
                                Text("Prix total")
                                Spacer()
                                Text(String(format: "%.2f €", prix))
                                    .fontWeight(.bold)
                            }
                        } else {
                            Text("Aucun tarif défini")
                                .foregroundStyle(.secondary)
                        }
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
                    
                    if authManager.isAdmin { // RBAC check (SEC-05)
                        Button(role: .destructive, action: { showingDeleteAlert = true }) { Label("Supprimer", systemImage: "trash") } // SESS-04
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
                    SessionFormView(viewModel: viewModel, sessionToEdit: session) // Le formulaire reçoit l'objet `session`
                }
    }
}
