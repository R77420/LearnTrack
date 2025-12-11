import SwiftUI

struct EcoleDetailView: View {
    let ecole: Ecole
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.orange)
                        )
                    
                    Text(ecole.nom)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                // Quick Actions
                HStack(spacing: 40) {
                    ActionButon(icon: "phone.fill", label: "Appeler") {
                        if let phone = ecole.telephone, let url = URL(string: "tel://\(phone)") {
                            openURL(url)
                        }
                    }
                    
                    ActionButon(icon: "envelope.fill", label: "Email") {
                        if let email = ecole.email, let url = URL(string: "mailto:\(email)") {
                            openURL(url)
                        }
                    }
                }
                
                Divider()
                
                // Contact
                VStack(alignment: .leading, spacing: 10) {
                    Text("Coordonnées")
                        .font(.headline)
                    
                    if let responsable = ecole.responsableNom {
                        ContactRow(icon: "person", text: "Resp: \(responsable)")
                    }
                    if let email = ecole.email {
                        ContactRow(icon: "envelope", text: email)
                    }
                     if let phone = ecole.telephone {
                        ContactRow(icon: "phone", text: phone)
                    }
                    
                    if let ville = ecole.ville {
                         HStack(alignment: .top) {
                             Image(systemName: "map")
                                 .frame(width: 24)
                             MapsLink(address: "\(ecole.adresse ?? "") \(ecole.codePostal ?? "") \(ville)")
                         }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Détails École")
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
                    .fill(Color.orange)
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
