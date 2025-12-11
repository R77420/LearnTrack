import SwiftUI

struct EcoleListView: View {
    @StateObject private var viewModel = EcoleViewModel()
    @State private var isShowingCreateSheet = false
    @State private var searchText = ""
    
    var filteredEcoles: [Ecole] {
        if searchText.isEmpty {
            return viewModel.ecoles.sorted { $0.nom < $1.nom }
        } else {
            return viewModel.ecoles.filter {
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
                    ProgressView("Chargement des écoles...")
                        .frame(maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Erreur")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .foregroundStyle(.secondary)
                        Button("Réessayer") {
                            Task { await viewModel.fetchEcoles() }
                        }
                        .padding()
                    }
                } else if filteredEcoles.isEmpty {
                    EmptyStateView(icon: "graduationcap", message: "Aucune école trouvée")
                        .frame(maxHeight: .infinity)
                } else {
                    List(filteredEcoles) { ecole in
                        NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                             HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange.opacity(0.1))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "graduationcap.fill")
                                            .font(.title3)
                                            .foregroundStyle(.orange)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(ecole.nom)
                                        .font(.headline)
                                    if let ville = ecole.ville {
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
                        await viewModel.fetchEcoles()
                    }
                }
            }
            .navigationTitle("Écoles")
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
                EcoleFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchEcoles()
            }
        }
    }
}

struct EcoleRow: View {
    let ecole: Ecole
    
    var body: some View {
        HStack {
            Image(systemName: "graduationcap.fill")
                .font(.title2)
                .foregroundStyle(.purple)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(ecole.nom)
                    .font(.headline)
                if let ville = ecole.ville {
                    Text(ville)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}


