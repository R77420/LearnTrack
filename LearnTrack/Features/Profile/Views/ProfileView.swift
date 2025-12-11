import SwiftUI

struct ProfileView: View {
    @StateObject private var authManager = AuthService.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.blue)
                                )
                            
                            if let user = authManager.currentUser {
                                Text("\(user.prenom) \(user.nom)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Utilisateur")
                            }
                        }
                        .padding(.vertical)
                        Spacer()
                    }
                }
                
                Section("Paramètres") {
                    // Placeholder for future settings
                    HStack {
                        Image(systemName: "gear")
                        Text("Préférences")
                    }
                    HStack {
                        Image(systemName: "bell")
                        Text("Notifications")
                    }
                }
                
                Section {
                    Button(action: {
                        authManager.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Se déconnecter")
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}
