import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SessionListView()
                .tabItem {
                    Label("Sessions", systemImage: "calendar")
                }
            
            FormateurListView()
                .tabItem {
                    Label("Formateurs", systemImage: "person.2")
                }
            
            ClientListView()
                .tabItem {
                    Label("Clients", systemImage: "building.2")
                }
            
            EcoleListView()
                .tabItem {
                    Label("Écoles", systemImage: "graduationcap")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabView()
}
