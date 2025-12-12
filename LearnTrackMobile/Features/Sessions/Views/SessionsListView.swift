import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var isShowingCreateSheet = false
    @State private var searchText = ""
    @State private var selectedFilter = "Tous"
    // NEW: Filter States
    @State private var selectedFormateurId: Int? = nil
    @State private var selectedClientId: Int? = nil
    
    // Derived filters
    var filteredSessions: [Session] {
        var sessions = viewModel.sessions
        
        // Search
        if !searchText.isEmpty {
            sessions = sessions.filter { $0.titre.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Filter Formateur
        if let fId = selectedFormateurId {
            sessions = sessions.filter { $0.formateurId == fId }
        }
        
        // Filter Client
        if let cId = selectedClientId {
             sessions = sessions.filter { $0.clientId == cId }
        }
        
        // Filter Dates
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        // DateFormatter pour parser "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if selectedFilter == "Mois actuel" {
            sessions = sessions.filter { session in
                guard let date = formatter.date(from: session.dateDebut) else { return false }
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                return month == currentMonth && year == currentYear
            }
        } else if selectedFilter == "Mois précédent" {
            sessions = sessions.filter { session in
                guard let date = formatter.date(from: session.dateDebut) else { return false }
                // Calcul un peu plus robuste nécessaire pour mois précédent/suivant (gestion changement d'année)
                // On peut utiliser dateComponents
                let components = calendar.dateComponents([.month, .year], from: date)
                // let sessionDateProp = calendar.date(from: components)!
                
                let targetDate = calendar.date(byAdding: .month, value: -1, to: now)!
                let targetComponents = calendar.dateComponents([.month, .year], from: targetDate)
                
                return components.month == targetComponents.month && components.year == targetComponents.year
            }
        } else if selectedFilter == "Mois prochain" {
             sessions = sessions.filter { session in
                guard let date = formatter.date(from: session.dateDebut) else { return false }
                
                let components = calendar.dateComponents([.month, .year], from: date)
                
                let targetDate = calendar.date(byAdding: .month, value: 1, to: now)!
                let targetComponents = calendar.dateComponents([.month, .year], from: targetDate)
                
                return components.month == targetComponents.month && components.year == targetComponents.year
            }
        }
        
        return sessions
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Filters
                VStack(spacing: 12) {
                    FilterView(selectedFilter: $selectedFilter, filters: ["Tous", "Mois précédent", "Mois actuel", "Mois prochain"])
                    
                    // NEW: Extra Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            // Formateur Picker
                            Menu {
                                Button("Tous") { selectedFormateurId = nil }
                                ForEach(viewModel.formateurs) { formateur in
                                    Button("\(formateur.prenom) \(formateur.nom)") {
                                        selectedFormateurId = formateur.id
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedFormateurId == nil ? "Formateur" : "Formateur: Sélectionné")
                                    Image(systemName: "chevron.down")
                                }
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedFormateurId == nil ? Color(.secondarySystemBackground) : Color.blue.opacity(0.1))
                                .foregroundColor(selectedFormateurId == nil ? .primary : .blue)
                                .cornerRadius(20)
                            }
                            
                            // Client Picker
                            Menu {
                                Button("Tous") { selectedClientId = nil }
                                ForEach(viewModel.clients) { client in
                                    Button(client.nom) {
                                        selectedClientId = client.id
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedClientId == nil ? "Client" : "Client: Sélectionné")
                                    Image(systemName: "chevron.down")
                                }
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedClientId == nil ? Color(.secondarySystemBackground) : Color.blue.opacity(0.1))
                                .foregroundColor(selectedClientId == nil ? .primary : .blue)
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
                
                // List
                Group {
                    if viewModel.isLoading {
                        ProgressView("Chargement des sessions...")
                            .frame(maxHeight: .infinity)
                    } else if filteredSessions.isEmpty {
                        EmptyStateView(icon: "calendar.badge.exclamationmark", message: "Aucune session trouvée")
                            .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(filteredSessions) { session in
                                    NavigationLink(destination: SessionDetailView(session: session)) {
                                        SessionCard(session: session)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                        .refreshable {
                            await viewModel.fetchSessions()
                            await viewModel.fetchDependencies()
                        }
                    }
                }
            }
            .navigationTitle("Sessions")
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
                SessionFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchSessions()
                await viewModel.fetchDependencies() // NEW: Need dependencies for filters
            }
        }
    }
}
