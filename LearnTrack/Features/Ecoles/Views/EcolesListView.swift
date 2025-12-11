import SwiftUI

struct EcoleListView: View {
    @StateObject private var viewModel = EcoleViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement des écoles...")
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
                } else {
                    List(viewModel.ecoles) { ecole in
                        NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                            EcoleRow(ecole: ecole)
                        }
                    }
                    .refreshable {
                        await viewModel.fetchEcoles()
                    }
                }
            }
            .navigationTitle("Écoles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) { Image(systemName: "plus") }
                }
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


