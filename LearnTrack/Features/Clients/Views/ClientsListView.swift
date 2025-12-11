import SwiftUI

struct ClientListView: View {
    @StateObject private var viewModel = ClientViewModel()
    @State private var isShowingCreateSheet = false
    @State private var searchText = ""
    
    var filteredClients: [Client] {
        if searchText.isEmpty {
            return viewModel.clients.sorted { $0.nom < $1.nom }
        } else {
            return viewModel.clients.filter {
                $0.nom.localizedCaseInsensitiveContains(searchText) ||
                ($0.ville ?? "").localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.nom < $1.nom }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView("Chargement des clients...")
                        .frame(maxHeight: .infinity)
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
                } else if filteredClients.isEmpty {
                    EmptyStateView(icon: "building.2", message: "Aucun client trouvé")
                        .frame(maxHeight: .infinity)
                } else {
                    List(filteredClients) { client in
                        NavigationLink(destination: ClientDetailView(client: client)) {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.purple.opacity(0.1))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text(client.nom.prefix(1))
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.purple)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(client.nom)
                                        .font(.headline)
                                    if let ville = client.ville {
                                        Text(ville)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchClients()
                    }
                }
            }
            .navigationTitle("Clients")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isShowingCreateSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingCreateSheet) {
                ClientFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchClients()
            }
        }
    }
}
