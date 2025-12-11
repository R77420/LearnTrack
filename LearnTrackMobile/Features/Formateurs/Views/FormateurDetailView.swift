import SwiftUI

struct FormateurDetailView: View {
    let formateur: Formateur
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("\(formateur.prenom.prefix(1))\(formateur.nom.prefix(1))")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.blue)
                        )
                    
                    Text("\(formateur.prenom) \(formateur.nom)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let specialites = formateur.specialites, !specialites.isEmpty {
                        Text(specialites.joined(separator: " • "))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Quick Actions
                HStack(spacing: 40) {
                    ActionButon(icon: "phone.fill", label: "Appeler") {
                        if let phone = formateur.telephone, let url = URL(string: "tel://\(phone)") {
                            openURL(url)
                        }
                    }
                    
                    ActionButon(icon: "envelope.fill", label: "Email") {
                        if let email = URL(string: "mailto:\(formateur.email)") {
                            openURL(email)
                        }
                    }
                    
                    ActionButon(icon: "message.fill", label: "SMS") {
                        if let phone = formateur.telephone, let url = URL(string: "sms://\(phone)") {
                            openURL(url)
                        }
                    }
                }
                
                Divider()
                
                 // Coordonnées
                VStack(alignment: .leading, spacing: 10) {
                    Text("Coordonnées")
                        .font(.headline)
                    
                    ContactRow(icon: "envelope", text: formateur.email)
                    if let phone = formateur.telephone {
                        ContactRow(icon: "phone", text: phone)
                    }
                     if let adresse = formateur.adresse {
                         HStack(alignment: .top) {
                             Image(systemName: "map")
                                 .frame(width: 24)
                             MapsLink(address: "\(adresse) \(formateur.codePostal ?? "") \(formateur.ville ?? "")")
                         }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // Informations Professionnelles
                VStack(alignment: .leading, spacing: 10) {
                    Text("Informations Professionnelles")
                        .font(.headline)
                    
                     if let tarif = formateur.tarifJournalier {
                        InfoRow(label: "Tarif Journalier", value: String(format: "%.2f €", tarif))
                    }
                    
                    InfoRow(label: "Type", value: (formateur.estInterne == true) ? "Interne" : "Externe")
                    
                    if let siret = formateur.siret {
                         InfoRow(label: "SIRET", value: siret)
                    }
                    
                    if let nda = formateur.nda {
                         InfoRow(label: "NDA", value: nda)
                    }
                }
                 .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Détails Formateur")
    }
}

fileprivate struct ActionButon: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundStyle(.white)
                    )
                Text(label)
                    .font(.caption)
            }
        }
    }
}

fileprivate struct ContactRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.secondary)
            Text(text)
        }
    }
}

fileprivate struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
