import SwiftUI

struct ProfileView: View {
    @StateObject private var authManager = AuthService.shared
    @State private var isDarkMode = false
    @State private var notificationsEnabled = true
    
    var body: some View {
        NavigationStack {
            List {
                // 1. Informations utilisateur
                Section(header: Text("Informations Utilisateur")) {
                    HStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(authManager.currentUser?.prenom.prefix(1) ?? "U")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                            )
                        
                        VStack(alignment: .leading) {
                            if let user = authManager.currentUser {
                                Text("\(user.prenom) \(user.nom)")
                                    .font(.headline)
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(user.role.capitalized)
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                                    .padding(.top, 2)
                            } else {
                                Text("Utilisateur")
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // 2. Préférences d'affichage
                Section(header: Text("Affichage")) {
                    Toggle("Mode Sombre", isOn: $isDarkMode)
                }
                
                // 3. Gestion des notifications
                Section(header: Text("Notifications")) {
                    Toggle("Activer les notifications", isOn: $notificationsEnabled)
                }
                
                // 4. À propos
                Section(header: Text("À propos")) {
                    NavigationLink("À propos de l'application") {
                        AboutView()
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // 5. Déconnexion
                Section {
                    Button(role: .destructive, action: {
                        authManager.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Se déconnecter")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profil")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

// Sub-view for About section
struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("LearnTrack Mobile")
                        .font(.headline)
                    Text("Une application complète pour la gestion des sessions de formation, des formateurs, des clients et des écoles.")
                        .font(.body)
                }
                .padding(.vertical)
            }
            
            Section("Développé par") {
                Text("Équipe LearnTrack")
            }
        }
        .navigationTitle("À propos")
    }
}
