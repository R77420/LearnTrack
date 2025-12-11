import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = SessionViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement des sessions...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Erreur")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Button("Réessayer") {
                            Task { await viewModel.fetchSessions() }
                        }
                        .padding()
                    }
                } else if viewModel.sessions.isEmpty {
                    VStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("Aucune session trouvée")
                            .font(.headline)
                            .padding(.top)
                    }
                } else {
                    List(viewModel.sessions) { session in
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            SessionRow(session: session)
                        }
                    }
                    .refreshable {
                        await viewModel.fetchSessions()
                    }
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Add new session
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await viewModel.fetchSessions()
            }
        }
    }
}

struct SessionRow: View {
    let session: Session
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(session.titre)
                .font(.headline)
            HStack {
                Image(systemName: "calendar")
                Text(session.dateDebut)
                Spacer()
                Text(session.statut)
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(5)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }
}

import Foundation

// Placeholder for detail view to allow compilation

