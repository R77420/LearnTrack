import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var isShowingCreateSheet = false
    @State private var searchText = ""
    @State private var selectedFilter = "Tous"
    
    // Derived filters
    var filteredSessions: [Session] {
        var sessions = viewModel.sessions
        
        // Search
        if !searchText.isEmpty {
            sessions = sessions.filter { $0.titre.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Filter (Simplified implementation for demo)
        if selectedFilter == "Mois actuel" {
            // Logic to filter by month could be added here
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
                FilterView(selectedFilter: $selectedFilter, filters: ["Tous", "Mois précédent", "Mois actuel", "Mois prochain"])
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
            }
        }
    }
}
