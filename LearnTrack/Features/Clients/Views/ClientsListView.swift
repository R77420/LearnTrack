import SwiftUI

struct ClientListView: View {
    @StateObject private var viewModel = ClientViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement des clients...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Erreur")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .foregroundStyle(.secondary)
                        Button("Réessayer") {
                            Task { await viewModel.fetchClients() }
                        }
                        .padding()
                    }
                } else {
                    List(viewModel.clients) { client in
                        NavigationLink(destination: ClientDetailView(client: client)) {
                            ClientRow(client: client)
                        }
                    }
                    .refreshable {
                        await viewModel.fetchClients()
                    }
                }
            }
            .navigationTitle("Clients")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) { Image(systemName: "plus") }
                }
            }
            .task {
                await viewModel.fetchClients()
            }
        }
    }
}

struct ClientRow: View {
    let client: Client
    
    var body: some View {
        HStack {
            Image(systemName: "building.2.fill")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(client.nom)
                    .font(.headline)
                if let ville = client.ville {
                    Text(ville)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
