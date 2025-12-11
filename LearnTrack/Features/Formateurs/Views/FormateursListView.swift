import SwiftUI

struct FormateurListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement des formateurs...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Erreur")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .foregroundStyle(.secondary)
                        Button("Réessayer") {
                            Task { await viewModel.fetchFormateurs() }
                        }
                        .padding()
                    }
                } else {
                    List(viewModel.formateurs) { formateur in
                        NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                            FormateurRow(formateur: formateur)
                        }
                    }
                    .refreshable {
                        await viewModel.fetchFormateurs()
                    }
                }
            }
            .navigationTitle("Formateurs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) { Image(systemName: "plus") }
                }
            }
            .task {
                await viewModel.fetchFormateurs()
            }
        }
    }
}

struct FormateurRow: View {
    let formateur: Formateur
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(formateur.prenom.prefix(1)) + String(formateur.nom.prefix(1)))
                        .font(.headline)
                        .foregroundStyle(.orange)
                )
            
            VStack(alignment: .leading) {
                Text("\(formateur.prenom) \(formateur.nom)")
                    .font(.headline)
                if let specialites = formateur.specialites, !specialites.isEmpty {
                    Text(specialites.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
}
