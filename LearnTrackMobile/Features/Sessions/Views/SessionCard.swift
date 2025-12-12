import SwiftUI

struct SessionCard: View {
    let session: Session
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(session.titre)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Badge(text: session.statut, color: statusColor(session.statut))
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                Text(session.dateDebut)
                Spacer()
                if let heure = session.heureDebut {
                    Text(heure)
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            HStack {
                Badge(text: session.modalite ?? "Présentiel", color: .purple)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Planifiée": return .blue
        case "En cours": return .green
        case "Terminée": return .gray
        case "Annulée": return .red
        default: return .blue
        }
    }
}
