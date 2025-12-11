import SwiftUI

struct ClientDetailView: View {
    let client: Client
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(client.nom.prefix(1))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.purple)
                        )
                    
                    Text(client.nom)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                // Quick Actions
                HStack(spacing: 40) {
                    ActionButon(icon: "phone.fill", label: "Appeler") {
                        if let phone = client.telephone ?? client.contactTelephone, let url = URL(string: "tel://\(phone)") {
                            openURL(url)
                        }
                    }
                    
                    ActionButon(icon: "envelope.fill", label: "Email") {
                        if let email = client.email ?? client.contactEmail, let url = URL(string: "mailto:\(email)") {
                            openURL(url)
                        }
                    }
                }
                
                Divider()
                
                // Contact
                VStack(alignment: .leading, spacing: 10) {
                    Text("Contact Principal")
                        .font(.headline)
                    
                    if let contact = client.contactNom {
                        ContactRow(icon: "person", text: contact)
                    }
                    if let email = client.contactEmail {
                        ContactRow(icon: "envelope", text: email)
                    }
                    if let phone = client.contactTelephone {
                        ContactRow(icon: "phone", text: phone)
                    }
                    
                    if let ville = client.ville {
                        HStack(alignment: .top) {
                            Image(systemName: "map")
                                .frame(width: 24)
                            MapsLink(address: "\(client.adresse ?? "") \(client.codePostal ?? "") \(ville)")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // Fiscal
                VStack(alignment: .leading, spacing: 10) {
                    Text("Informations")
                        .font(.headline)
                    
                    if let siret = client.siret {
                        InfoRow(label: "SIRET", value: siret)
                    }
                    if let tva = client.tvaIntra {
                        InfoRow(label: "TVA Intra", value: tva)
                    }
                    
                    // Fake Stats for demo
                    InfoRow(label: "Sessions", value: "3")
                    InfoRow(label: "CA Total", value: "4 500 €")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Détails Client")
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
                    .fill(Color.purple)
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
