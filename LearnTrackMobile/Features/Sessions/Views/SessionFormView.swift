import SwiftUI

struct SessionFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SessionViewModel
    
    var sessionToEdit: Session?
    
    @State private var titre = ""
    @State private var dateDebut = Date()
    @State private var dateFin = Date().addingTimeInterval(3600 * 24)
    @State private var statut = "Planifiée"
    @State private var modalite = "Présentiel"
    @State private var lieu = ""
    @State private var heureDebut = Date()
    @State private var heureEnd = Date().addingTimeInterval(3600)
    
    // NEW: Champs obligatoires pour SESS-02
    @State private var selectedFormateurId: Int? = nil
    @State private var selectedClientId: Int? = nil
    @State private var selectedEcoleId: Int? = nil
    
    @State private var prixClient = "" // prix dans l'API
    @State private var tarifSousTraitant = ""
    @State private var fraisRembourser = ""
    @State private var refContrat = ""
    
    let statusOptions = ["Planifiée", "En cours", "Terminée", "Annulée"]
    
    private var isEditing: Bool { sessionToEdit != nil }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails Session")) {
                    TextField("Titre (ou module)", text: $titre)
                    
                    Picker("Modalité", selection: $modalite) {
                        Text("Présentiel").tag("Présentiel")
                        Text("Distanciel").tag("Distanciel")
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

                // NEW: Intervenants Section (SESS-02)
                Section(header: Text("Intervenants")) {
                    Picker("Formateur", selection: $selectedFormateurId) {
                        Text("Aucun").tag(nil as Int?)
                        ForEach(viewModel.formateurs, id: \.id) { formateur in
                            Text("\(formateur.prenom) \(formateur.nom)").tag(formateur.id as Int?)
                        }
                    }
                    
                    Picker("Client", selection: $selectedClientId) {
                        Text("Aucun").tag(nil as Int?)
                        ForEach(viewModel.clients, id: \.id) { client in
                            Text(client.nom).tag(client.id as Int?)
                        }
                    }
                    
                    Picker("École", selection: $selectedEcoleId) {
                        Text("Aucune").tag(nil as Int?)
                        ForEach(viewModel.ecoles, id: \.id) { ecole in
                            Text(ecole.nom).tag(ecole.id as Int?)
                        }
                    }
                }

                // NEW: Tarifs Section (SESS-02)
                Section(header: Text("Financier (EUR)")) {
                    TextField("Tarif Client", text: $prixClient)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    TextField("Tarif Sous-traitant", text: $tarifSousTraitant)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    TextField("Frais à Rembourser", text: $fraisRembourser)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    TextField("Référence Contrat", text: $refContrat)
                }
            }
            .navigationTitle(isEditing ? "Modifier Session" : "Nouvelle Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Enregistrer" : "Créer") { // MODIFIÉ: Texte du bouton
                        Task {
                            let prix = Double(prixClient.replacingOccurrences(of: ",", with: "."))
                            let st = Double(tarifSousTraitant.replacingOccurrences(of: ",", with: "."))
                            let fr = Double(fraisRembourser.replacingOccurrences(of: ",", with: "."))
                            
                            let updateData = SessionUpdate(
                                titre: titre, dateDebut: DateFormatter.apiDate.string(from: dateDebut),
                                dateFin: DateFormatter.apiDate.string(from: dateFin), heureDebut: DateFormatter.apiTime.string(from: heureDebut), heureFin: DateFormatter.apiTime.string(from: heureEnd), clientId: selectedClientId, ecoleId: selectedEcoleId, formateurId: selectedFormateurId, statut: statut,
                                prix: prix, modalite: modalite, lieu: lieu
                            )

                            if isEditing, let session = sessionToEdit {
                                // OPÉRATION MODIFIER (SESS-03)
                                await viewModel.updateSession(id: session.id, updateData: updateData)
                            } else {
                                // OPÉRATION CRÉER
                                await viewModel.createSession(
                                    titre: titre, dateDebut: dateDebut, dateFin: dateFin, statut: statut,
                                    modalite: modalite, lieu: lieu, heureDebut: heureDebut, heureFin: heureEnd,
                                    clientId: selectedClientId, ecoleId: selectedEcoleId, formateurId: selectedFormateurId,
                                    prix: prix, tarifSousTraitant: st, fraisRembourser: fr, refContrat: refContrat.isEmpty ? nil : refContrat
                                )
                            }
                            dismiss()
                        }
                    }
                    .disabled(titre.isEmpty)
                }
            }
            // Appelle fetchDependencies pour remplir les pickers (Clé de l'intégration)
            .task {
                await viewModel.fetchDependencies()
                loadSessionData()
            }
        }
    }
    // NOUVEAU: Fonction pour charger les données lors de l'édition
        private func loadSessionData() {
            guard let session = sessionToEdit else { return }
            
            titre = session.titre
            statut = session.statut
            
            // Map backend value (P/D or Full) to Picker tags (Full Strings)
            let modRaw = session.modalite ?? "P"
            if modRaw.prefix(1).uppercased() == "D" {
                modalite = "Distanciel"
            } else {
                modalite = "Présentiel"
            }

            lieu = session.lieu ?? ""
            
            // Convertit les Strings de date et heure en objets Date (nécessite des formateurs de date/heure)
            dateDebut = DateFormatter.apiDate.date(from: session.dateDebut) ?? Date()
            dateFin = DateFormatter.apiDate.date(from: session.dateFin) ?? Date()
            heureDebut = DateFormatter.apiTime.date(from: session.heureDebut ?? "09:00:00") ?? Date()
            heureEnd = DateFormatter.apiTime.date(from: session.heureFin ?? "17:00:00") ?? Date()
            
            selectedFormateurId = session.formateurId
            selectedClientId = session.clientId
            selectedEcoleId = session.ecoleId
            
            prixClient = String(format: "%.2f", session.prix ?? 0)
            // Les autres champs financiers nécessiteraient une mise à jour des models pour être persistés via l'API, ou gérés localement.
        }
}

extension DateFormatter {
    static let apiDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let apiTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}
