import SwiftUI

struct EcoleDetailView: View {
    let ecole: Ecole
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(ecole.nom)
                    .font(.title)
                    .fontWeight(.bold)
                
                if let adresse = ecole.adresse {
                    Label(adresse, systemImage: "mappin.circle")
                }
                
                if let email = ecole.email {
                    Link(destination: URL(string: "mailto:\(email)")!) {
                        Label(email, systemImage: "envelope")
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Détails École")
    }
}
