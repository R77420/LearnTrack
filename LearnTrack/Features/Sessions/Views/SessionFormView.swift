import SwiftUI

struct SessionFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SessionViewModel
    
    @State private var titre = ""
    @State private var dateDebut = Date()
    @State private var dateFin = Date().addingTimeInterval(3600 * 24)
    @State private var statut = "Planifiée"
    @State private var modalite = "Présentiel"
    @State private var lieu = ""
    @State private var heureDebut = Date()
    @State private var heureEnd = Date().addingTimeInterval(3600)
    
    let statusOptions = ["Planifiée", "En cours", "Terminée", "Annulée"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails Session")) {
                    TextField("Titre (ou module)", text: $titre)
                    
                    Picker("Modalité", selection: $modalite) {
                        ForEach(["Présentiel", "Distanciel"], id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("Lieu", text: $lieu)
                    
                    Picker("Statut", selection: $statut) {
                        ForEach(statusOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                
                Section(header: Text("Dates & Horaires")) {
                    DatePicker("Date de début", selection: $dateDebut, displayedComponents: .date)
                    DatePicker("Heure de début", selection: $heureDebut, displayedComponents: .hourAndMinute)
                    
                    DatePicker("Date de fin", selection: $dateFin, displayedComponents: .date)
                    DatePicker("Heure de fin", selection: $heureEnd, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("Nouvelle Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            // Note: We need to format dates/times properly for the API
                            // For MVP, we'll keep the signature simple or update VM to handle Dates
                             await viewModel.createSession(
                                titre: titre, 
                                dateDebut: dateDebut, 
                                dateFin: dateFin, 
                                statut: statut,
                                modalite: modalite,
                                lieu: lieu,
                                heureDebut: heureDebut,
                                heureFin: heureEnd
                            )
                            dismiss()
                        }
                    }
                    .disabled(titre.isEmpty)
                }
            }
        }
    }
}
