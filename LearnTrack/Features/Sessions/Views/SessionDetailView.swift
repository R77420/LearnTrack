import SwiftUI

struct SessionDetailView: View {
    let session: Session
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(session.titre)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    Label(session.dateDebut, systemImage: "calendar")
                    Spacer()
                    Label(session.statut, systemImage: "flag")
                }
                .foregroundStyle(.secondary)
                
                if let description = session.description {
                    Text("Description")
                        .font(.headline)
                    Text(description)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Détails")
    }
}
