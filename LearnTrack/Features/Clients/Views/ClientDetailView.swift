import SwiftUI

struct ClientDetailView: View {
    let client: Client
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack(spacing: 15) {
                    Image(systemName: "building.2.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(client.nom)
                            .font(.title2)
                            .fontWeight(.bold)
                        if let email = client.email {
                            Text(email)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // Contact Info
                if let contactNom = client.contactNom {
                    VStack(alignment: .leading) {
                        Text("Contact Principal")
                            .font(.headline)
                        Text(contactNom)
                            .font(.body)
                        if let contactEmail = client.contactEmail {
                            Text(contactEmail).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Actions
                HStack(spacing: 20) {
                    // Reuse ContactButton logic if possible, otherwise inline
                    Button(action: {
                        if let phone = client.telephone ?? client.contactTelephone, let url = URL(string: "tel://\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack {
                            Image(systemName: "phone.fill")
                            Text("Appeler")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if let email = client.email ?? client.contactEmail, let url = URL(string: "mailto:\(email)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack {
                            Image(systemName: "envelope.fill")
                            Text("Email")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                
                Divider()
                
                // Details
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "mappin.circle")
                        Text([client.adresse, client.codePostal, client.ville].compactMap({ $0 }).joined(separator: ", "))
                    }
                    if let siret = client.siret {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("SIRET: \(siret)")
                        }
                    }
                }
                .padding(.vertical)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Détails Client")
    }
}
