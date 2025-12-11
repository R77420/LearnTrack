import SwiftUI

struct FormateurDetailView: View {
    let formateur: Formateur
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack(spacing: 15) {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Text(String(formateur.prenom.prefix(1)) + String(formateur.nom.prefix(1)))
                                .font(.title)
                                .foregroundStyle(.orange)
                        )
                    
                    VStack(alignment: .leading) {
                        Text("\(formateur.prenom) \(formateur.nom)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(formateur.email)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Actions
                HStack(spacing: 20) {
                    ContactButton(icon: "phone.fill", label: "Appeler", action: {
                        if let phone = formateur.telephone, let url = URL(string: "tel://\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    })
                    
                    ContactButton(icon: "envelope.fill", label: "Email", action: {
                        if let url = URL(string: "mailto:\(formateur.email)") {
                            UIApplication.shared.open(url)
                        }
                    })
                }
                
                Divider()
                
                // Details
                VStack(alignment: .leading, spacing: 10) {
                    DetailRow(icon: "briefcase", title: "Spécialités", value: formateur.specialites?.joined(separator: ", ") ?? "N/A")
                    DetailRow(icon: "eurosign.circle", title: "Tarif", value: formateur.tarifJournalier.map { String(format: "%.2f €/j", $0) } ?? "N/A")
                    DetailRow(icon: "mappin.circle", title: "Adresse", value: [formateur.adresse, formateur.codePostal, formateur.ville].compactMap({ $0 }).joined(separator: ", "))
                    
                    if let notes = formateur.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Notes")
                                .font(.headline)
                            Text(notes)
                                .font(.body)
                        }
                        .padding(.top)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Détails Formateur")
    }
}

// Reusable Components (can be moved to Shared if needed)

struct ContactButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .frame(width: 25)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }
        }
        .padding(.vertical, 5)
    }
}
