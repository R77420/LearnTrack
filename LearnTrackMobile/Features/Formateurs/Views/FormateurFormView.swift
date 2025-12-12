import SwiftUI

struct FormateurFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FormateurViewModel
    
    var formateurToEdit: Formateur?
    
    @State private var nom = ""
    @State private var prenom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var specialites = ""
    @State private var tarifJournalier = ""
    @State private var estInterne = true // Default to Interne as requested
    @State private var siret = ""
    @State private var nda = ""
    @State private var adresse = ""
    @State private var ville = ""
    @State private var codePostal = ""
    
    private var isEditing: Bool { formateurToEdit != nil }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Identité")) {
                    TextField("Nom", text: $nom)
                    TextField("Prénom", text: $prenom)
                    TextField("Email", text: $email)
                        #if os(iOS)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        #endif
                    TextField("Téléphone", text: $telephone)
                         #if os(iOS)
                        .keyboardType(.phonePad)
                        #endif
                }
                
                Section(header: Text("Adresse")) {
                    TextField("Adresse", text: $adresse)
                    HStack {
                        TextField("Code Postal", text: $codePostal)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif
                        TextField("Ville", text: $ville)
                    }
                }
                
                Section(header: Text("Professionnel")) {
                    TextField("Spécialités (séparées par virgule)", text: $specialites)
                    
                    TextField("Tarif Journalier (€)", text: $tarifJournalier)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                }
            }
            .navigationTitle(isEditing ? "Modifier Formateur" : "Nouveau Formateur")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Enregistrer" : "Créer") { // CORRECTION BOUTON
                        Task {
                            let specs = specialites.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                            let tarif = Double(tarifJournalier.replacingOccurrences(of: ",", with: "."))
                            
                            if let formateur = formateurToEdit {
                                // Opération MODIFIER (FORM-07)
                                let updateData = FormateurUpdate(
                                    nom: nom, prenom: prenom, email: email, telephone: telephone.isEmpty ? nil : telephone,
                                    specialites: specs.isEmpty ? nil : specs, tarifJournalier: tarif,
                                    adresse: adresse.isEmpty ? nil : adresse, ville: ville.isEmpty ? nil : ville, codePostal: codePostal.isEmpty ? nil : codePostal, estInterne: estInterne, siret: siret.isEmpty ? nil : siret, nda: nda.isEmpty ? nil : nda
                                )
                                await viewModel.updateFormateur(id: formateur.id, updateData: updateData)
                            } else {
                                // Opération CRÉER
                                await viewModel.createFormateur(
                                    nom: nom, prenom: prenom, email: email, telephone: telephone.isEmpty ? nil : telephone,
                                    specialites: specs.isEmpty ? nil : specs, tarifJournalier: tarif, estInterne: estInterne,
                                    siret: siret.isEmpty ? nil : siret, nda: nda.isEmpty ? nil : nda,
                                    adresse: adresse.isEmpty ? nil : adresse, ville: ville.isEmpty ? nil : ville,
                                    codePostal: codePostal.isEmpty ? nil : codePostal
                                )
                            }
                            dismiss()
                        }
                    }
                    .disabled(nom.isEmpty || prenom.isEmpty || email.isEmpty)
                }
            }
            // CORRECTION: Chargement des données à l'ouverture pour l'édition
            .onAppear {
                if isEditing, let formateur = formateurToEdit {
                    nom = formateur.nom
                    prenom = formateur.prenom
                    email = formateur.email
                    telephone = formateur.telephone ?? ""
                    specialites = formateur.specialites?.joined(separator: ", ") ?? ""
                    tarifJournalier = String(formateur.tarifJournalier ?? 0)
                    estInterne = formateur.estInterne ?? true
                    siret = formateur.siret ?? ""
                    nda = formateur.nda ?? ""
                    adresse = formateur.adresse ?? ""
                    ville = formateur.ville ?? ""
                    codePostal = formateur.codePostal ?? ""
                }
            }
        }
    }
}
