import SwiftUI

struct FormateurListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    @State private var isShowingCreateSheet = false
    @State private var searchText = ""
    @State private var filter: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "Tous"
        case internes = "Internes"
        case externes = "Externes"
    }
    
    var filteredFormateurs: [Formateur] {
        var list = viewModel.formateurs
        
        if !searchText.isEmpty {
            list = list.filter {
                $0.nom.localizedCaseInsensitiveContains(searchText) ||
                $0.prenom.localizedCaseInsensitiveContains(searchText) ||
                ($0.specialites ?? []).joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch filter {
        case .all: break
        case .internes: list = list.filter { $0.estInterne == true }
        case .externes: list = list.filter { $0.estInterne != true }
        }
        
        return list.sorted { $0.nom < $1.nom }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                Picker("Filtre", selection: $filter) {
                    ForEach(FilterType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Display loading or error messages if applicable
                if viewModel.isLoading {
                    ProgressView("Chargement des formateurs...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text("Erreur")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Button("Réessayer") {
                            Task { await viewModel.fetchFormateurs() }
                        }
                        .padding()
                    }
                } else {
                    List(filteredFormateurs) { formateur in
                        NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                            HStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text("\(formateur.prenom.prefix(1))\(formateur.nom.prefix(1))")
                                            .font(.headline)
                                            .foregroundStyle(.blue)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text("\(formateur.prenom) \(formateur.nom)")
                                        .font(.headline)
                                    if let specialites = formateur.specialites, !specialites.isEmpty {
                                        Text(specialites.joined(separator: ", "))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                if formateur.estInterne == true {
                                    Badge(text: "INT", color: .green)
                                } else {
                                    Badge(text: "EXT", color: .orange)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchFormateurs()
                    }
                }
            }
            .navigationTitle("Formateurs")
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
                FormateurFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchFormateurs()
            }
        }
    }
}
